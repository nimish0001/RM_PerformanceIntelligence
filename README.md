# 🏦 RM Performance Intelligence

### Banking Relationship Manager Analytics | Python + MySQL

> **Turning raw, inconsistent banking data into structured, business-ready insights using Python and SQL.**

![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Cleaning-150458?logo=pandas&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?logo=mysql&logoColor=white)
![Google Colab](https://img.shields.io/badge/Google%20Colab-Notebook-F9AB00?logo=googlecolab&logoColor=white)
![Status](https://img.shields.io/badge/Status-Dashboard%20Phase%20Upcoming-orange)

---

## 📌 Project Overview

This project analyzes **Relationship Manager (RM) performance** in a retail banking setup. It covers sales activity, target achievement, customer portfolios, loans, complaints, and customer feedback.

It follows a complete, end-to-end **data analytics workflow**:

1. Generate a realistic but intentionally **messy** synthetic banking dataset with Python
2. **Clean, standardize and impute** the data with Pandas
3. Store the clean data in a **MySQL** relational database
4. Answer **19 business questions** with SQL (joins, aggregations, CTEs, subqueries, window functions)

> **Note:** Real banking/RM data is not publicly available, so all data in this project is **synthetically generated** with Python (`Faker`, `NumPy`, `random`) using a fixed seed (`42`) for reproducibility.

---

## 🎯 Business Objective

Give bank management a clear, data-backed view of:

- 👨‍💼 Which RMs perform best, and why
- 💰 Sales and revenue by RM and product
- 🎯 Monthly target vs. achievement
- 👥 Customer distribution and segmentation per RM
- 🏦 Loan portfolio across types and statuses
- 📞 Complaint volume and resolution speed
- ⭐ Customer satisfaction and sentiment
- 🏢 City-level and RM-level performance

---

## 🔄 Project Workflow

```text
🐍 Python (Faker, NumPy)
        │   Synthetic dataset generation
        ▼
🗃️ Raw / Messy CSVs  (7 tables)
        │   Nulls, wrong formats, outliers, typos, duplicates
        ▼
🧹 Data Cleaning & Imputation  (Pandas)
        │   Standardize, validate, impute, derive new columns
        ▼
📊 Cleaned CSVs  (0 missing values)
        │
        ▼
🛢️ MySQL Database  (7 tables, PK/FK relationships)
        │
        ▼
🔎 SQL Business Analysis  (19 business questions)
        │
        ▼
💡 Business Insights
        │
        ▼
🚧 Dashboard & Reporting  (upcoming phase)
```

---

## 📁 Repository Structure

```text
RM_PerformanceIntelligence/
│
├── 01_dataset_creation/
│   └── create_rm_dataset.py          # Generates the 7 raw (messy) tables
│
├── 02_data_cleaning/
│   ├── 01_raw_data/                  # Raw CSVs (input to cleaning)
│   │   ├── rm_master.csv
│   │   ├── customers.csv
│   │   ├── loans.csv
│   │   ├── sales.csv
│   │   ├── targets.csv
│   │   ├── complaints.csv
│   │   └── customer_feedback.csv
│   ├── 02_cleaning.py                # Cleaning + imputation pipeline
│   └── 03_cleaned_data/              # Cleaned CSVs (output, ready for SQL)
│       ├── rm_master_cleaned.csv
│       ├── customers_cleaned.csv
│       ├── loans_cleaned.csv
│       ├── sales_cleaned.csv
│       ├── targets_cleaned.csv
│       ├── complaints_cleaned.csv
│       └── feedback_cleaned.csv
│
├── 03_sql_analysis/
│   └── creating_tables.sql           # Database + table schema (PK/FK)
│
├── 04_business_ques.sql              # 19 business questions with SQL solutions
└── README.md
```

---

## 🗂️ Dataset Description

| Table | Records | Description |
|---|---:|---|
| `RM_Master` | 250 | RM profile: name, city, age, gender, joining date, experience |
| `Customers` | 2,500 | Customer profile: RM assigned, age, gender, city, income, segment |
| `Loans` | 10,000 | Loan type, amount, status, linked customer and RM |
| `Sales` | 15,000 | Product sales by RM with date and amount |
| `Targets` | ~5,400 | Monthly target vs. achievement per RM (2023-2024) |
| `Complaints` | 2,500 | Complaint type and resolution time per customer/RM |
| `Feedback` | ~3,700 | Customer ratings (1-5), dates, city, sentiment |

### Entity Relationships

```text
                         ┌──────────────┐
                         │  RM_Master   │
                         │  (RM_ID PK)  │
                         └──────┬───────┘
      ┌─────────────┬───────────┼────────────┬───────────────┐
      ▼             ▼           ▼            ▼               ▼
 ┌──────────┐  ┌────────┐  ┌─────────┐  ┌──────────┐   ┌────────────┐
 │Customers │  │ Sales  │  │ Targets │  │  Loans   │   │ Complaints │
 │(Cust PK) │  └────────┘  └─────────┘  └──────────┘   └────────────┘
 └────┬─────┘                                ▲               ▲
      │  (Customer_ID FK)                    │               │
      └──────────────────────────────────────┴───────────────┘
      │
      ▼
 ┌──────────┐
 │ Feedback │  (also linked to RM_Master via RM_ID)
 └──────────┘
```

### Key Business Values

- **Products (12):** Mutual Funds, Life Insurance, Health Insurance, Fixed Deposit, Recurring Deposit, Credit Card, Saving Account, Current Account, Term Insurance, ULIP, Loan Against Property, Gold Investment
- **Loan types (7):** Home, Personal, Car, Education, Business, Gold, Plot
- **Loan statuses (6):** Active, Closed, Defaulted, Pending, Approved, Rejected
- **Customer segments (5):** Bronze, Silver, Gold, Premium, Platinum
- **Cities (10):** Mumbai, Delhi, Bangalore, Chennai, Hyderabad, Pune, Kolkata, Ahmedabad, Jaipur, Lucknow
- **Complaint types (10):** Service Issue, Billing Error, Product Issue, Delay, Staff Behavior, Loan Disbursement, Account Access, Credit Card Issue, Insurance Claim, Technical Issue

---

## 🧪 Step 1: Synthetic Data Generation

**File:** `01_dataset_creation/create_rm_dataset.py`

The script generates realistic data and **deliberately injects real-world data quality problems** so that the cleaning step has meaningful work to do:

| Problem injected | Example |
|---|---|
| Missing values (NaN) | Missing RM name, city, age, customer ID, etc. |
| Mixed date formats | `2023-05-12`, `12/05/2023`, `05-12-2023` |
| Inconsistent text | `PREMIUM`, `premium`, `" Gold "`, `M@rk3t` |
| Invalid / extreme numbers | Negative income, `999999999` loan amounts, ratings of `0`, `6`, `10` |
| Amount stored as text | `"250000 INR"` |
| Unrealistic values | RM experience of 35-45 years, resolution time of `-5` or `999` days |
| Missing months | ~10% of RM target months are dropped |

---

## 🧹 Step 2: Data Cleaning & Imputation

**File:** `02_data_cleaning/02_cleaning.py`

### Cleaning Rules

| Area | What is done |
|---|---|
| **Dates** | Multiple formats parsed and standardized to a single datetime format |
| **Text** | Extra spaces removed, special characters stripped, casing normalized |
| **IDs** | `RM_ID` / `Customer_ID` standardized (uppercase, correct prefix) |
| **Numeric outliers** | Invalid values (negative, zero, out-of-range) converted to NaN |
| **Categoricals** | Validated against allowed lists (segment, loan type/status, product, complaint type) |
| **Foreign keys** | IDs not found in parent tables are treated as missing |
| **Duplicates** | Removed on primary keys / natural keys |

### Imputation Strategy

| Column type | Method |
|---|---|
| City | Most frequent value (mode) |
| Gender | Random sample based on existing distribution |
| Age | Median by gender |
| Experience | Derived from joining date (or age) |
| Income | Based on segment and age |
| Segment | Based on income bands |
| Loan / sale amount | Based on typical value for loan type / product |
| Loan type, status, product, complaint type | Sampled from existing distribution |
| Target | Median target of that RM |
| Achievement | Random percentage (50%-120%) of target |
| Resolution time | Median by complaint type |
| Rating | Median rating |
| Foreign keys (RM_ID, Customer_ID) | Random valid ID |

### New Columns Derived During Cleaning

| Column | Table | Logic |
|---|---|---|
| `Achievement_Pct` | Targets | `Achievement / Target × 100` |
| `Resolution_Status` | Complaints | `Quick` (≤ 7 days), `Normal` (≤ 30 days), `Delayed` (> 30 days) |
| `Sentiment` | Feedback | `Positive` (≥ 4), `Neutral` (≥ 3), `Negative` (< 3) |

**Result:** all 7 tables are cleaned with **zero missing values** and are ready to load into SQL.

---

## 🛢️ Step 3: MySQL Database Setup

**File:** `03_sql_analysis/creating_tables.sql`

Creates the `RM_Performance` database with 7 tables, primary keys, and foreign keys.

**Recommended load order** (parent tables first, to satisfy foreign keys):

```text
1. RM_Master
2. Customers
3. Loans
4. Sales
5. Targets
6. Complaints
7. Feedback
```

Load the CSVs from `02_data_cleaning/03_cleaned_data/` using **MySQL Workbench → Table Data Import Wizard** or `LOAD DATA INFILE`.

---

## 🔎 Step 4: SQL Business Analysis

**File:** `04_business_ques.sql`

| # | Business Question | SQL Concepts |
|---:|---|---|
| 1 | Top-performing RMs by total sales | `JOIN`, `SUM`, `GROUP BY`, `ORDER BY`, `LIMIT` |
| 2 | RMs selling the widest product variety | `COUNT(DISTINCT)` |
| 3 | RMs managing the most customers | `JOIN`, `COUNT` |
| 4 | RMs with the highest customer satisfaction | `AVG`, `HAVING` (min. 5 feedbacks) |
| 5 | RMs with the most complaints (and avg. resolution time) | `COUNT`, `AVG` |
| 6 | RMs aged between 30 and 40 | `BETWEEN` |
| 7 | Female RMs with more than 5 years of experience | Multi-condition `WHERE` |
| 8 | Male RMs with more than 6 years of experience | Multi-condition `WHERE` |
| 9 | RMs who sold Fixed Deposit or Life Insurance | `IN`, `GROUP BY` |
| 10 | RMs exceeding 100% target in a given month | `JOIN`, filter on `Achievement_Pct` |
| 11 | RMs with Premium-segment customers | `JOIN`, `WHERE`, `COUNT` |
| 12 | RMs performing above average sales | **CTE** + **subquery** |
| 13 | RMs whose total loan portfolio is above the average RM loan portfolio | Multiple **CTEs**, `CROSS JOIN` |
| 14 | RMs who achieved more than 80% of their total target | **CTE**, `SUM`, percentage calculation |
| 15 | Branches whose total sales are above the average branch sales | Multiple **CTEs**, `CROSS JOIN` |
| 16 | Latest transaction of every customer | `ROW_NUMBER()` window function |
| 17 | Top 3 RMs in each branch | `RANK()` with `PARTITION BY` |
| 18 | Second-highest RM in each branch | `DENSE_RANK()` with `PARTITION BY` |
| 19 | Difference between current and previous sales | `LAG()` window function |

### Sample Query 1: Top 10 RMs by Sales

```sql
SELECT
    R.RM_ID,
    R.RM_Name,
    SUM(S.Amount) AS Total_Sales
FROM RM_Master R
JOIN Sales S
    ON R.RM_ID = S.RM_ID
GROUP BY R.RM_ID, R.RM_Name
ORDER BY Total_Sales DESC
LIMIT 10;
```

### Sample Query 2: Sales Change vs. Previous Sale (Window Function)

```sql
SELECT
    RM_ID,
    Sale_Date,
    Amount,
    LAG(Amount) OVER (
        PARTITION BY RM_ID
        ORDER BY Sale_Date
    ) AS previous_sales,
    Amount - LAG(Amount) OVER (
        PARTITION BY RM_ID
        ORDER BY Sale_Date
    ) AS sales_difference
FROM Sales;
```

---

## 🚀 How to Run

### Prerequisites

- Python 3.8+ (or Google Colab)
- MySQL 8.0+ and MySQL Workbench
- Python libraries: `pandas`, `numpy`, `faker`, `scikit-learn`

```bash
pip install pandas numpy faker scikit-learn
```

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/<your-username>/RM_PerformanceIntelligence.git
cd RM_PerformanceIntelligence
```

**2. (Optional) Regenerate the raw data**
Run `01_dataset_creation/create_rm_dataset.py`. It creates the `rm_data/` folder with 7 raw CSVs.

**3. Clean the data**
Run `02_data_cleaning/02_cleaning.py`. It reads from `rm_data/` and writes to `rm_data_cleaned_complete/`.

> ⚠️ Both scripts were written for **Google Colab** (they use `!pip install` and `google.colab`). To run locally, remove those lines and install the packages with `pip` instead. Pre-generated raw and cleaned files are already included in the repo, so you can skip steps 2 and 3.

**4. Create the database**
```sql
SOURCE 03_sql_analysis/creating_tables.sql;
```

**5. Import the cleaned CSVs** into the tables (in the order listed above).

**6. Run the analysis**
Open `04_business_ques.sql` in MySQL Workbench and run each of the 19 queries.

---

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| Language | Python, SQL (Joins, CTEs, Subqueries, Window Functions) |
| Data generation | Faker, NumPy, random |
| Data cleaning | Pandas, NumPy, re |
| Database | MySQL |
| Environment | Google Colab, MySQL Workbench |
| Version control | Git, GitHub |

---

## 📌 Notes & Limitations

- The data is **synthetic**, so business patterns in the results reflect the random generation logic, not real bank behavior.
- Missing IDs (e.g., `RM_ID`, `Customer_ID`) are imputed with **random valid IDs** to keep foreign key integrity. This is fine for a portfolio project, but in production such records would usually be flagged or excluded instead.
- Query 10 is currently filtered on a single month (`2023-01`); change the `Month` value to analyze other periods.

---

## 🔮 Future Scope

- 📊 Interactive dashboard (Power BI / Tableau) for RM, branch and city performance
- 🔍 Exploratory Data Analysis (EDA) with visualizations in Python
- 📈 RM performance scoring and ranking model
- 🧠 Predictive analysis for target achievement and loan default risk
- 🗺️ City-wise and segment-wise deep-dive reports

---

## 👤 Author

**Nimish Jaiswal**
📧 nimishjaiswal44@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/nimish-jaiswal0017/) | [GitHub](https://github.com/nimish0001)

---

⭐ If you found this project useful, please consider giving it a star!
