#!/bin/bash

# Pray CLI Tool - Uninstallation Script
# Supports Linux and macOS

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

BINARY_NAME="pray"
QUOTES_FILE="quotes.json"
UNINSTALL_DIR=""
UNINSTALL_GLOBAL=false

usage() {
    cat << EOF
Pray CLI Tool - Uninstallation Script

Usage: ./uninstall.sh [OPTIONS]

Options:
  -d, --dir DIR       Directory to uninstall from (default: current directory)
  -g, --global        Uninstall from /usr/local/bin (requires sudo)
  -h, --help          Show this help message

Examples:
  ./uninstall.sh                    # Uninstall from current directory
  ./uninstall.sh -d ~/bin           # Uninstall from ~/bin
  ./uninstall.sh --global           # Uninstall system-wide install (needs sudo)

EOF
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            UNINSTALL_DIR="$2"
            shift 2
            ;;
        -g|--global)
            UNINSTALL_GLOBAL=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

main() {
    echo -e "${BLUE}Pray CLI Tool - Uninstallation${NC}\n"

    if [ "$UNINSTALL_GLOBAL" = true ]; then
        UNINSTALL_DIR="/usr/local/bin"
        echo "Uninstalling from: $UNINSTALL_DIR (requires sudo)"
    else
        UNINSTALL_DIR="${UNINSTALL_DIR:-.}"
        UNINSTALL_DIR="${UNINSTALL_DIR%/}"
        echo "Uninstalling from: $UNINSTALL_DIR"
    fi

    BINARY_PATH="$UNINSTALL_DIR/$BINARY_NAME"
    QUOTES_PATH="$UNINSTALL_DIR/$QUOTES_FILE"

    if [ ! -f "$BINARY_PATH" ]; then
        echo -e "${RED}✗ Binary not found at $BINARY_PATH${NC}"
        echo "Use -d to specify the directory or --global for a system-wide install."
        exit 1
    fi

    echo -e "\n${BLUE}Removing files...${NC}"

    if [ "$UNINSTALL_GLOBAL" = true ]; then
        sudo rm -f "$BINARY_PATH"
        sudo rm -f "$QUOTES_PATH"
    else
        rm -f "$BINARY_PATH"
        rm -f "$QUOTES_PATH"
    fi

    if [ ! -f "$BINARY_PATH" ]; then
        echo -e "${GREEN}✓ Uninstallation successful!${NC}"
        echo "Removed: $BINARY_PATH"
        [ ! -f "$QUOTES_PATH" ] && echo "Removed: $QUOTES_PATH"
    else
        echo -e "${RED}✗ Uninstallation failed${NC}"
        exit 1
    fi
}

main
