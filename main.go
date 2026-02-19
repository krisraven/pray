package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"os"
	"path/filepath"
	"time"
)

type Quote struct {
	Text      string `json:"text"`
	Reference string `json:"reference"`
}

type QuotesData struct {
	Quotes []Quote `json:"quotes"`
}

func main() {
	// Get the directory where the executable is located
	exePath, err := os.Executable()
	if err != nil {
		log.Fatal("Error getting executable path:", err)
	}
	exeDir := filepath.Dir(exePath)
	quotesFile := filepath.Join(exeDir, "quotes.json")

	// Read the JSON file
	data, err := os.ReadFile(quotesFile)
	if err != nil {
		log.Fatal("Error reading quotes.json:", err)
	}

	// Parse the JSON
	var quotesData QuotesData
	err = json.Unmarshal(data, &quotesData)
	if err != nil {
		log.Fatal("Error parsing quotes.json:", err)
	}

	if len(quotesData.Quotes) == 0 {
		log.Fatal("No quotes found in quotes.json")
	}

	// Seed the random number generator
	rand.Seed(time.Now().UnixNano())

	// Select a random quote
	randomIndex := rand.Intn(len(quotesData.Quotes))
	quote := quotesData.Quotes[randomIndex]

	// Print the quote
	fmt.Println("\n" + quote.Text)
	fmt.Println("— " + quote.Reference + "\n")
}
