
# Tamil Nadu Assembly Election 2026 — Electoral Data Analysis

## Project Overview

This project presents an end-to-end analysis of the **Tamil Nadu Legislative Assembly Election 2026**, covering all **234 constituencies**.

The project transforms official election results from PDF format into a structured analytical dataset, performs constituency-level and party-level analysis using SQL, and presents the findings through an interactive Tableau dashboard with constituency-level geospatial visualization.

The project focuses not only on analysing election results, but also on **data preparation, validation, SQL-based analysis, and effective visual communication**.

## Project Objectives

The analysis aims to answer the following questions:

- Which political parties won the most constituencies?
- Which party won in each constituency across Tamil Nadu?
- What was the vote share of each major political party?
- How does each party's vote share compare with its seat share?
- Which constituencies had the closest electoral contests?
- Which constituencies recorded the largest winning margins?
- Which constituencies had the highest and lowest voter turnout?
- Who were the winner and runner-up in each constituency?

## Tools & Technologies

- **Excel** — Data preparation, cleaning and validation
- **MySQL / SQL** — Data transformation and electoral analysis
- **Tableau Public** — Interactive dashboard and data visualization
- **GeoJSON** — Constituency-level spatial visualization
- **AI-assisted extraction** — Converting the official election-results PDF into structured tabular data

  ## Data Sources

### Election Results Data

The election results were sourced from the **Election Commission of India (ECI)** through the official Tamil Nadu Assembly Election 2026 detailed results PDF.

The source contains constituency-level and candidate-level information, including:

- Constituency number and name
- Total electors
- Candidate name
- Gender, age and category
- Political party
- Election symbol
- General votes
- Postal votes
- Total votes
- Vote percentages
- Constituency voter turnout

The PDF covers all **234 Assembly Constituencies** in Tamil Nadu.

### Constituency Boundary Data

GeoJSON spatial data was used to visualize election results geographically at the Assembly Constituency level.

The constituency boundary file was obtained from the following GitHub repository:

**Repository:** `saisantoshv3/assemnbly_gis_files`

**File:** `2026_assembly_election/tamil_nadu_S22/tamil_nadu.geojson`

The GeoJSON file was connected to the election data in Tableau using the **Assembly Constituency Number** as the common geographic identifier.


## Data Preparation & Cleaning

The official election results were available in PDF format and required transformation into a structured dataset before analysis.

The following steps were performed:

1. **PDF Data Extraction**
   - Used AI-assisted extraction to convert the official election-results PDF into structured tabular data.
   - Organized candidate-level results and constituency turnout data into separate Excel worksheets.

2. **Data Cleaning in Excel**
   - Reviewed and standardized candidate and constituency information.
   - Preserved both raw and cleaned candidate names for traceability.
   - Checked numeric fields such as general votes, postal votes, total votes and vote percentages.
   - Handled missing values, including blank values for NOTA records.

3. **Data Validation**
   - Verified that candidate total votes matched:
     `General Votes + Postal Votes = Total Votes`
   - Checked constituency coverage and data completeness.
   - Used constituency number as the primary constituency identifier because constituency names are not always unique.

4. **MySQL Preparation**
   - Imported the cleaned candidate-level dataset into MySQL.
   - Assigned appropriate data types for numerical and categorical fields.
   - Performed additional SQL-based validation before starting the electoral analysis.

## Data Quality & Validation

Data quality checks were performed at multiple stages before finalizing the analysis and dashboard.

Key validation steps included:

- Confirmed coverage of all **234 Assembly Constituencies**.
- Verified the presence of NOTA records across all constituencies.
- Checked that `General Votes + Postal Votes = Total Votes`.
- Validated constituency numbers as the primary identifier to avoid issues caused by duplicate constituency names.
- Verified winner and runner-up calculations generated through SQL.
- Cross-verified the winners of **all 234 constituencies** against the original election-results PDF.
- Investigated and corrected extraction discrepancies identified during source-level validation.
- Re-ran the affected SQL analysis and refreshed the Tableau dashboard after corrections.

### Validation Approach

Automated checks such as row counts and vote-total reconciliation were combined with **source-level validation against the original PDF**.

This was important because structural checks alone could confirm that the dataset was internally consistent, but could not guarantee that every record had been extracted correctly from the source document.

## SQL Analysis

MySQL was used to transform the cleaned candidate-level data into constituency-level and party-level analytical outputs.

### Winner and Runner-up Identification

Window functions were used to rank candidates within each constituency based on total votes.

`DENSE_RANK()` with `PARTITION BY constituency_no` was used to identify:

- Constituency winner
- Runner-up
- Winner votes
- Runner-up votes

### Winning Margin Analysis

Winning margin was calculated as:

`Winner Votes - Runner-up Votes`

This was used to identify:

- Top 10 closest electoral contests
- Top 10 largest victories

### Constituency Summary View

A reusable MySQL view named `constituency_summary` was created to provide one analytical record per constituency.

The view contains:

- Constituency number and name
- Winner and winning party
- Winner votes
- Runner-up and runner-up party
- Runner-up votes
- Winning margin

This view served as a reusable constituency-level analytical layer for downstream analysis and Tableau visualization.

### Party-Level Analysis

SQL was also used to calculate:

- Seats won by each political party
- Total votes received by each party
- Party vote share
- Party seat share
- Comparison between vote share and seat share

### Voter Turnout Analysis

Constituency-level turnout data was analysed to identify:

- Average voter turnout
- Highest voter turnout
- Lowest voter turnout
- Constituencies with the highest and lowest turnout


## Tableau Dashboard

The analytical outputs were visualized in Tableau Public to create an interactive electoral analysis dashboard covering all 234 Assembly Constituencies.

### Dashboard Features

The dashboard includes:

- **KPI Cards**
  - Total Constituencies
  - Average Voter Turnout
  - Highest Voter Turnout
  - Lowest Voter Turnout
  - Closest Winning Margin

- **Winning Party by Constituency Map**
  - GeoJSON-based constituency map
  - Constituencies coloured by winning party
  - Interactive tooltips showing winner, runner-up, votes and winning margin
  - Constituency search functionality

- **Seats Won by Party**
  - Comparison of the number of constituencies won by each party
  - Interactive filtering of the constituency map

- **Top 10 Closest Contests**
  - Constituencies with the smallest winning margins

- **Top 10 Largest Victories**
  - Constituencies with the largest winning margins

- **Vote Share vs Seat Share**
  - Comparison between each party's percentage of total votes and percentage of seats won

### Dashboard Preview

![Tamil Nadu Assembly Election 2026 Dashboard](images/tn_election_2026_dashboard.png)

### Interactive Dashboard

[View the Interactive Tableau Dashboard]
https://public.tableau.com/app/profile/ganesan.a7009/viz/TN_Election_2026_Result_Project/Dashboard1?publish=yes


## Key Insights

## Key Insights

- **Dominant Party:** Tamilaga Vettri Kazhagam (TVK) emerged as the largest party, winning **108 seats**.
- **Vote Share Leader:** TVK recorded the highest vote share at **35.08%**.
- **Closest Contest:** **Tiruppattur** recorded the closest contest, with a winning margin of just **1 vote**.
- **Largest Victory:** **Edappadi** recorded the largest victory, with a winning margin of **98,110 votes**.
- **Highest Voter Turnout:** **Karur** recorded the highest voter turnout at **94.25%**.
- **Lowest Voter Turnout:** **Palayamkottai** recorded the lowest voter turnout at **70.14%**.
- **Vote Share vs Seat Share:** TVK received **16,990,810 votes**, representing **35.08% of the total vote share**, while winning **108 seats (46.15% of all seats)**. This indicates that TVK's share of seats was substantially higher than its share of votes.


## Project Structure

```text
tamil-nadu-election-2026-analysis/
│
├── data/
│   ├── processed/
│   │   └── Tamil_Nadu_Election_Results_2026.xlsx
│   └── spatial/
│       └── tamil_nadu.geojson
│
├── sql/
│   └── analysis.sql
│
├── images/
│   └── tn_election_2026_dashboard.png
│
└── README.md
```

## Skills Demonstrated

- Data extraction and transformation
- Data cleaning and validation
- Excel-based data preparation
- SQL querying and analytical problem solving
- Window functions and ranking analysis
- Creation of reusable SQL views
- Party-level and constituency-level electoral analysis
- Geospatial analysis using GeoJSON
- Tableau dashboard development
- Interactive filters, tooltips and dashboard actions
- Data visualization and insight communication
- Data quality validation against source documents
