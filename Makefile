.PHONY: build build-all clean help

# Default target
help:
	@echo "Pray - Bible Quote CLI Tool"
	@echo ""
	@echo "Available targets:"
	@echo "  make build        - Build for current OS/architecture"
	@echo "  make build-all    - Build for all platforms"
	@echo "  make clean        - Clean build artifacts"
	@echo ""
	@echo "Building for specific platforms:"
	@echo "  make build-windows-amd64"
	@echo "  make build-windows-386"
	@echo "  make build-windows-arm64"
	@echo "  make build-macos-amd64"
	@echo "  make build-macos-arm64"
	@echo "  make build-linux-amd64"
	@echo "  make build-linux-386"
	@echo "  make build-linux-arm"
	@echo "  make build-linux-arm64"

# Build directory
BUILD_DIR := build
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS := -ldflags "-X main.Version=$(VERSION)"

# Current OS build
build:
	@mkdir -p $(BUILD_DIR)
	go build $(LDFLAGS) -o $(BUILD_DIR)/pray main.go
	@echo "Built: $(BUILD_DIR)/pray"

# Windows builds
build-windows-amd64:
	@mkdir -p $(BUILD_DIR)/pray-windows-amd64
	GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-windows-amd64/pray.exe main.go
	cp quotes.json $(BUILD_DIR)/pray-windows-amd64/
	@echo "Built: $(BUILD_DIR)/pray-windows-amd64/"

build-windows-386:
	@mkdir -p $(BUILD_DIR)/pray-windows-386
	GOOS=windows GOARCH=386 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-windows-386/pray.exe main.go
	cp quotes.json $(BUILD_DIR)/pray-windows-386/
	@echo "Built: $(BUILD_DIR)/pray-windows-386/"

build-windows-arm64:
	@mkdir -p $(BUILD_DIR)/pray-windows-arm64
	GOOS=windows GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-windows-arm64/pray.exe main.go
	cp quotes.json $(BUILD_DIR)/pray-windows-arm64/
	@echo "Built: $(BUILD_DIR)/pray-windows-arm64/"

# macOS builds
build-macos-amd64:
	@mkdir -p $(BUILD_DIR)/pray-macos-amd64
	GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-macos-amd64/pray main.go
	cp quotes.json $(BUILD_DIR)/pray-macos-amd64/
	@echo "Built: $(BUILD_DIR)/pray-macos-amd64/"

build-macos-arm64:
	@mkdir -p $(BUILD_DIR)/pray-macos-arm64
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-macos-arm64/pray main.go
	cp quotes.json $(BUILD_DIR)/pray-macos-arm64/
	@echo "Built: $(BUILD_DIR)/pray-macos-arm64/"

# Linux builds
build-linux-amd64:
	@mkdir -p $(BUILD_DIR)/pray-linux-amd64
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-linux-amd64/pray main.go
	cp quotes.json $(BUILD_DIR)/pray-linux-amd64/
	@echo "Built: $(BUILD_DIR)/pray-linux-amd64/"

build-linux-386:
	@mkdir -p $(BUILD_DIR)/pray-linux-386
	GOOS=linux GOARCH=386 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-linux-386/pray main.go
	cp quotes.json $(BUILD_DIR)/pray-linux-386/
	@echo "Built: $(BUILD_DIR)/pray-linux-386/"

build-linux-arm:
	@mkdir -p $(BUILD_DIR)/pray-linux-arm
	GOOS=linux GOARCH=arm go build $(LDFLAGS) -o $(BUILD_DIR)/pray-linux-arm/pray main.go
	cp quotes.json $(BUILD_DIR)/pray-linux-arm/
	@echo "Built: $(BUILD_DIR)/pray-linux-arm/"

build-linux-arm64:
	@mkdir -p $(BUILD_DIR)/pray-linux-arm64
	GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/pray-linux-arm64/pray main.go
	cp quotes.json $(BUILD_DIR)/pray-linux-arm64/
	@echo "Built: $(BUILD_DIR)/pray-linux-arm64/"

# Build all platforms
build-all: build-windows-amd64 build-windows-386 build-windows-arm64 build-macos-amd64 build-macos-arm64 build-linux-amd64 build-linux-386 build-linux-arm build-linux-arm64
	@echo ""
	@echo "All builds complete! Find binaries in $(BUILD_DIR)/"
	@ls -la $(BUILD_DIR)/

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)
	@echo "Cleaned build directory"
