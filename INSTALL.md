# SWE-agent Installation Guide

This guide provides instructions for installing SWE-agent using the provided installation scripts.

## Quick Installation

For a quick installation with default settings, run:

```bash
./install.sh
```

This script will:
1. Create a virtual environment using uv or conda (whichever is available)
2. Install all required dependencies
3. Optionally install development dependencies
4. Install frontend dependencies for the web UI

## Advanced Installation

For more control over the installation process, use the advanced installer:

```bash
./install_advanced.sh
```

The advanced installer provides:
- System dependency checks
- Choice of Python version (3.10, 3.11, or 3.12)
- Option to install development dependencies
- Option to install frontend dependencies
- Fallback to venv if neither uv nor conda is available
- Option to install uv if not already installed

## Manual Installation

If you prefer to install manually, follow these steps:

1. Create a virtual environment:
   ```bash
   # Using venv
   python -m venv swe-agent-env
   source swe-agent-env/bin/activate
   
   # OR using conda
   conda create -n swe-agent-env python=3.11
   conda activate swe-agent-env
   
   # OR using uv
   uv venv swe-agent-env
   source swe-agent-env/bin/activate
   ```

2. Install dependencies:
   ```bash
   pip install -e .
   
   # Optional: Install development dependencies
   pip install -e ".[dev]"
   ```

3. Install frontend dependencies:
   ```bash
   cd sweagent/frontend
   npm install
   ```

## Running SWE-agent

After installation, you can run SWE-agent using:

```bash
# Activate the environment first
source swe-agent-env/bin/activate  # or conda activate swe-agent-env

# Run the command-line interface
python -m sweagent

# Run the web UI
./start_web_ui.sh
# OR
python -m sweagent run-api --host 0.0.0.0 --port 12000
```

## Troubleshooting

If you encounter any issues during installation:

1. Make sure all system dependencies are installed (git, npm, python)
2. Check that you're using a compatible Python version (3.10+)
3. If you're having issues with the web UI, make sure Node.js and npm are installed
4. For environment-specific issues, try creating a fresh environment

For more detailed information, refer to the [official documentation](https://swe-agent.com/latest/installation/).