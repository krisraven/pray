# Pray

A simple CLI tool that displays random Bible quotes to inspire and encourage you.

## Features

- 📖 **60 Bible quotes** from both Old and New Testament
- 🎲 **Random selection** - get a different quote each time
- ⚡ **Fast and lightweight** - written in Go
- 📝 **Beautifully formatted** - with verse references

## Installation

### From Source

1. Clone the repository:
```bash
git clone https://github.com/krisraven/pray.git
cd pray
```

2. Build the executable:
```bash
go build -o pray main.go
```

3. Install to your system path:
```bash
sudo cp pray /usr/local/bin/pray
```

### Or Build and Run Directly

```bash
go build -o pray main.go
./pray
```

## Cross-Platform Builds

To build executables for multiple platforms (Windows, macOS, Linux) and architectures (x86, ARM, etc.), use the provided build script:

```bash
# Build for all platforms
./build.sh all

# Build for a specific platform
./build.sh linux-amd64
./build.sh macos-arm64
./build.sh windows-amd64

# Build for your current OS
./build.sh current

# Clean build artifacts
./build.sh clean
```

**Supported targets:**
- `windows-amd64` - Windows 64-bit
- `windows-386` - Windows 32-bit
- `windows-arm64` - Windows ARM64
- `macos-amd64` - macOS Intel (10.12+)
- `macos-arm64` - macOS Apple Silicon (M1+)
- `linux-amd64` - Linux 64-bit
- `linux-386` - Linux 32-bit
- `linux-arm` - Linux ARM (32-bit)
- `linux-arm64` - Linux ARM64

Binaries are organized in the `build/` directory with the `quotes.json` file included in each folder.

## Usage

Simply type the command:
```bash
pray
```

Each time you run it, you'll see a random Bible quote with its reference:

```
For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.
— John 3:16
```

## Adding More Quotes

You can add more quotes to the `quotes.json` file. Each quote should follow this format:

```json
{
  "text": "Quote text here",
  "reference": "Book Chapter:Verse"
}
```

Then rebuild:
```bash
go build -o pray main.go
```

## Testing

Run the test suite:
```bash
go test -v
```

Tests verify:
- JSON parsing functionality
- Quote data structure integrity
- Proper unmarshaling of quote data

## Project Structure

```
pray/
├── main.go           # Main program logic
├── main_test.go      # Unit tests
├── quotes.json       # Bible quotes database
├── go.mod            # Go module definition
├── build.sh          # Cross-platform build script
├── Makefile          # Alternative build automation
├── .gitignore        # Git ignore rules
└── README.md         # This file
```

## Quote Sources

All Bible quotes are taken from standard Bible translations and contain 60 inspirational verses from both the Old and New Testaments.

## License

Feel free to use and modify this tool as needed.

## Contributing

Pull requests are welcome! Feel free to add more quotes or improve the tool.
