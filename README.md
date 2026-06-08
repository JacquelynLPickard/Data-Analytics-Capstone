# ⛽ Fueling the Bottom Line
## How Diesel Price Volatility Impacts Trucking Operations & Profitability

**Google Data Analytics Professional Certificate — Capstone Project**
**Author:** Jacquelyn L Pickard
**Date:** June 2026
**Tools Used:** Python · SQL · Excel/Google Sheets · Tableau

---

## 📌 Project Overview

Fuel is one of the largest controllable costs in the trucking and logistics industry, typically representing **25–40% of total operating expenses** for a fleet. When diesel prices spike, carriers face immediate margin compression — and when prices drop, the savings don't always reach the bottom line as quickly as the costs do.

This capstone project applies the full **Google Data Analytics framework (Ask → Prepare → Process → Analyze → Share → Act)** to explore:

> *"How does diesel price volatility affect trucking operational costs, and what patterns can help logistics companies better plan for fuel-driven financial risk?"*

This project is designed to be understood by both technical and non-technical audiences. Every chart and visual includes a plain-language explanation of what it shows and why it matters.

---

## ❓ Phase 1: Ask

### Business Questions
1. How have diesel prices trended over the past 10+ years, and what events drove the biggest spikes?
2. Is there a measurable relationship between diesel prices and trucking operational costs?
3. Do fuel price impacts vary by region across the United States?
4. What seasonal patterns exist in diesel pricing, and how can fleets use them to plan ahead?
5. What does the data suggest for fuel surcharge strategy and cost forecasting?

### Stakeholders
| Stakeholder | Interest |
|---|---|
| Fleet Managers | Understand cost exposure and timing of fuel surcharges |
| CFO / Finance Team | Forecast fuel-driven budget variance |
| Operations Planners | Adjust routing and load planning seasonally |
| Owner-Operators | Understand how national trends affect their margins |

### Success Metrics
- Identify statistically significant correlations between fuel prices and cost indicators
- Surface at least 3 actionable insights for operations or finance teams
- Produce visualizations understandable to a non-technical audience

---

## 🗂️ Phase 2: Prepare

### Data Sources

| Dataset | Source | Description | Time Period |
|---|---|---|---|
| Weekly Retail Diesel Prices | [U.S. Energy Information Administration (EIA)](https://www.eia.gov/dnav/pet/pet_pri_gnd_dcus_nus_w.htm) | National & regional weekly diesel prices | 1994 – Present |
| Trucking Industry Cost Index | Kaggle / ATRI | Operational cost per mile by category | 2008 – Present |
| Fuel Surcharge Rate Tables | Kaggle / DAT Solutions | Industry-standard FSC rates vs. diesel price | 2010 – Present |

### Data Credibility (ROCCC Framework)
- **Reliable:** EIA data is collected by the U.S. federal government
- **Original:** Primary source, not aggregated by a third party
- **Comprehensive:** National + 9 regional series, weekly granularity
- **Current:** Updated weekly through the present
- **Cited:** Publicly documented methodology

### Data Location
- Raw data files: `/data/raw/`
- Cleaned data files: `/data/cleaned/`
- See `data_sources.md` for download links and file descriptions

---

## 🧹 Phase 3: Process

### Tools Used
- **Google Sheets** — Initial data inspection, formatting checks, pivot tables
- **SQL (SQLite)** — Joining datasets, filtering, aggregating by region and time period
- **Python (Pandas)** — Data cleaning, null handling, date parsing, derived columns

### Cleaning Steps Performed
1. Removed rows with missing price values (< 2% of records)
2. Standardized date formats to `YYYY-MM-DD`
3. Converted all price fields to consistent decimal (USD per gallon)
4. Added derived columns: `year`, `month`, `quarter`, `yoy_change_pct`
5. Verified no duplicate weekly entries per region
6. Validated price ranges (flagged outliers for review)

### Key SQL Queries
All queries are documented in `/sql/queries.sql` with comments explaining each step.

### Change Log
All cleaning decisions are logged in the Jupyter Notebook (`notebooks/capstone_notebook.ipynb`) with before/after comparisons so the process is fully transparent and reproducible.

---

## 📊 Phase 4: Analyze

### Key Findings

> *(Full analysis with visualizations is in the Jupyter Notebook)*

**Finding 1 — Diesel prices show strong seasonality**
Prices reliably rise in spring (March–May) ahead of peak driving season and fall in late fall/winter. Fleets that lock in fuel hedges in Q4 have historically benefited.

**Finding 2 — Regional price disparity is significant**
The West Coast consistently pays 20–40¢/gallon more than the Gulf Coast. For carriers running cross-country lanes, this creates predictable margin pressure on westbound loads.

**Finding 3 — Fuel surcharges lag price increases**
Standard FSC tables (updated weekly) trail actual retail diesel changes by 1–2 weeks. During rapid price spikes, carriers absorb the gap before recovery.

**Finding 4 — Price volatility clusters around macro events**
The 2008 financial crisis, 2020 COVID crash, and 2022 Ukraine conflict each produced statistically abnormal price swings. Risk planning should account for these "black swan" periods.

---

## 📈 Phase 5: Share

### Visualizations

All visualizations are in `/visuals/` and embedded in the Jupyter Notebook. Each visual includes:
- A **title** describing what is shown
- A **plain-language caption** explaining what it means for a non-technical reader
- A **"So what?"** callout explaining the business implication

| Visual | Description |
|---|---|
| `01_national_diesel_trend.png` | 10-year diesel price trend with annotated events |
| `02_regional_price_comparison.png` | Side-by-side regional price comparison bar chart |
| `03_seasonal_patterns.png` | Average monthly prices showing seasonal cycles |
| `04_fuel_vs_opcost_correlation.png` | Scatter plot: diesel price vs. cost per mile |
| `05_fsc_lag_analysis.png` | Line chart showing FSC rate vs. actual diesel price |
| `06_volatility_heatmap.png` | Year × Month heatmap of price volatility |

### Tableau Dashboard
🔗 [View Interactive Dashboard on Tableau Public](#) *(link added after publishing)*

---

## 💡 Phase 6: Act

### Recommendations

Based on the data analysis, here are three actionable recommendations for a trucking or logistics company:

**1. Build a Seasonal Fuel Budget Model**
Use historical seasonal patterns to create a Q1–Q4 fuel budget that anticipates spring price increases. Reserve 5–8% budget flexibility for Q2 (April–June) based on historical averages.

**2. Review Fuel Surcharge Triggers Weekly — Not Monthly**
FSC tables updated only monthly leave carriers exposed during rapid price run-ups. Switching to weekly FSC updates aligned to EIA's Monday release can reduce the lag-exposure window by up to 75%.

**3. Benchmark Regional Lane Profitability Against Fuel Exposure**
West Coast inbound lanes carry a structural $0.25–$0.40/gallon fuel cost premium. Rate sheets for these lanes should reflect this in base rates, not just FSC adjustments.

---

## 📁 Repository Structure

```
fuel-cost-trucking-capstone/
│
├── 📓 notebooks/
│   └── capstone_notebook.ipynb       ← Full analysis narrative (start here)
│
├── 📁 data/
│   ├── raw/                          ← Original downloaded datasets (unmodified)
│   └── cleaned/                      ← Processed, analysis-ready files
│
├── 📁 sql/
│   └── queries.sql                   ← All SQL queries, fully commented
│
├── 📁 visuals/
│   └── *.png                         ← All charts and visualizations
│
├── 📄 README.md                      ← You are here
└── 📄 data_sources.md                ← Dataset links and descriptions
```

---

## 🛠️ How to Run This Project

1. **Clone the repo**
   ```bash
   git clone https://github.com/[your-username]/fuel-cost-trucking-capstone.git
   cd fuel-cost-trucking-capstone
   ```

2. **Install Python dependencies**
   ```bash
   pip install pandas matplotlib seaborn scipy jupyter
   ```

3. **Download the datasets** (see `data_sources.md` for links) and place them in `/data/raw/`

4. **Open the notebook**
   ```bash
   jupyter notebook notebooks/capstone_notebook.ipynb
   ```

5. Run all cells from top to bottom — the notebook will clean the data, run analysis, and generate all visuals.

---

## 📚 References & Acknowledgments

- U.S. Energy Information Administration (EIA) — [eia.gov](https://www.eia.gov)
- American Transportation Research Institute (ATRI) — [atri-online.org](https://atri-online.org)
- Google Data Analytics Professional Certificate — Coursera
- DAT Freight & Analytics — [dat.com](https://www.dat.com)

---

## 📬 Contact

**Jacquelyn L Pickard**
(https://www.linkedin.com/in/jacquelyn-l-pickard-0b9a763aa/)
(https://github.com/JacquelynLPickard/Data-Analytics-Capstone)

*This project was completed as the capstone for the Google Data Analytics Professional Certificate Program.*