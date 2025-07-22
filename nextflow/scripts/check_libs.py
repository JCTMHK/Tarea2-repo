import importlib.util
import subprocess
import sys
import os

def read_requirements(filepath):
    """
    Reads a requirements.txt file and returns a list of full package requirements.
    Ignores comments and empty lines.
    """
    requirements = []
    try:
        with open(filepath, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#'):
                    requirements.append(line)
    except FileNotFoundError:
        print(f"Error: requirements.txt file not found at {filepath}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error reading requirements.txt: {e}", file=sys.stderr)
        sys.exit(1)
    return requirements

def get_module_name(package_requirement):
    """
    Extracts the base module name from a package requirement string.
    e.g., "biopython==1.79" -> "biopython" -> "Bio"
    e.g., "pandas>=1.0" -> "pandas"
    """
    # First, get the base package name (e.g., "biopython" from "biopython==1.79")
    base_package_name = package_requirement.split('==')[0].split('>=')[0].split('<=')[0].split('~=')[0].strip()
    # Special handling for Biopython: module name is 'Bio', not 'biopython'
    return 'Bio' if base_package_name.lower() == 'biopython' else base_package_name.replace('-', '_')

def install_package(package_requirement):
    """
    Installs a given Python package requirement (including version specifiers) using pip.
    """
    print(f"Attempting to install {package_requirement}...")
    try:
        # Use sys.executable to ensure pip associated with the current Python interpreter is used
        subprocess.check_call([sys.executable, "-m", "pip", "install", package_requirement])
        print(f"Successfully installed {package_requirement}")
    except subprocess.CalledProcessError as e:
        print(f"Error installing {package_requirement}: {e}", file=sys.stderr)
        sys.exit(1) # Exit with an error code if installation fails

def check_and_install_libs(requirements_file):
    """
    Checks if required libraries from a requirements file are installed and installs them if not.
    """
    required_requirements = read_requirements(requirements_file)
    if not required_requirements:
        print("No packages found in requirements.txt to check/install.", file=sys.stderr)
        return

    all_installed = True
    for req in required_requirements:
        module_name = get_module_name(req)
        spec = importlib.util.find_spec(module_name)
        if spec is None:
            print(f"'{req}' (module: '{module_name}') not found. Installing...", file=sys.stderr)
            install_package(req) # Pass the full requirement string for installation
            all_installed = False
        else:
            print(f"'{req}' (module: '{module_name}') is already installed.")

    if all_installed:
        print("All required libraries are already installed.")
    else:
        print("Installation complete. Please re-run the workflow if libraries were just installed.")

if __name__ == "__main__":
    # The script now expects the path to requirements.txt as a command-line argument
    if len(sys.argv) != 2:
        print("Usage: python check_libs.py <path_to_requirements.txt>", file=sys.stderr)
        sys.exit(1)

    requirements_filepath = sys.argv[1]
    check_and_install_libs(requirements_filepath)