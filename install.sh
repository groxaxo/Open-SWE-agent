#!/bin/bash
set -e

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}SWE-agent Autoinstaller${NC}"
echo "This script will set up a virtual environment and install all dependencies for SWE-agent."
echo

# Check if we're using uv or conda
if command -v uv &> /dev/null; then
    INSTALLER="uv"
    echo -e "${GREEN}Using uv for environment management${NC}"
elif command -v conda &> /dev/null; then
    INSTALLER="conda"
    echo -e "${GREEN}Using conda for environment management${NC}"
else
    echo -e "${RED}Error: Neither uv nor conda is installed.${NC}"
    echo "Please install either uv (https://github.com/astral-sh/uv) or conda (https://docs.conda.io/en/latest/miniconda.html)"
    exit 1
fi

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

# Environment name
ENV_NAME="swe-agent-env"

# Python version
PYTHON_VERSION="3.11"

echo -e "${YELLOW}Creating environment '$ENV_NAME' with Python $PYTHON_VERSION...${NC}"

if [ "$INSTALLER" = "uv" ]; then
    # Create a virtual environment using uv
    uv venv "$ENV_NAME" --python="$PYTHON_VERSION"
    
    # Activate the environment
    source "$ENV_NAME/bin/activate"
    
    echo -e "${GREEN}Installing dependencies with uv...${NC}"
    uv pip install -e .
    
    # Install dev dependencies if requested
    read -p "Do you want to install development dependencies? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installing development dependencies...${NC}"
        uv pip install -e ".[dev]"
    fi
    
else
    # Create a conda environment
    conda create -y -n "$ENV_NAME" python="$PYTHON_VERSION"
    
    # Activate the environment
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "$ENV_NAME"
    
    echo -e "${GREEN}Installing dependencies with conda/pip...${NC}"
    pip install -e .
    
    # Install dev dependencies if requested
    read -p "Do you want to install development dependencies? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installing development dependencies...${NC}"
        pip install -e ".[dev]"
    fi
fi

# Install frontend dependencies
echo -e "${YELLOW}Installing frontend dependencies...${NC}"
if [ -d "sweagent/frontend" ]; then
    cd sweagent/frontend
    if command -v npm &> /dev/null; then
        npm install
    else
        echo -e "${RED}Warning: npm not found. Skipping frontend dependencies installation.${NC}"
        echo "Please install Node.js and npm to use the web UI."
    fi
    cd "$SCRIPT_DIR"
fi

echo -e "\n${GREEN}${BOLD}Installation complete!${NC}"
echo -e "To activate the environment:"
if [ "$INSTALLER" = "uv" ]; then
    echo -e "  ${YELLOW}source $ENV_NAME/bin/activate${NC}"
else
    echo -e "  ${YELLOW}conda activate $ENV_NAME${NC}"
fi

echo -e "\nTo run SWE-agent:"
echo -e "  ${YELLOW}python -m sweagent${NC}"
echo -e "\nTo run the web UI:"
echo -e "  ${YELLOW}./start_web_ui.sh${NC}"

echo -e "\n${BOLD}Enjoy using SWE-agent!${NC}"