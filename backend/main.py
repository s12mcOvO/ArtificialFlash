"""
ArtificialFlash Backend - AI Training Assistant API Server
FastAPI backend for model training, data management, and inference.
"""

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from typing import List, Dict, Any, Optional
import asyncio
import json
import random
import os
from pathlib import Path
from datetime import datetime
import uuid

from training_manager import training_manager

app = FastAPI(title="ArtificialFlash API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# In-memory storage (replace with database in production)
models_db: Dict[str, Dict[str, Any]] = {}
datasets_db: Dict[str, Dict[str, Any]] = {}

# ==================== WebSocket ====================

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []
    
    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)
    
    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)
    
    async def send_message(self, message: Dict[str, Any], websocket: WebSocket):
        await websocket.send_json(message)
    
    async def broadcast(self, message: Dict[str, Any]):
        for connection in self.active_connections:
            await connection.send_json(message)

manager = ConnectionManager()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            message = json.loads(data)
            
            msg_type = message.get('type')
            
            if msg_type == 'ping':
                await manager.send_message({'type': 'pong'}, websocket)
            elif msg_type == 'subscribe':
                session_id = message.get('session_id')
                # Handle subscription to training session updates
                await manager.send_message({
                    'type': 'subscribed',
                    'session_id': session_id
                }, websocket)
                
    except WebSocketDisconnect:
        manager.disconnect(websocket)

# ==================== Health ====================

@app.get("/")
async def root():
    return {"status": "ok", "message": "ArtificialFlash API is running"}

@app.get("/api/v1/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

# ==================== Datasets ====================

@app.get("/api/v1/datasets")
async def list_datasets():
    return list(datasets_db.values())

@app.post("/api/v1/datasets")
async def create_dataset(name: str, path: str, type: str):
    dataset_id = str(uuid.uuid4())
    dataset = {
        'id': dataset_id,
        'name': name,
        'path': path,
        'type': type,
        'status': 'ready',
        'file_count': 0,
        'created_at': datetime.now().isoformat()
    }
    datasets_db[dataset_id] = dataset
    return dataset

@app.get("/api/v1/datasets/{dataset_id}")
async def get_dataset(dataset_id: str):
    if dataset_id not in datasets_db:
        raise HTTPException(status_code=404, detail="Dataset not found")
    return datasets_db[dataset_id]

@app.delete("/api/v1/datasets/{dataset_id}")
async def delete_dataset(dataset_id: str):
    if dataset_id not in datasets_db:
        raise HTTPException(status_code=404, detail="Dataset not found")
    del datasets_db[dataset_id]
    return {"message": "Dataset deleted"}

# ==================== Models ====================

@app.get("/api/v1/models")
async def list_models():
    return list(models_db.values())

@app.post("/api/v1/models")
async def create_model(
    name: str,
    type: str,
    base_model: Optional[str] = None,
    dataset_id: Optional[str] = None,
    params: Optional[Dict[str, Any]] = None
):
    model_id = str(uuid.uuid4())
    model = {
        'id': model_id,
        'name': name,
        'type': type,
        'base_model': base_model,
        'status': 'pending',
        'dataset_id': dataset_id,
        'params': params or {},
        'created_at': datetime.now().isoformat()
    }
    models_db[model_id] = model
    return model

@app.get("/api/v1/models/{model_id}")
async def get_model(model_id: str):
    if model_id not in models_db:
        raise HTTPException(status_code=404, detail="Model not found")
    return models_db[model_id]

@app.delete("/api/v1/models/{model_id}")
async def delete_model(model_id: str):
    if model_id not in models_db:
        raise HTTPException(status_code=404, detail="Model not found")
    del models_db[model_id]
    return {"message": "Model deleted"}

@app.post("/api/v1/models/{model_id}/export")
async def export_model(model_id: str, format: str):
    if model_id not in models_db:
        raise HTTPException(status_code=404, detail="Model not found")
    
    model = models_db[model_id]
    model['status'] = 'exported'
    model['export_format'] = format
    model['exported_at'] = datetime.now().isoformat()
    
    return {
        "message": f"Model exported as {format}",
        "model": model
    }

# ==================== Training ====================

@app.post("/api/v1/training/start")
async def start_training(model_id: str, session_id: Optional[str] = None):
    if model_id not in models_db:
        raise HTTPException(status_code=404, detail="Model not found")
    
    model = models_db[model_id]
    params = model.get('params', {})
    mode = params.get('mode', 'local')
    
    total_epochs = params.get('epochs', 10)
    
    if session_id is None:
        session = training_manager.create_session(model_id, mode)
    else:
        session = training_manager.get_session(session_id)
        if session is None:
            session = training_manager.create_session(model_id, mode)
    
    session['total_epochs'] = total_epochs
    session['status'] = 'training'
    
    model['status'] = 'training'
    
    asyncio.create_task(simulate_training(session, model))
    
    return {
        "message": "Training started",
        "session": session
    }

async def simulate_training(session: Dict[str, Any], model: Dict[str, Any]):
    """Simulate training progress for demonstration."""
    import time
    
    total_epochs = session.get('total_epochs', 10)
    session_id = session['id']
    
    for epoch in range(1, total_epochs + 1):
        session = training_manager.get_session(session_id)
        if session is None or session.get('status') == 'stopped':
            break
        
        for step in range(10):
            loss = random.uniform(0.1, 2.0) * (1 - epoch / total_epochs)
            accuracy = random.uniform(0.5, 0.99) * (epoch / total_epochs)
            
            log_data = {
                'epoch': epoch,
                'step': step,
                'loss': loss,
                'accuracy': accuracy,
                'message': f'Epoch {epoch}, Step {step}: loss={loss:.4f}, acc={accuracy:.4f}',
                'timestamp': datetime.now().isoformat()
            }
            
            training_manager.add_log(session_id, log_data)
            training_manager.update_session(session_id, {
                'current_epoch': epoch,
                'current_loss': loss,
                'current_accuracy': accuracy,
                'progress': epoch / total_epochs
            })
            
            message = {
                'type': 'training_update',
                'data': log_data
            }
            await manager.broadcast(message)
            
            await asyncio.sleep(0.5)
        
        # Pause check
        session = training_manager.get_session(session_id)
        while session and session.get('status') == 'paused':
            await asyncio.sleep(0.5)
            session = training_manager.get_session(session_id)
    
    # Training complete
    training_manager.close_session(session_id)
    training_manager.update_session(session_id, {
        'status': 'completed',
        'progress': 1.0,
        'current_accuracy': random.uniform(0.85, 0.98),
        'current_loss': random.uniform(0.05, 0.2)
    })
    
    model['status'] = 'ready'
    model['accuracy'] = random.uniform(0.85, 0.98)
    model['loss'] = random.uniform(0.05, 0.2)
    model['trained_at'] = datetime.now().isoformat()
    
    await manager.broadcast({
        'type': 'training_complete',
        'data': {
            'session_id': session_id,
            'model': model
        }
    })

@app.post("/api/v1/training/pause")
async def pause_training():
    # Find active training session
    for session in training_manager.active_sessions.values():
        if session.get('status') == 'training':
            session['status'] = 'paused'
            await manager.broadcast({
                'type': 'training_paused',
                'session_id': session['id']
            })
            return {"message": "Training paused", "session_id": session['id']}
    
    raise HTTPException(status_code=404, detail="No active training session")

@app.post("/api/v1/training/resume")
async def resume_training():
    # Find paused training session
    for session in training_manager.active_sessions.values():
        if session.get('status') == 'paused':
            session['status'] = 'training'
            await manager.broadcast({
                'type': 'training_resumed',
                'session_id': session['id']
            })
            return {"message": "Training resumed", "session_id": session['id']}
    
    raise HTTPException(status_code=404, detail="No paused training session")

@app.post("/api/v1/training/stop")
async def stop_training():
    for session in training_manager.active_sessions.values():
        if session.get('status') in ['training', 'paused', 'preparing']:
            session['status'] = 'stopped'
            await manager.broadcast({
                'type': 'training_stopped',
                'session_id': session['id']
            })
            return {"message": "Training stopped", "session_id": session['id']}
    
    raise HTTPException(status_code=404, detail="No active training session")

@app.get("/api/v1/training/session/{session_id}")
async def get_training_session(session_id: str):
    session = training_manager.get_session(session_id)
    if session is None:
        raise HTTPException(status_code=404, detail="Session not found")
    return session

# ==================== Inference ====================

@app.post("/api/v1/inference/predict")
async def predict(model_id: str, input_data: Dict[str, Any]):
    if model_id not in models_db:
        raise HTTPException(status_code=404, detail="Model not found")
    
    model = models_db[model_id]
    if model['status'] != 'ready':
        raise HTTPException(status_code=400, detail="Model is not ready for inference")
    
    # Mock inference response
    return {
        "model_id": model_id,
        "prediction": {
            "class": "unknown",
            "confidence": 0.95
        },
        "timestamp": datetime.now().isoformat()
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)