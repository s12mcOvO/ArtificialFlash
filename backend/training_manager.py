import asyncio
import json
from datetime import datetime
from typing import Dict, Any, Optional
from pathlib import Path
import uuid

class TrainingManager:
    def __init__(self):
        self.active_sessions: Dict[str, Dict[str, Any]] = {}
        self.models: Dict[str, Dict[str, Any]] = {}
        self.datasets: Dict[str, Dict[str, Any]] = {}
    
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

training_manager = TrainingManager()