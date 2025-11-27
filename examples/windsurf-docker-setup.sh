#!/bin/bash
# Windsurf Docker Setup Script
# This script helps set up Windsurf in headless mode using Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Windsurf Docker Setup for Headless Mode"
echo "=========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker daemon is not running.${NC}"
    echo "Please start Docker daemon and try again."
    exit 1
fi

# Check if WINDSURF_TOKEN is set
if [ -z "$WINDSURF_TOKEN" ]; then
    echo -e "${YELLOW}Warning: WINDSURF_TOKEN is not set.${NC}"
    echo "To get your token:"
    echo "1. Open Windsurf IDE"
    echo "2. Press Ctrl+Shift+P (or Cmd+Shift+P on macOS)"
    echo "3. Run command: 'Provide auth token'"
    echo "4. Copy the token and set: export WINDSURF_TOKEN=your_token"
    echo ""
    read -p "Do you want to continue without token? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Set default paths
WORKSPACE_PATH="${1:-$(pwd)/workspace}"
CONFIG_PATH="${2:-$HOME/.config/Windsurf}"

echo -e "${BLUE}Configuration:${NC}"
echo "  Workspace: $WORKSPACE_PATH"
echo "  Config: $CONFIG_PATH"
echo ""

# Create workspace directory
echo -e "${BLUE}Creating workspace directory...${NC}"
mkdir -p "$WORKSPACE_PATH"
chown -R 1000:1000 "$WORKSPACE_PATH" 2>/dev/null || sudo chown -R 1000:1000 "$WORKSPACE_PATH"

# Create instructions file if it doesn't exist
if [ ! -f "$WORKSPACE_PATH/windsurf-instructions.txt" ]; then
    echo -e "${BLUE}Creating windsurf-instructions.txt...${NC}"
    cat > "$WORKSPACE_PATH/windsurf-instructions.txt" <<EOF
# Windsurf Instructions

Your task prompt goes here.

Example:
- Review code for bugs and security issues
- Generate unit tests for this project
- Refactor code to improve quality
EOF
    echo -e "${GREEN}Created: $WORKSPACE_PATH/windsurf-instructions.txt${NC}"
    echo -e "${YELLOW}Please edit this file with your task prompt.${NC}"
fi

# Clone or check windsurfinabox
WINDSURF_DIR="windsurfinabox"
if [ ! -d "$WINDSURF_DIR" ]; then
    echo -e "${BLUE}Cloning windsurfinabox repository...${NC}"
    git clone https://github.com/pfcoperez/windsurfinabox.git "$WINDSURF_DIR"
else
    echo -e "${BLUE}Updating windsurfinabox repository...${NC}"
    cd "$WINDSURF_DIR"
    git pull
    cd ..
fi

# Build Docker image
echo -e "${BLUE}Building Windsurf Docker image...${NC}"
cd "$WINDSURF_DIR"
docker build . -t windsurf
cd ..

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_PATH"

# Run Docker container
echo -e "${BLUE}Running Windsurf in headless mode...${NC}"
echo -e "${YELLOW}This will start Windsurf in a Docker container.${NC}"
echo ""

docker run --rm -it --name windsurf \
  -e WINDSURF_TOKEN="${WINDSURF_TOKEN:-}" \
  -v "$CONFIG_PATH:/home/ubuntu/.config/Windsurf" \
  -v "$WORKSPACE_PATH:/home/ubuntu/workspace" \
  windsurf

echo ""
echo -e "${GREEN}Windsurf headless mode completed!${NC}"
echo "Check your workspace directory for results."

