#!/bin/bash
set -e

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Banner
echo -e "${BLUE}${BOLD}"
echo "  ____  _    _  _____                                  _   "
echo " / ___|| |  | |/ ____|     /\                         | |  "
echo "| |    | |  | | |  __     /  \   __ _  ___ _ __  _   _| |_ "
echo "| |    | |/\| | | |_ |   / /\ \ / _\` |/ _ \ '_ \| | | | __|"
echo "| |____\  /\  / |__| |  / ____ \ (_| |  __/ | | | |_| | |_ "
echo " \_____| \/  \|\_____| /_/    \_\__, |\___|_| |_|\__,_|\__|"
echo "                                 __/ |                     "
echo "                                |___/                      "
echo -e "${NC}"
echo -e "${BOLD}Advanced Autoinstaller${NC}"
echo "This script will set up a virtual environment and install all dependencies for SWE-agent."
echo

# Function to check system dependencies
check_system_dependencies() {
    echo -e "${YELLOW}Checking system dependencies...${NC}"
    
    local missing_deps=()
    
    # Check for git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Check for npm/node
    if ! command -v npm &> /dev/null; then
        missing_deps+=("npm/nodejs")
    fi
    
    # Check for python
    if ! command -v python3 &> /dev/null; then
        missing_deps+=("python3")
    fi
    
    # Report missing dependencies
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}Missing system dependencies: ${missing_deps[*]}${NC}"
        echo "Please install these dependencies before continuing."
        
        # Suggest installation commands based on OS
        if [ -f /etc/debian_version ]; then
            echo -e "${YELLOW}For Debian/Ubuntu systems, you can install them with:${NC}"
            echo "sudo apt update"
            echo "sudo apt install git nodejs npm python3 python3-pip -y"
        elif [ -f /etc/redhat-release ]; then
            echo -e "${YELLOW}For RHEL/CentOS/Fedora systems, you can install them with:${NC}"
            echo "sudo dnf install git nodejs npm python3 python3-pip -y"
        elif [ -f /etc/arch-release ]; then
            echo -e "${YELLOW}For Arch Linux systems, you can install them with:${NC}"
            echo "sudo pacman -S git nodejs npm python python-pip"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "${YELLOW}For macOS systems, you can install them with Homebrew:${NC}"
            echo "brew install git node python"
        fi
        
        read -p "Do you want to continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}All system dependencies are installed.${NC}"
    fi
}

# Function to get user configuration
get_configuration() {
    # Default values
    PYTHON_VERSION="3.11"
    INSTALL_DEV=false
    INSTALL_FRONTEND=true
    
    # Ask for Python version
    echo -e "${YELLOW}Select Python version:${NC}"
    echo "1) Python 3.11 (recommended)"
    echo "2) Python 3.12"
    echo "3) Python 3.10"
    read -p "Enter your choice [1-3] (default: 1): " python_choice
    
    case $python_choice in
        2) PYTHON_VERSION="3.12" ;;
        3) PYTHON_VERSION="3.10" ;;
        *) PYTHON_VERSION="3.11" ;;
    esac
    
    # Ask for dev dependencies
    read -p "Install development dependencies? (y/n) [n]: " -n 1 -r dev_choice
    echo
    if [[ $dev_choice =~ ^[Yy]$ ]]; then
        INSTALL_DEV=true
    fi
    
    # Ask for frontend dependencies
    read -p "Install frontend dependencies (required for web UI)? (y/n) [y]: " -n 1 -r frontend_choice
    echo
    if [[ $frontend_choice =~ ^[Nn]$ ]]; then
        INSTALL_FRONTEND=false
    fi
    
    # Summary
    echo -e "${BLUE}Installation Configuration:${NC}"
    echo -e "  Python Version: ${BOLD}$PYTHON_VERSION${NC}"
    echo -e "  Development Dependencies: ${BOLD}$([ "$INSTALL_DEV" = true ] && echo "Yes" || echo "No")${NC}"
    echo -e "  Frontend Dependencies: ${BOLD}$([ "$INSTALL_FRONTEND" = true ] && echo "Yes" || echo "No")${NC}"
    
    read -p "Proceed with installation? (y/n) [y]: " -n 1 -r proceed
    echo
    if [[ ! $proceed =~ ^[Yy]$ ]] && [[ ! $proceed = "" ]]; then
        echo -e "${RED}Installation cancelled.${NC}"
        exit 0
    fi
}

# Check if we're using uv or conda
if command -v uv &> /dev/null; then
    INSTALLER="uv"
    echo -e "${GREEN}Using uv for environment management${NC}"
elif command -v conda &> /dev/null; then
    INSTALLER="conda"
    echo -e "${GREEN}Using conda for environment management${NC}"
else
    echo -e "${YELLOW}Neither uv nor conda is installed. Would you like to:${NC}"
    echo "1) Install uv (recommended)"
    echo "2) Use venv (Python's built-in virtual environment)"
    echo "3) Exit and install conda or uv manually"
    read -p "Enter your choice [1-3]: " installer_choice
    
    case $installer_choice in
        1)
            echo -e "${YELLOW}Installing uv...${NC}"
            curl -LsSf https://astral.sh/uv/install.sh | sh
            export PATH="$HOME/.cargo/bin:$PATH"
            INSTALLER="uv"
            ;;
        2)
            INSTALLER="venv"
            echo -e "${GREEN}Using venv for environment management${NC}"
            ;;
        *)
            echo -e "${RED}Please install either uv (https://github.com/astral-sh/uv) or conda (https://docs.conda.io/en/latest/miniconda.html) and run this script again.${NC}"
            exit 1
            ;;
    esac
fi

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

# Check system dependencies
check_system_dependencies

# Get user configuration
get_configuration

# Environment name
ENV_NAME="swe-agent-env"

echo -e "${YELLOW}Creating environment '$ENV_NAME' with Python $PYTHON_VERSION...${NC}"

if [ "$INSTALLER" = "uv" ]; then
    # Create a virtual environment using uv
    uv venv "$ENV_NAME" --python="$PYTHON_VERSION"
    
    # Activate the environment
    source "$ENV_NAME/bin/activate"
    
    echo -e "${GREEN}Installing dependencies with uv...${NC}"
    uv pip install -e .
    
    # Install dev dependencies if requested
    if [ "$INSTALL_DEV" = true ]; then
        echo -e "${YELLOW}Installing development dependencies...${NC}"
        uv pip install -e ".[dev]"
    fi
    
elif [ "$INSTALLER" = "conda" ]; then
    # Create a conda environment
    conda create -y -n "$ENV_NAME" python="$PYTHON_VERSION"
    
    # Activate the environment
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "$ENV_NAME"
    
    echo -e "${GREEN}Installing dependencies with conda/pip...${NC}"
    pip install -e .
    
    # Install dev dependencies if requested
    if [ "$INSTALL_DEV" = true ]; then
        echo -e "${YELLOW}Installing development dependencies...${NC}"
        pip install -e ".[dev]"
    fi
else
    # Create a venv environment
    python3 -m venv "$ENV_NAME"
    
    # Activate the environment
    source "$ENV_NAME/bin/activate"
    
    echo -e "${GREEN}Installing dependencies with pip...${NC}"
    pip install --upgrade pip
    pip install -e .
    
    # Install dev dependencies if requested
    if [ "$INSTALL_DEV" = true ]; then
        echo -e "${YELLOW}Installing development dependencies...${NC}"
        pip install -e ".[dev]"
    fi
fi

# Install frontend dependencies
if [ "$INSTALL_FRONTEND" = true ]; then
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
fi

# Create activation script
cat > activate_swe_agent.sh << EOF
#!/bin/bash
# This script activates the SWE-agent environment

if [ -f "$ENV_NAME/bin/activate" ]; then
    source "$ENV_NAME/bin/activate"
elif [ -f "$(conda info --base 2>/dev/null)/etc/profile.d/conda.sh" ]; then
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "$ENV_NAME"
else
    echo "Error: Could not find environment activation script."
    exit 1
fi

echo "SWE-agent environment activated. You can now run:"
echo "  python -m sweagent"
echo "  ./start_web_ui.sh"
EOF

chmod +x activate_swe_agent.sh

echo -e "\n${GREEN}${BOLD}Installation complete!${NC}"
echo -e "To activate the environment, run:"
echo -e "  ${YELLOW}source ./activate_swe_agent.sh${NC}"

echo -e "\nTo run SWE-agent:"
echo -e "  ${YELLOW}python -m sweagent${NC}"
echo -e "\nTo run the web UI:"
echo -e "  ${YELLOW}./start_web_ui.sh${NC}"

echo -e "\n${BOLD}Enjoy using SWE-agent!${NC}"