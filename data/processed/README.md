# Processed Data

This folder contains the cleaned and structured datasets used for the Tamil Nadu Assembly Election 2026 analysis.

## Dataset

`Tamil_Nadu_Election_Results_2026.xlsx`

The workbook contains:

- **Candidate Results** — Candidate-level election results across all 234 constituencies, including candidate, party, general votes, postal votes, total votes, and vote percentages.
- **Constituency Turnout** — Constituency-level electorate, votes polled, and turnout information.
- **Source Notes** — Information related to the source and extraction of the election data.

## Data Preparation

The official election results were available in PDF format. An AI-assisted extraction process was used to convert the PDF into structured tabular data.

The extracted data was subsequently inspected, cleaned, standardized, and validated before being imported into MySQL for analysis.

Candidate names were standardized while retaining the original values for traceability.

## Validation

Key validation checks included:

- 234 constituencies represented
- Candidate-level vote totals checked
- General votes + postal votes = total votes
- NOTA records validated
- Constituency turnout records validated
