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

## Project Structure

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

4. **Write a SQL query to show customer counts by Gender, by Age_Group, and by Preferred_Category (separately)**
```sql
SELECT Gender, COUNT(CustomerID) AS Customer_counts
FROM Customers
GROUP BY Gender;

SELECT Age_Group, COUNT(CustomerID) AS Customer_counts
FROM Customers
GROUP BY Age_Group;

SELECT Preferred_Category, COUNT(CustomerID) AS Customer_counts
FROM Customers
GROUP BY Preferred_Category;
```

**Data quality checks**

5. **Write a SQL query to show null counts for each column.**
```sql
SELECT 'CustomerID' AS Category_name,
SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Null_Count
FROM Customers

UNION ALL

SELECT 'Gender',
SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Age',
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Annual_Income',
SUM(CASE WHEN Annual_Income IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Spending_Score',
SUM(CASE WHEN Spending_Score IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Age_Group',
SUM(CASE WHEN Age_Group IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Estimated_Savings',
SUM(CASE WHEN Estimated_Savings IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Credit_Score',
SUM(CASE WHEN Credit_Score IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Loyalty_Years',
SUM(CASE WHEN Loyalty_Years IS NULL THEN 1 ELSE 0 END)
FROM Customers

UNION ALL

SELECT 'Preferred_Category',
SUM(CASE WHEN Preferred_Category IS NULL THEN 1 ELSE 0 END)
FROM Customers
ORDER BY Null_Count DESC;
```
6. **Write a SQL query to find out-of-range values**
```sql
SELECT *
FROM Customers
WHERE (Age NOT BETWEEN 10 AND 100) OR
(Spending_Score NOT BETWEEN 0 AND 100) OR
(Credit_Score NOT BETWEEN 300 AND 900) OR
(Annual_Income < 0 OR Estimated_Savings <0) OR
(Loyalty_Years < 0 OR Loyalty_Years> 60)
```
7. **Write a SQL query to find inconsistencies between age and age_group (e.g., Age=23 but AgeGroup not in 18–25)**
```sql
SELECT CustomerID, Age, Age_Group
FROM Customers
WHERE (Age < 18 AND Age_Group IS NOT NULL) OR
(Age BETWEEN 18 AND 25 AND Age_Group != '18-25') OR
(Age BETWEEN 26 AND 35 AND Age_Group != '26-35') OR
(Age BETWEEN 36 AND 50 AND Age_Group != '36-50') OR
(Age BETWEEN 51 AND 65 AND Age_Group != '51-65') OR
(Age >= 66 AND Age_Group != '65+') OR Age_Group IS NULL;
```
**Cleaning Actions**

8. **Write SQL to handle NULLs in Age_Group column.**

It was found there were 4 null age groups belonging to age 18.
```sql
UPDATE Customers
SET Age_Group = '18-25' 
WHERE Age = 18 AND Age_Group IS NULL;
```
