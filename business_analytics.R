# business_analytics.R
# Visual business insight dashboard for BusinessManagementDB

library(DBI)
library(odbc)
library(dplyr)
library(ggplot2)
library(lubridate)

# Connect to SQL Server
con <- dbConnect(odbc(),
                 Driver = "ODBC Driver 17 for SQL Server",
                 Server = "DESKTOP-YourName\\SQLInstance",  #--important!! server will need to be changed to server of user's sql database server name,
                 # --also add double backslashes so the server name wont be read as a empty escape character. 
                
                 Database = "BusinessManagementDB",
                 Trusted_Connection = "Yes")

# -- Revenue by State 
sales_state <- dbGetQuery(con, "
SELECT c.State, SUM(s.TotalAmount) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.State
")

ggplot(sales_state, aes(x = reorder(State, -TotalRevenue), y = TotalRevenue, fill = State)) +
  geom_col() +
  theme_minimal() +
  labs(title = 'Total Revenue by State',
       x = 'State',
       y = 'Revenue ($)')

# -- Revenue Trend by Month 
sales_month <- dbGetQuery(con, "
SELECT FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth, SUM(TotalAmount) AS Revenue
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM')
ORDER BY SaleMonth
")

ggplot(sales_month, aes(x = SaleMonth, y = Revenue, group = 1)) +
  geom_line(color = 'blue') +
  geom_point() +
  theme_minimal() +
  labs(title = 'Monthly Revenue Trend',
       x = 'Month',
       y = 'Revenue ($)') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# --Top Vendors by Revenue 
vendor_sales <- dbGetQuery(con, "
SELECT v.VendorName, SUM(s.TotalAmount) AS VendorRevenue
FROM Sales s
JOIN Vendors v ON s.VendorID = v.VendorID
GROUP BY v.VendorName
ORDER BY VendorRevenue DESC
")

ggplot(vendor_sales, aes(x = reorder(VendorName, VendorRevenue), y = VendorRevenue)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top Vendors by Revenue",
       x = "Vendor",
       y = "Revenue ($)")

# -- Scatter Plot: Customer Balance vs Sale Amount 
scatter_data <- dbGetQuery(con, "
SELECT ca.Balance, s.TotalAmount
FROM CustomerAccounts ca
JOIN Sales s ON ca.CustomerID = s.CustomerID
")

ggplot(scatter_data, aes(x = Balance, y = TotalAmount)) +
  geom_point(color = "darkred", size = 3, alpha = 0.7) +
  theme_minimal() +
  labs(title = "Customer Account Balance vs Sale Amount",
       x = "Customer Balance ($)",
       y = "Sale Total ($)")

# -- Identify Underperforming States 
low_states <- sales_state %>% filter(TotalRevenue < 500)

if (nrow(low_states) > 0) {
  print("⚠️ Underperforming States (Revenue < $500):")
  print(low_states)
} else {
  print("✅ All states are performing above $500 in revenue.")
}

dbDisconnect(con)
