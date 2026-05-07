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

const (
	freeCDN    = "https://cdn.jsdelivr.net/gh/krisraven/pray@main/quotes.json"
	premiumCDN = "https://cdn.jsdelivr.net/gh/krisraven/pray@main/quotes-premium.json"
)

func isPremium() bool {
	home, err := os.UserHomeDir()
	if err != nil {
		return false
	}
	info, err := os.Stat(filepath.Join(home, ".pray", "license"))
	return err == nil && info.Size() > 0
}

func main() {
	quotesData, err := fetchQuotes()
	if err != nil {
		log.Fatal("Error fetching quotes:", err)
	}

	if len(quotesData.Quotes) == 0 {
		log.Fatal("No quotes found")
	}

	rand.Seed(time.Now().UnixNano())
	quote := quotesData.Quotes[rand.Intn(len(quotesData.Quotes))]

	fmt.Println("\n" + quote.Text)
	fmt.Println("— " + quote.Reference + "\n")
}

func fetchQuotes() (*QuotesData, error) {
	premium := isPremium()

	cdnURL := freeCDN
	localFile := "quotes.json"
	if premium {
		cdnURL = premiumCDN
		localFile = "quotes-premium.json"
	}

	resp, err := http.Get(cdnURL)
	if err != nil {
		return loadLocalQuotes(localFile)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return loadLocalQuotes(localFile)
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return loadLocalQuotes(localFile)
	}

	var quotesData QuotesData
	if err = json.Unmarshal(data, &quotesData); err != nil {
		return loadLocalQuotes(localFile)
	}

	return &quotesData, nil
}

func loadLocalQuotes(filename string) (*QuotesData, error) {
	exePath, err := os.Executable()
	if err != nil {
		return nil, err
	}
	quotesFile := filepath.Join(filepath.Dir(exePath), filename)

	data, err := os.ReadFile(quotesFile)
	if err != nil {
		return nil, err
	}

	var quotesData QuotesData
	if err = json.Unmarshal(data, &quotesData); err != nil {
		return nil, err
	}

	return &quotesData, nil
}
