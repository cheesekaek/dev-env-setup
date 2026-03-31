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
if [ -t 1 ]; then # in terminal
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

# packages to be installed
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