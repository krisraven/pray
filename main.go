package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"math/rand"
	"net/http"
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
	quotesData, err := fetchQuotes()
	if err != nil {
		log.Fatal("Error fetching quotes:", err)
	}

	if len(quotesData.Quotes) == 0 {
		log.Fatal("No quotes found")
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

func fetchQuotes() (*QuotesData, error) {
	const quotesURL = "https://cdn.jsdelivr.net/gh/krisraven/pray@main/quotes.json"

	resp, err := http.Get(quotesURL)
	if err != nil {
		// Fallback to local file if network fails
		return loadLocalQuotes()
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		// Fallback to local file on HTTP error
		return loadLocalQuotes()
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return loadLocalQuotes()
	}

	var quotesData QuotesData
	err = json.Unmarshal(data, &quotesData)
	if err != nil {
		return loadLocalQuotes()
	}

	return &quotesData, nil
}

func loadLocalQuotes() (*QuotesData, error) {
	// Fallback: try to load from executable directory
	exePath, err := os.Executable()
	if err != nil {
		return nil, err
	}
	exeDir := filepath.Dir(exePath)
	quotesFile := filepath.Join(exeDir, "quotes.json")

	data, err := os.ReadFile(quotesFile)
	if err != nil {
		return nil, err
	}

	var quotesData QuotesData
	err = json.Unmarshal(data, &quotesData)
	if err != nil {
		return nil, err
	}

	return &quotesData, nil
}
