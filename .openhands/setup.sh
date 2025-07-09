#!/usr/bin/env bash

# SWE-agent Setup Script for OpenHands
# This script sets up the SWE-agent environment with all necessary dependencies

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}🚀 Setting up SWE-agent environment...${NC}"
echo -e "${BLUE}Project root: ${PROJECT_ROOT}${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Python version
check_python_version() {
    if command_exists python3; then
        local python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        local required_version="3.11"
        
        if python3 -c "import sys; exit(0 if sys.version_info >= (3, 11) else 1)" 2>/dev/null; then
            print_status "Python ${python_version} found (>= ${required_version} required)"
            return 0
        else
            print_error "Python ${python_version} found, but >= ${required_version} is required"
            return 1
        fi
    else
        print_error "Python 3 not found"
        return 1
    fi
}

# Function to check Node.js version
check_nodejs() {
    if command_exists node && command_exists npm; then
        local node_version=$(node --version)
        print_status "Node.js ${node_version} found"
        return 0
    else
        print_warning "Node.js/npm not found - required for web UI"
        print_info "Install Node.js from: https://nodejs.org/"
        return 1
    fi
}

# Function to check Docker
check_docker() {
    if command_exists docker; then
        if docker info >/dev/null 2>&1; then
            print_status "Docker is installed and running"
            return 0
        else
            print_warning "Docker is installed but not running"
            print_info "Please start Docker daemon"
            return 1
        fi
    else
        print_warning "Docker not found - recommended for isolated environments"
        print_info "Install Docker from: https://docs.docker.com/get-docker/"
        return 1
    fi
}

# Function to install Python dependencies
install_python_deps() {
    print_info "Installing Python dependencies..."
    
    cd "$PROJECT_ROOT"
    
    # Upgrade pip first
    python3 -m pip install --upgrade pip
    
    # Install the package in editable mode
    python3 -m pip install --editable .
    
    print_status "Python dependencies installed"
}

# Function to install Node.js dependencies for frontend
install_nodejs_deps() {
    if command_exists npm; then
        print_info "Installing Node.js dependencies for frontend..."
        
        cd "$PROJECT_ROOT/sweagent/frontend"
        
        # Install npm dependencies
        npm install
        
        print_status "Node.js dependencies installed"
        cd "$PROJECT_ROOT"
    else
        print_warning "Skipping Node.js dependencies (npm not found)"
    fi
}

# Function to verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    cd "$PROJECT_ROOT"
    
    # Check if sweagent command is available
    if command_exists sweagent; then
        print_status "sweagent command is available"
    elif python3 -m sweagent --help >/dev/null 2>&1; then
        print_status "sweagent module is available via 'python3 -m sweagent'"
    else
        print_error "sweagent installation verification failed"
        return 1
    fi
    
    # Check if frontend dependencies are installed
    if [ -d "$PROJECT_ROOT/sweagent/frontend/node_modules" ]; then
        print_status "Frontend dependencies are installed"
    else
        print_warning "Frontend dependencies not found"
    fi
}

# Function to display post-installation instructions
show_post_install_info() {
    echo
    echo -e "${GREEN}🎉 Setup completed!${NC}"
    echo
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Set up your language model API keys (see docs/installation/keys.md)"
    echo "2. Test the installation:"
    echo "   ${YELLOW}sweagent --help${NC} (or ${YELLOW}python3 -m sweagent --help${NC})"
    echo
    echo -e "${BLUE}To run the web UI:${NC}"
    echo "   ${YELLOW}./start_web_ui.sh${NC}"
    echo
    echo -e "${BLUE}Documentation:${NC} https://swe-agent.com/latest/"
    echo -e "${BLUE}Discord:${NC} https://discord.gg/AVEFbBn2rH"
    echo
}

# Main setup function
main() {
    echo -e "${BLUE}Checking system requirements...${NC}"
    
    # Check system requirements
    local python_ok=false
    local nodejs_ok=false
    local docker_ok=false
    
    if check_python_version; then
        python_ok=true
    fi
    
    if check_nodejs; then
        nodejs_ok=true
    fi
    
    if check_docker; then
        docker_ok=true
    fi
    
    # Exit if Python is not available
    if [ "$python_ok" = false ]; then
        print_error "Python 3.11+ is required but not found"
        exit 1
    fi
    
    echo
    echo -e "${BLUE}Installing dependencies...${NC}"
    
    # Install Python dependencies
    install_python_deps
    
    # Install Node.js dependencies if available
    if [ "$nodejs_ok" = true ]; then
        install_nodejs_deps
    fi
    
    echo
    echo -e "${BLUE}Verifying installation...${NC}"
    
    # Verify installation
    if verify_installation; then
        show_post_install_info
    else
        print_error "Installation verification failed"
        exit 1
    fi
    
    # Show warnings for missing optional dependencies
    if [ "$nodejs_ok" = false ]; then
        echo -e "${YELLOW}Note: Node.js not found - web UI will not be available${NC}"
    fi
    
    if [ "$docker_ok" = false ]; then
        echo -e "${YELLOW}Note: Docker not found - some features may be limited${NC}"
    fi
}

# Run main function
main "$@"