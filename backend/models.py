"""
PyTorch Model Definitions for ArtificialFlash
Supports image classification, text classification, and other model types.
"""

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from typing import Optional, Tuple, List, Any
import numpy as np


class SimpleImageDataset(Dataset):
    """Simple dataset for image classification."""
    
    def __init__(self, data: List[Tuple[np.ndarray, int]], transform=None):
        self.data = data
        self.transform = transform
    
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        image, label = self.data[idx]
        if self.transform:
            image = self.transform(image)
        return torch.FloatTensor(image), torch.LongTensor([label])[0]


class SimpleTextDataset(Dataset):
    """Simple dataset for text classification."""
    
    def __init__(self, texts: List[str], labels: List[int], vocab: dict, max_length: int = 128):
        self.texts = texts
        self.labels = labels
        self.vocab = vocab
        self.max_length = max_length
    
    def __len__(self):
        return len(self.texts)
    
    def __getitem__(self, idx):
        text = self.texts[idx]
        # Simple tokenization
        tokens = [self.vocab.get(word, 0) for word in text.split()[:self.max_length]]
        # Pad
        tokens = tokens + [0] * (self.max_length - len(tokens))
        return torch.LongTensor(tokens), torch.LongTensor([self.labels[idx]])[0]


class SimpleCNN(nn.Module):
    """Simple CNN for image classification."""
    
    def __init__(self, num_classes: int = 10, image_size: int = 28):
        super().__init__()
        
        self.features = nn.Sequential(
            nn.Conv2d(1, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            nn.Conv2d(64, 128, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.AdaptiveAvgPool2d((4, 4)),
        )
        
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(128 * 16, 256),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(256, num_classes),
        )
    
    def forward(self, x):
        x = self.features(x)
        x = self.classifier(x)
        return x


class SimpleTextClassifier(nn.Module):
    """Simple LSTM for text classification."""
    
    def __init__(self, vocab_size: int, embedding_dim: int = 128, hidden_dim: int = 128, num_classes: int = 2):
        super().__init__()
        
        self.embedding = nn.Embedding(vocab_size, embedding_dim)
        self.lstm = nn.LSTM(embedding_dim, hidden_dim, batch_first=True)
        self.classifier = nn.Sequential(
            nn.Linear(hidden_dim, 64),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(64, num_classes),
        )
    
    def forward(self, x):
        embedded = self.embedding(x)
        _, (hidden, _) = self.lstm(embedded)
        output = self.classifier(hidden[-1])
        return output


class SimpleMLP(nn.Module):
    """Simple MLP for simple classification."""
    
    def __init__(self, input_dim: int, num_classes: int = 10):
        super().__init__()
        
        self.network = nn.Sequential(
            nn.Linear(input_dim, 256),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(256, 128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128, num_classes),
        )
    
    def forward(self, x):
        return self.network(x)


def create_model(model_type: str, num_classes: int = 10, **kwargs) -> nn.Module:
    """Create a model based on type."""
    
    if model_type == 'image_classification':
        image_size = kwargs.get('image_size', 28)
        return SimpleCNN(num_classes=num_classes, image_size=image_size)
    
    elif model_type == 'text_classification' or model_type == 'sentiment_analysis':
        vocab_size = kwargs.get('vocab_size', 10000)
        return SimpleTextClassifier(
            vocab_size=vocab_size,
            embedding_dim=kwargs.get('embedding_dim', 128),
            hidden_dim=kwargs.get('hidden_dim', 128),
            num_classes=num_classes
        )
    
    else:
        # Default MLP for other types
        input_dim = kwargs.get('input_dim', 784)
        return SimpleMLP(input_dim=input_dim, num_classes=num_classes)


def train_epoch(
    model: nn.Module,
    dataloader: DataLoader,
    criterion: nn.Module,
    optimizer: optim.Optimizer,
    device: str = 'cpu'
) -> Tuple[float, float]:
    """Train for one epoch."""
    
    model.train()
    total_loss = 0
    correct = 0
    total = 0
    
    for batch_idx, (data, target) in enumerate(dataloader):
        data, target = data.to(device), target.to(device)
        
        optimizer.zero_grad()
        output = model(data)
        loss = criterion(output, target)
        loss.backward()
        optimizer.step()
        
        total_loss += loss.item()
        pred = output.argmax(dim=1)
        correct += (pred == target).sum().item()
        total += target.size(0)
    
    avg_loss = total_loss / len(dataloader)
    accuracy = correct / total
    return avg_loss, accuracy


def evaluate(
    model: nn.Module,
    dataloader: DataLoader,
    criterion: nn.Module,
    device: str = 'cpu'
) -> Tuple[float, float]:
    """Evaluate the model."""
    
    model.eval()
    total_loss = 0
    correct = 0
    total = 0
    
    with torch.no_grad():
        for data, target in dataloader:
            data, target = data.to(device), target.to(device)
            output = model(data)
            loss = criterion(output, target)
            
            total_loss += loss.item()
            pred = output.argmax(dim=1)
            correct += (pred == target).sum().item()
            total += target.size(0)
    
    avg_loss = total_loss / len(dataloader)
    accuracy = correct / total
    return avg_loss, accuracy


def prepare_dummy_data(
    model_type: str,
    num_samples: int = 100,
    num_classes: int = 10
) -> DataLoader:
    """Prepare dummy data for training demonstration."""
    
    if 'image' in model_type:
        # Generate dummy image data (grayscale 28x28)
        images = []
        labels = []
        for i in range(num_samples):
            img = np.random.randn(1, 28, 28).astype(np.float32)
            label = np.random.randint(0, num_classes)
            images.append((img, label))
        
        dataset = SimpleImageDataset(images)
        batch_size = 16
        return DataLoader(dataset, batch_size=batch_size, shuffle=True)
    
    elif 'text' in model_type or 'sentiment' in model_type:
        # Generate dummy text data
        texts = [f"sample text {i}" for i in range(num_samples)]
        labels = [np.random.randint(0, 2) for _ in range(num_samples)]
        vocab = {'sample': 1, 'text': 2, 'positive': 3, 'negative': 4}
        
        dataset = SimpleTextDataset(texts, labels, vocab, max_length=32)
        batch_size = 16
        return DataLoader(dataset, batch_size=batch_size, shuffle=True)
    
    else:
        # Generic tabular data
        data = [(np.random.randn(784).astype(np.float32), 
                 np.random.randint(0, num_classes)) for _ in range(num_samples)]
        
        class TabularDataset(Dataset):
            def __init__(self, data):
                self.data = data
            def __len__(self):
                return len(self.data)
            def __getitem__(self, idx):
                x, y = self.data[idx]
                return torch.FloatTensor(x), torch.LongTensor([y])[0]
        
        dataset = TabularDataset(data)
        batch_size = 16
        return DataLoader(dataset, batch_size=batch_size, shuffle=True)