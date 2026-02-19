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
├── .gitignore        # Git ignore rules
└── README.md         # This file
```

## Quote Sources

All Bible quotes are taken from standard Bible translations and contain 60 inspirational verses from both the Old and New Testaments.

## License

Feel free to use and modify this tool as needed.

## Contributing

Pull requests are welcome! Feel free to add more quotes or improve the tool.
