# Customer-Analytics-SQL-Project-1

## Project Overview
**Project Title:** Customer Analytics in SQL Server (Mall Customers Enhanced)
**Level:** Beginner–Intermediate
**Tools:** SQL Server + SSMS, GitHub
**Dataset:** “Customer Analytics Practice Dataset” (Mall_Customers_Enhanced.csv) from Kaggle

A beginner‑friendly SQL Server project analyzing the Customer Analytics Practice Dataset (Mall_Customers_Enhanced.csv). Import via SSMS, clean and profile the data, then answer business questions on demographics, income, spending, savings, credit score, loyalty, and category preference. Includes analysis questions, documentation, and reproducible steps.

## Objectives

1. **Import & Setup:** Load Mall_Customers_Enhanced.csv via SSMS and create staging/curated tables.  
2. **Data Cleaning:** Standardize data types/values; handle nulls, duplicates, and out-of-range entries.  
3. **Exploratory Data Analysis (EDA):** Profile demographics, income, spending, savings, credit, and loyalty.  
4. **Business Analysis:** Answer segmentation and category-preference questions; identify high-value and at-risk segments.

##Project Structure

### 1. Database Setup

**Database Creation:** Create a database named p1_customer_analytics_db.
**Import from CSV (no staging):** Use SSMS “Import Flat File” to load Mall_Customers_Enhanced.csv directly into a table named customers. 

### 2. Data Exploration & Cleaning
**Table used:** Customers (CustomerID, Gender, Age, Annual_Income, Spending_Score, Age_Group, Estimated_Savings, Credit_Score, Loyalty_Years, Preferred_Category)

**Exploration**
1. **Write a SQL query to count total rows and distinct CustomerID.**
```sql
SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT CustomerID) AS distinct_customer_id 
FROM Customers
```

2. **Write a SQL query to list distinct values for Gender, Age_Group, and Preferred_Category.**
```sql
SELECT DISTINCT 'Gender' AS Category, Gender AS Distinct_Values FROM Customers
UNION ALL
SELECT DISTINCT 'Age_Group' AS Category, Age_Group AS Distinct_Values FROM Customers
UNION ALL
SELECT DISTINCT 'Preferred_Category' AS Category, Preferred_Category AS Distinct_Values FROM Customers
```

3. **Write a SQL query to get min/avg/median/max for Age, Annual_Income, Spending_Score, Estimated_Savings, Credit_Score, and Loyalty_Years.**
```sql
SELECT 
'Age' AS Category, 
MIN(Age) AS Minimum,
MAX(Age) AS Maximum,
AVG(Age) AS Average,
(SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Age) OVER() FROM Customers) AS Median
FROM Customers
UNION ALL
SELECT 
'Annual_Income' AS Category, 
MIN(Annual_Income) AS Minimum,
MAX(Annual_Income) AS Maximum,
AVG(Annual_Income) AS Average,
ROUND((SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Annual_Income) OVER() FROM Customers),2) AS Median
FROM Customers
UNION ALL
SELECT 
'Spending_Score' AS Category, 
MIN(Spending_Score) AS Minimum,
MAX(Spending_Score) AS Maximum,
AVG(Spending_Score) AS Average,
(SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Spending_Score) OVER() FROM Customers) AS Median
FROM Customers
UNION ALL
SELECT 
'Estimated_Savings' AS Category, 
ROUND(MIN(Estimated_Savings),2) AS Minimum,
ROUND(MAX(Estimated_Savings),2) AS Maximum,
ROUND(AVG(Estimated_Savings),2) AS Average,
ROUND((SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Estimated_Savings) OVER() FROM Customers),2) AS Median
FROM Customers
UNION ALL
SELECT 
'Credit_Score' AS Category, 
MIN(Credit_Score) AS Minimum,
MAX(Credit_Score) AS Maximum,
AVG(Credit_Score) AS Average,
(SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Credit_Score) OVER() FROM Customers) AS Median
FROM Customers
UNION ALL
SELECT 
'Loyalty_Years' AS Category, 
MIN(Loyalty_Years) AS Minimum,
MAX(Loyalty_Years) AS Maximum,
AVG(Loyalty_Years) AS Average,
(SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Loyalty_Years) OVER() FROM Customers) AS Median
FROM Customers;
```
