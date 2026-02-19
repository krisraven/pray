package main

import (
	"encoding/json"
	"os"
	"testing"
)

func TestQuotesJSONFormat(t *testing.T) {
	// Read the quotes.json file
	data, err := os.ReadFile("quotes.json")
	if err != nil {
		t.Fatalf("Failed to read quotes.json: %v", err)
	}

	// Parse the JSON
	var quotesData QuotesData
	err = json.Unmarshal(data, &quotesData)
	if err != nil {
		t.Fatalf("Failed to parse quotes.json: %v", err)
	}

	// Verify quotes are loaded
	if len(quotesData.Quotes) == 0 {
		t.Error("No quotes found in quotes.json")
	}

	// Verify each quote has required fields
	for i, quote := range quotesData.Quotes {
		if quote.Text == "" {
			t.Errorf("Quote %d has empty text", i)
		}
		if quote.Reference == "" {
			t.Errorf("Quote %d has empty reference", i)
		}
	}
}

func TestQuoteStructure(t *testing.T) {
	quote := Quote{
		Text:      "Test quote",
		Reference: "Test 1:1",
	}

	if quote.Text != "Test quote" {
		t.Error("Quote text not set correctly")
	}
	if quote.Reference != "Test 1:1" {
		t.Error("Quote reference not set correctly")
	}
}

func TestQuotesDataUnmarshal(t *testing.T) {
	jsonData := `{
		"quotes": [
			{
				"text": "Sample quote",
				"reference": "Sample 1:1"
			}
		]
	}`

	var quotesData QuotesData
	err := json.Unmarshal([]byte(jsonData), &quotesData)
	if err != nil {
		t.Fatalf("Failed to unmarshal JSON: %v", err)
	}

	if len(quotesData.Quotes) != 1 {
		t.Errorf("Expected 1 quote, got %d", len(quotesData.Quotes))
	}

	if quotesData.Quotes[0].Text != "Sample quote" {
		t.Error("Quote text not unmarshaled correctly")
	}
}
