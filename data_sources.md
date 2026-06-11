# Data Sources

This file documents every dataset used in the capstone project, including where to download it, what it contains, and how it was used.

---

## 1. EIA Weekly Retail Diesel Prices

| Field | Details |
|---|---|
| **Source** | U.S. Energy Information Administration (EIA) |
| **URL** | https://www.eia.gov/dnav/pet/pet_pri_gnd_dcus_nus_w.htm |
| **File Format** | CSV / Excel (.xls) |
| **Raw Filename** | `eia_diesel_prices_weekly.csv` |
| **Cleaned Filename** | `diesel_prices_clean.csv` |
| **Coverage** | April 1994 – Present (weekly) |
| **Granularity** | National + 9 PADD regions |
| **Key Columns** | `date`, `national_price`, `east_coast`, `midwest`, `gulf_coast`, `rocky_mountain`, `west_coast` |
| **Used For** | Trend analysis, seasonal patterns, regional comparisons, volatility analysis |
| **License** | Public domain (U.S. government data) |

**How to Download:**
1. Visit the URL above
2. Click "Download Series History" → Select "Weekly" and all regions
3. Save to `/data/raw/eia_diesel_prices_weekly.csv`

---

## 2. ATRI Operational Cost of Trucking

| Field | Details |
|---|---|
| **Source** | American Transportation Research Institute (ATRI) |
| **URL** | https://atri-online.org/research/results/trucking-operational-costs/ |
| **File Format** | PDF (extracted to CSV) |
| **Raw Filename** | `atri_operational_costs.csv` |
| **Cleaned Filename** | `opcost_clean.csv` |
| **Coverage** | 2008 – 2023 (annual) |
| **Granularity** | Annual national averages |
| **Key Columns** | `year`, `fuel_cost_per_mile`, `total_cost_per_mile`, `driver_wages_per_mile`, `maintenance_per_mile` |
| **Used For** | Correlation analysis between diesel prices and cost-per-mile |
| **License** | Publicly available research report |

**How to Download:**
1. Visit the ATRI website and locate the most recent "Operational Costs of Trucking" annual report
2. Data tables are in the appendix — extract to CSV manually or use the Kaggle version (see below)

---

## 3. Kaggle — U.S. Diesel & Fuel Price Dataset

| Field | Details |
|---|---|
| **Source** | Kaggle |
| **URL** | https://www.kaggle.com/datasets/[search: "US diesel prices"] |
| **File Format** | CSV |
| **Raw Filename** | `kaggle_fuel_prices.csv` |
| **Cleaned Filename** | *(merged into diesel_prices_clean.csv)* |
| **Coverage** | Varies by dataset — verify before downloading |
| **Used For** | Supplemental validation of EIA figures; additional economic indicators |
| **License** | Verify dataset license on Kaggle before use |

**Recommended Search Terms on Kaggle:**
- "US retail diesel prices"
- "trucking freight cost data"
- "fuel surcharge rates trucking"

---

## Notes on Data Credibility

All datasets were evaluated using the **ROCCC framework** taught in the Google Data Analytics Certificate:

| Criterion | EIA Data | ATRI Data |
|---|---|---|
| **Reliable** | ✅ Federal government source | ✅ Industry research institute |
| **Original** | ✅ Primary collection | ✅ Survey-based primary research |
| **Comprehensive** | ✅ National + 9 regions, weekly | ⚠️ Annual only, national average |
| **Current** | ✅ Updated weekly | ⚠️ Annual report (1-year lag) |
| **Cited** | ✅ Full methodology published | ✅ Methodology documented in reports |

---

## File Inventory

```
data/
├── raw/
│   ├── eia_diesel_prices_weekly.csv      ← Downloaded from EIA (unmodified)
│   ├── atri_operational_costs.csv        ← Extracted from ATRI PDF report
│   └── kaggle_fuel_prices.csv            ← Downloaded from Kaggle (unmodified)
│
└── cleaned/
    ├── diesel_prices_clean.csv           ← Cleaned EIA data (see notebook Step 3)
    ├── opcost_clean.csv                  ← Cleaned ATRI cost data
    └── merged_analysis_dataset.csv       ← Final joined dataset used for analysis
```