#!/bin/bash
# ArtificialFlash Startup Script
# Starts both the backend server and Flutter app

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting ArtificialFlash Backend...${NC}"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}Python3 not found. Please install Python 3.10+${NC}"
    exit 1
fi

# Navigate to backend directory
cd "$(dirname "$0")/backend" || exit 1

# Install dependencies if needed
if [ ! -d "venv" ] && [ ! -d "__pycache__" ]; then
    echo -e "${YELLOW}Installing backend dependencies...${NC}"
    pip3 install -r requirements.txt
fi

# Start backend in background
echo -e "${GREEN}Starting FastAPI backend on http://localhost:8000${NC}"
python3 main.py &
BACKEND_PID=$!

# Wait for backend to start
sleep 3

# Check if backend is running
if kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${GREEN}Backend started successfully! (PID: $BACKEND_PID)${NC}"
else
    echo -e "${YELLOW}Failed to start backend${NC}"
    exit 1
fi

# Start Flutter app
echo -e "${GREEN}Starting ArtificialFlash Flutter app...${NC}"
cd ..
flutter run

# Cleanup when Flutter exits
echo -e "${YELLOW}Stopping backend...${NC}"
kill $BACKEND_PID 2>/dev/null
echo -e "${GREEN}Done!${NC}"