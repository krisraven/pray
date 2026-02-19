#!/bin/bash

# Build script for cross-platform compilation
# Usage: ./build.sh [target] or ./build.sh all

BUILD_DIR="build"
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS="-X main.Version=${VERSION}"

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to build for a specific OS and architecture
build() {
    local os=$1
    local arch=$2
    local output_dir="${BUILD_DIR}/pray-${os}-${arch}"
    local exe_name="pray"

    if [ "$os" == "windows" ]; then
        exe_name="pray.exe"
    fi

    mkdir -p "$output_dir"

    echo -e "${BLUE}Building for ${os}/${arch}...${NC}"
    GOOS=$os GOARCH=$arch go build -ldflags "$LDFLAGS" -o "${output_dir}/${exe_name}" main.go

    if [ $? -eq 0 ]; then
        cp quotes.json "$output_dir/"
        echo -e "${GREEN}✓ Built: ${output_dir}/${NC}"
    else
        echo -e "✗ Build failed for ${os}/${arch}"
        exit 1
    fi
}

# Function to show usage
usage() {
    cat << EOF
Pray Build Script

Usage: ./build.sh [target]

Targets:
  all                 Build for all platforms
  windows-amd64       Windows 64-bit
  windows-386         Windows 32-bit
  windows-arm64       Windows ARM64
  macos-amd64         macOS Intel
  macos-arm64         macOS Apple Silicon
  linux-amd64         Linux 64-bit
  linux-386           Linux 32-bit
  linux-arm           Linux ARM (32-bit)
  linux-arm64         Linux ARM64
  current             Build for current OS/architecture
  clean               Remove build directory

Examples:
  ./build.sh all              # Build everything
  ./build.sh linux-amd64      # Build for Linux 64-bit
  ./build.sh current          # Build for your system
EOF
}

# Clean build directory
clean() {
    echo "Cleaning build directory..."
    rm -rf "$BUILD_DIR"
    echo "Done!"
}

# Build for current system
build_current() {
    mkdir -p "$BUILD_DIR"
    echo -e "${BLUE}Building for current OS...${NC}"
    go build -ldflags "$LDFLAGS" -o "${BUILD_DIR}/pray" main.go

    if [ $? -eq 0 ]; then
        cp quotes.json "$BUILD_DIR/"
        echo -e "${GREEN}✓ Built: ${BUILD_DIR}/pray${NC}"
    else
        echo "✗ Build failed"
        exit 1
    fi
}

# Build all platforms
build_all() {
    mkdir -p "$BUILD_DIR"

    echo -e "${BLUE}Building for all platforms...${NC}\n"

    # Windows
    build windows amd64
    build windows 386
    build windows arm64

    # macOS
    build darwin amd64
    build darwin arm64

    # Linux
    build linux amd64
    build linux 386
    build linux arm
    build linux arm64

    echo -e "\n${GREEN}All builds complete!${NC}"
    echo "Binaries location: $BUILD_DIR/"
    ls -lR "$BUILD_DIR"
}

# Main logic
if [ $# -eq 0 ]; then
    usage
    exit 0
fi

case "$1" in
    all)
        build_all
        ;;
    current)
        build_current
        ;;
    clean)
        clean
        ;;
    windows-amd64)
        mkdir -p "$BUILD_DIR"
        build windows amd64
        ;;
    windows-386)
        mkdir -p "$BUILD_DIR"
        build windows 386
        ;;
    windows-arm64)
        mkdir -p "$BUILD_DIR"
        build windows arm64
        ;;
    macos-amd64)
        mkdir -p "$BUILD_DIR"
        build darwin amd64
        ;;
    macos-arm64)
        mkdir -p "$BUILD_DIR"
        build darwin arm64
        ;;
    linux-amd64)
        mkdir -p "$BUILD_DIR"
        build linux amd64
        ;;
    linux-386)
        mkdir -p "$BUILD_DIR"
        build linux 386
        ;;
    linux-arm)
        mkdir -p "$BUILD_DIR"
        build linux arm
        ;;
    linux-arm64)
        mkdir -p "$BUILD_DIR"
        build linux arm64
        ;;
    *)
        echo "Unknown target: $1"
        usage
        exit 1
        ;;
esac
