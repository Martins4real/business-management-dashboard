# Business Management Dashboard
 A full-stack business data project using **SQL Server**, **Python**, and **R** to manage, interact with, and visualize business operations.
 Links: Video Demo https://youtu.be/cA2nOET_Pw8 | Portfolio WebPage https://martinevbayiro4.wixsite.com/martinsevbayiro-1 |
 

##  Tools Used
- SQL Server 2019+
- Python 3.10 (Tkinter + pyodbc)
- R + RStudio (ggplot2, DBI, dplyr)

##  What It Does

This project simulates a real business environment by tracking:
- Vendors
- Customers
- Employees
- Sales
- Invoices

I designed:
- A fully normalized SQL database (`BusinessManagementDB.sql`)
- A Python GUI (`business_dashboard.py`) that interacts with the database
- An R analytics dashboard (`business_analytics.R`) that turns data into charts and insights

##  File Guide

| File | Purpose |
|------|---------|
| `BusinessManagementDB.sql` | Creates and seeds the SQL database |
| `business_dashboard.py` | Desktop GUI for adding/viewing data |
| `business_analytics.R` | R charts for business insights |
| `SQL_Portfolio_Description.txt` | SQL explanation + example queries |
| `Rscript_explanation.txt` | What each R plot does |
| `README.md` | You're reading it! |
| `Python_Explanation.txt` | what the Python script does |

---

##  How to Run

### 1. SQL
Open `BusinessManagementDB.sql` in SSMS and run it.

### 2. Python GUI
```bash
pip install pyodbc
python business_dashboard.py
```

Before running, open `business_dashboard.py` and make sure this line matches **your local SQL Server instance**:

```python
Server = "localhost\SQLEXPRESS"  # Update to match your setup
```

You can find your exact SQL Server instance name by running this in SSMS:

```sql
SELECT @@SERVERNAME;
```

Then run

### 3. R Studio
Open `business_analytics.R` in RStudio

In the R file, make sure to also update your server name:

```r
Server = "DESKTOP-YourName\SQLInstance"  # Replace with your server
```

Then run. Use the “Plots” tab to view graphs.
