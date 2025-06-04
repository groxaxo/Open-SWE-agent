# Add Installation Scripts for Easy Setup

## Description

This PR adds two installation scripts to make it easier for users to set up SWE-agent:

1. `install.sh`: A basic installation script that:
   - Automatically detects if uv or conda is available
   - Creates a virtual environment with Python 3.11
   - Installs all required dependencies
   - Optionally installs development dependencies
   - Installs frontend dependencies for the web UI

2. `install_advanced.sh`: An advanced installation script with more options:
   - System dependency checks
   - Choice of Python version (3.10, 3.11, or 3.12)
   - Option to install development dependencies
   - Option to install frontend dependencies
   - Fallback to venv if neither uv nor conda is available
   - Option to install uv if not already installed

3. `INSTALL.md`: Detailed installation instructions

4. Updated `README.md` to include information about the new installation scripts

## Testing

Both installation scripts have been tested and work correctly. The basic script (`install.sh`) is designed to be simple and straightforward, while the advanced script (`install_advanced.sh`) provides more options for users who need more control over the installation process.

## Benefits

These installation scripts will make it easier for new users to get started with SWE-agent, reducing the barrier to entry and improving the user experience.

## Screenshots

N/A

## Related Issues

N/A