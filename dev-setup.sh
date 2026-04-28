#!/bin/bash
echo "Script started"

# logs setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
# basic syntax for date : date [OPTION]... [+FORMAT]
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/$TIMESTAMP.log"
# basic syntax: command | tee [OPTIONS] [FILE]
exec > >(tee -a "$LOG_FILE") 2>&1

# basic syntax for color : "\e[COLORm"
if [ -t 2 ]; then # in terminal
    RED="\e[31m"
    YELLOW="\e[33m"
    GREEN="\e[32m"
    ENDCOLOR="\e[0m"
else # in logfile
    RED=""
    YELLOW=""
    GREEN=""
    ENDCOLOR=""
fi

# info
info() {
    echo -e "${GREEN}[INFO] ${ENDCOLOR}$1"
}

# warn
warn() {
    echo -e "${YELLOW}[WARNING] ${ENDCOLOR}$1"
}

# error
error() {
    echo -e "${RED}[ERROR] ${ENDCOLOR}$1"
}

# packages to be installed (OS-level tools)
FILEPATH=$(realpath packages.txt)

PACKAGES=()
while IFS= read -r line; do
    PACKAGES+=("$line")
done < "$FILEPATH"
info "Packages to be installed: ${PACKAGES[*]}"

# TODO : Version checks to be added

# basic syntax: dpkg [options] [.deb package name]
for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -l | grep -q "^ii[[:space:]]\+$pkg"; then
        info "Installing $pkg..."
        sudo apt install -y "$pkg"
    else
        info "$pkg has already been installed."
    fi
done

REPO_URL="$1" # $1 is url
AUTO_RENAME=false # create repo even if dir already exists (default false)

# check for url
if [ -z "$1" ]; then
    error "Usage: $0 <repo-url> [--rename]"
    exit 1
fi

# check for rename
if [ "$2" == "--rename" ]; then # if --rename is $2, then set to true
    AUTO_RENAME=true
fi

REPO_NAME="$(basename -s .git "$REPO_URL")"
REPO_PATH="$SCRIPT_DIR/$REPO_NAME"

if [ -d "$REPO_PATH" ]; then
    if [ "$AUTO_RENAME" == true ]; then
        warn "This directory already exists. Creating a new directory..."
        COUNT=1
        ORIGINAL_PATH="$REPO_PATH"
        # create new directory
        while [ -d "$REPO_PATH" ]; do
            REPO_PATH="${ORIGINAL_PATH}_$COUNT"
            ((COUNT++))
        done
    else 
        error "Cannot clone repository as the directory already exists. Use --force to overwrite."
        exit 1
    fi

fi

info "Cloning repository..."

if ! git clone "$REPO_URL" "$REPO_PATH"; then
    error "Failed to clone repository. Exiting..."
    exit 1
fi

cd "$REPO_PATH" || exit
info "Entering repo directory..."

if [ -f "package.json" ]; then
    info "Detected a Node project. Installing dependencies..."
    npm install
fi 

if [ -f "requirements.txt" ]; then
    info "Detected a Python project. Installing dependencies..."

    if ! python3 -m venv venv 2>/dev/null; then # check if python3-venv is installed and if not, install it
        warn "python3-venv is not installed. Installing..."
        sudo apt install -y python3.12-venv

        # check if it was successful
        if ! python3 -m venv venv; then
            error "Failed to create virtual environment. Exiting..."
            exit 1
        fi
    fi

    # activate venv
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
    else
        error "Virtual environment was not created successfully. Exiting..."
        exit 1
    fi

    # install dependencies
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt
fi
