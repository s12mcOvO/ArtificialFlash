import asyncio
import json
from datetime import datetime
from typing import Dict, Any, Optional, List
from pathlib import Path
import uuid
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader

try:
    from models import (
        create_model, 
        prepare_dummy_data, 
        train_epoch, 
        evaluate
    )
    PYTORCH_AVAILABLE = True
except ImportError:
    PYTORCH_AVAILABLE = False


class TrainingManager:
    def __init__(self):
        self.active_sessions: Dict[str, Dict[str, Any]] = {}
        self.models: Dict[str, Dict[str, Any]] = {}
        self.datasets: Dict[str, Dict[str, Any]] = {}
        self.pytorch_models: Dict[str, nn.Module] = {}
        
    def create_session(self, model_id: str, mode: str) -> Dict[str, Any]:
        session_id = str(uuid.uuid4())
        session = {
            'id': session_id,
            'model_id': model_id,
            'status': 'preparing',
            'mode': mode,
            'current_epoch': 0,
            'total_epochs': 0,
            'progress': 0.0,
            'current_loss': 0.0,
            'current_accuracy': 0.0,
            'logs': [],
            'started_at': datetime.now().isoformat(),
            'error_message': None
        }
        self.active_sessions[session_id] = session
        return session
    
    def get_session(self, session_id: str) -> Optional[Dict[str, Any]]:
        return self.active_sessions.get(session_id)
    
    def update_session(self, session_id: str, data: Dict[str, Any]) -> None:
        if session_id in self.active_sessions:
            self.active_sessions[session_id].update(data)
    
    def add_log(self, session_id: str, log: Dict[str, Any]) -> None:
        if session_id in self.active_sessions:
            self.active_sessions[session_id]['logs'].append(log)
    
    def close_session(self, session_id: str) -> None:
        if session_id in self.active_sessions:
            self.active_sessions[session_id]['status'] = 'completed'
            self.active_sessions[session_id]['completed_at'] = datetime.now().isoformat()
    
    def remove_session(self, session_id: str) -> None:
        if session_id in self.active_sessions:
            del self.active_sessions[session_id]

    async def run_training(
        self, 
        session_id: str,
        model_config: Dict[str, Any],
        progress_callback: Optional[callable] = None
    ) -> Dict[str, Any]:
        """Run actual PyTorch training with progress updates."""
        
        if not PYTORCH_AVAILABLE:
            return {"error": "PyTorch not available"}
        
        session = self.get_session(session_id)
        if session is None:
            return {"error": "Session not found"}
        
        model_type = model_config.get('type', 'image_classification')
        num_classes = model_config.get('num_classes', 10)
        epochs = model_config.get('epochs', 10)
        learning_rate = model_config.get('learning_rate', 0.001)
        batch_size = model_config.get('batch_size', 16)
        
        try:
            # Create PyTorch model
            model = create_model(model_type, num_classes=num_classes)
            self.pytorch_models[session_id] = model
            
            # Prepare data
            train_loader = prepare_dummy_data(model_type, num_samples=100, num_classes=num_classes)
            val_loader = prepare_dummy_data(model_type, num_samples=20, num_classes=num_classes)
            
            # Setup training
            device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
            model = model.to(device)
            
            criterion = nn.CrossEntropyLoss()
            optimizer = optim.Adam(model.parameters(), lr=learning_rate)
            
            # Training loop
            self.update_session(session_id, {'status': 'training'})
            
            for epoch in range(1, epochs + 1):
                session = self.get_session(session_id)
                if session is None or session.get('status') == 'stopped':
                    break
                
                # Check for pause
                while session and session.get('status') == 'paused':
                    await asyncio.sleep(0.5)
                    session = self.get_session(session_id)
                    if session is None:
                        break
                
                if session is None:
                    break
                
                # Train one epoch
                train_loss, train_acc = train_epoch(
                    model, train_loader, criterion, optimizer, device=str(device)
                )
                
                # Evaluate
                val_loss, val_acc = evaluate(
                    model, val_loader, criterion, device=str(device)
                )
                
                # Update session
                progress = epoch / epochs
                self.update_session(session_id, {
                    'current_epoch': epoch,
                    'total_epochs': epochs,
                    'current_loss': val_loss,
                    'current_accuracy': val_acc,
                    'progress': progress
                })
                
                # Log
                log_data = {
                    'epoch': epoch,
                    'step': 0,
                    'loss': float(train_loss),
                    'accuracy': float(train_acc),
                    'val_loss': float(val_loss),
                    'val_accuracy': float(val_acc),
                    'message': f'Epoch {epoch}/{epochs}: loss={train_loss:.4f}, acc={train_acc:.4f}, val_loss={val_loss:.4f}, val_acc={val_acc:.4f}',
                    'timestamp': datetime.now().isoformat()
                }
                self.add_log(session_id, log_data)
                
                # Callback for progress
                if progress_callback:
                    await progress_callback(session_id, log_data)
                
                await asyncio.sleep(0.5)
            
            # Save model
            if session_id in self.pytorch_models:
                trained_model = self.pytorch_models[session_id]
                model_path = Path(f"models/{session_id}.pt")
                model_path.parent.mkdir(parents=True, exist_ok=True)
                torch.save(trained_model.state_dict(), model_path)
                
                self.update_session(session_id, {
                    'status': 'completed',
                    'progress': 1.0,
                    'model_path': str(model_path)
                })
                return {"status": "completed", "model_path": str(model_path)}
            
            self.update_session(session_id, {'status': 'completed', 'progress': 1.0})
            return {"status": "completed"}
            
        except Exception as e:
            self.update_session(session_id, {
                'status': 'error',
                'error_message': str(e)
            })
            return {"error": str(e)}
    
    def export_model(self, session_id: str, format: str = 'onnx') -> Optional[str]:
        """Export trained model to specified format."""
        
        if session_id not in self.pytorch_models:
            return None
        
        model = self.pytorch_models[session_id]
        
        if format == 'onnx':
            try:
                import torch.onnx
                dummy_input = torch.randn(1, 1, 28, 28)
                output_path = f"models/{session_id}.onnx"
                torch.onnx.export(
                    model, 
                    dummy_input, 
                    output_path,
                    input_names=['input'],
                    output_names=['output'],
                    dynamic_axes={'input': {0: 'batch_size'}, 'output': {0: 'batch_size'}}
                )
                return output_path
            except Exception as e:
                print(f"ONNX export failed: {e}")
                return None
        
        elif format == 'torch':
            output_path = f"models/{session_id}.pt"
            torch.save(model.state_dict(), output_path)
            return output_path
        
        return None


training_manager = TrainingManager()