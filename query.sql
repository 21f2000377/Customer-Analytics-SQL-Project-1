--Write a SQL query to count total rows and distinct CustomerID.

SELECT COUNT(*) AS total_rows,
COUNT(DISTINCT CustomerID) AS distinct_customer_id 
FROM Customers

--Write a SQL query to list distinct values for Gender, Age_Group, and Preferred_Category.
SELECT DISTINCT 'Gender' AS Category, Gender AS Distinct_Values FROM Customers
UNION ALL
SELECT DISTINCT 'Age_Group' AS Category, Age_Group AS Distinct_Values FROM Customers
UNION ALL
SELECT DISTINCT 'Preferred_Category' AS Category, Preferred_Category AS Distinct_Values FROM Customers

--Write a SQL query to get min/avg/median/max for Age, Annual_Income, Spending_Score, Estimated_Savings, Credit_Score, and Loyalty_Years.

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

--Write a SQL query to show customer counts by Gender, by Age_Group, and by Preferred_Category (separately)

SELECT Gender, COUNT(CustomerID) AS Customer_counts
FROM Customers
GROUP BY Gender;

SELECT Age_Group, COUNT(CustomerID) AS Customer_counts
FROM Customers
GROUP BY Age_Group;

SELECT Preferred_Category, COUNT(CustomerID) AS Customer_counts
FROM Customers
GROUP BY Preferred_Category;

--Write a SQL query to show null counts for each column.

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

--Write a SQL query to flag out-of-range values:

SELECT *
FROM Customers
WHERE (Age NOT BETWEEN 10 AND 100) OR
(Spending_Score NOT BETWEEN 0 AND 100) OR
(Credit_Score NOT BETWEEN 300 AND 900) OR
(Annual_Income < 0 OR Estimated_Savings <0) OR
(Loyalty_Years < 0 OR Loyalty_Years> 60)

--Write a SQL query to find inconsistencies between age and age_group (e.g., Age=23 but AgeGroup not in 18–25).

SELECT CustomerID, Age, Age_Group
FROM Customers
WHERE (Age < 18 AND Age_Group IS NOT NULL) OR
(Age BETWEEN 18 AND 25 AND Age_Group != '18-25') OR
(Age BETWEEN 26 AND 35 AND Age_Group != '26-35') OR
(Age BETWEEN 36 AND 50 AND Age_Group != '36-50') OR
(Age BETWEEN 51 AND 65 AND Age_Group != '51-65') OR
(Age >= 66 AND Age_Group != '65+') OR Age_Group IS NULL;

--Write SQL to handle NULLs in Age_Group column.
UPDATE Customers
SET Age_Group = '18-25' 
WHERE Age = 18 AND Age_Group IS NULL;

--Write a SQL query to show customer counts and share (%) by Preferred_Category (sorted by share).

SELECT Preferred_Category,
COUNT(CustomerID) AS Customer_Count,
ROUND(COUNT(CustomerID)*100.0/(SELECT COUNT(*) FROM Customers),2) AS Share_Percent
FROM Customers
GROUP BY Preferred_Category
ORDER BY share_percent DESC;

--Write a SQL query to calculate average Spending_Score and Annual_Income for each Preferred_Category.

SELECT Preferred_Category, 
ROUND(AVG(Spending_Score),2) AS Avg_spending_score,
ROUND(AVG(Annual_Income),2) AS Avg_annual_income
FROM Customers
GROUP BY Preferred_Category
ORDER BY Avg_spending_score DESC, Avg_annual_income DESC;

--Write a SQL query to find the Age_Group with the highest average Estimated_Savings.

SELECT TOP 1
Age_Group,
ROUND(AVG(Estimated_Savings),2) AS Highest_Avg_est_savings
FROM Customers
GROUP BY Age_Group
ORDER BY Highest_Avg_est_savings DESC

--Write a SQL query to list the top 10 customers by Estimated_Savings (include Age_Group and Preferred_Category).

SELECT TOP 10
CustomerID, Age_Group, Preferred_Category, ROUND(Estimated_Savings,2) AS Estimated_Savings
FROM Customers
ORDER BY Estimated_Savings DESC;

--Write a SQL query to compute average Credit_Score by Gender and by Age_Group (two separate summaries).

SELECT 'Gender' AS Category_type, Gender AS Value,  ROUND(AVG(Credit_Score),2) AS Avg_credit_score
FROM Customers
GROUP BY Gender

UNION ALL

SELECT 'Age_Group' AS Category_type, Age_Group AS Value,  ROUND(AVG(Credit_Score),2) AS Avg_credit_score
FROM Customers
GROUP BY Age_Group;

--Write a SQL query to show average Loyalty_Years by Preferred_Category.
SELECT Preferred_Category, ROUND(AVG(Loyalty_Years),2) AS Avg_loyalty_years
FROM Customers
GROUP BY Preferred_Category
ORDER BY Avg_loyalty_years DESC;

--Write a SQL query to find the Preferred_Category mix for each Gender (counts and % within each gender).

SELECT Gender, Preferred_Category, COUNT(Preferred_Category) AS category_count, ROUND(COUNT(Preferred_Category)*100.0/SUM(COUNT(Preferred_Category)) OVER(PARTITION BY Gender),2) AS percent_within_gender
FROM Customers
GROUP BY Gender, Preferred_Category
ORDER BY percent_within_gender DESC;

--Write a SQL query to rank Age_Groups by average Spending_Score (highest to lowest).

SELECT Age_Group, avg_spending_score , RANK() OVER(ORDER BY avg_spending_score DESC) AS rnk
FROM(
SELECT Age_Group, ROUND(AVG(Spending_Score),2) AS avg_spending_score
FROM Customers
GROUP BY Age_Group
)t
ORDER BY rnk;

--Write a SQL query to return customers with Credit_Score < 600 along with counts by Preferred_Category.

SELECT Preferred_Category, COUNT(CustomerID) AS count
FROM Customers
WHERE Credit_Score < 600
GROUP BY Preferred_Category
ORDER BY count DESC;

--Write a SQL query to list customers whose Annual_Income is above the overall average and Spending_Score is also above the overall average.

SELECT CustomerID
FROM Customers
WHERE Annual_Income > (SELECT AVG(Annual_Income) FROM Customers) AND Spending_Score > (SELECT AVG(Spending_Score) FROM Customers)

--Write a SQL query to bucket Annual_Income into bands (e.g., Under 30k, 30–60k, 60–100k, 100k+) and show the category distribution per band.

SELECT Income_band, COUNT(Income_band) AS Count, ROUND(COUNT(Income_band)*100.0/(SELECT COUNT(*) FROM Customers),2) AS category_distribution
FROM(
SELECT Annual_Income,
CASE WHEN Annual_Income < 30 THEN 'Under 30k' 
WHEN Annual_Income BETWEEN 30 AND 60 THEN '30-60k' 
WHEN Annual_Income BETWEEN 61 AND 100 THEN '61-100k' ELSE '100k+' END AS Income_band
FROM Customers)t
GROUP BY Income_band
ORDER BY category_distribution DESC

--Write a SQL query to create income deciles and report average Spending_Score within each decile.

SELECT Income_Decile, AVG(Spending_Score) AS Avg_spending_score
FROM(
SELECT CustomerID, Spending_Score,
Annual_Income,
NTILE(10) OVER(ORDER BY Annual_Income) As Income_Decile
FROM Customers)t
GROUP BY Income_Decile

-- Write a SQL query to compute the Savings_to_Income ratio for each customer and list the top 10 ratios.

SELECT TOP 10
CustomerID, ROUND(Estimated_Savings/Annual_Income,2) AS Savings_to_Income_ratio
FROM Customers
ORDER BY Savings_to_Income_ratio DESC;

-- Write a SQL query to identify “under‑savers”: customers in the top income decile but with Estimated_Savings below the overall median.

SELECT CustomerID 
FROM (
SELECT CustomerID, NTILE(10) OVER(ORDER BY Annual_Income DESC) AS income_decile, Estimated_Savings
FROM Customers
WHERE Estimated_Savings < (SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Estimated_Savings) OVER() FROM Customers)
)t
WHERE income_decile = 1;

--Write a SQL query to band Credit_Score (Poor, Fair, Good, Very Good, Exceptional) and show average Spending_Score and counts per band.

SELECT credit_band, AVG(Spending_Score) AS Avg_spending_score, COUNT(*) AS count_per_band
FROM(
SELECT Credit_Score, Spending_Score,
CASE WHEN Credit_Score <=300 THEN 'Poor'
WHEN Credit_Score between 301 AND 400 THEN 'Fair'
WHEN Credit_Score BETWEEN 401 AND 550 THEN 'Good'
WHEN Credit_Score BETWEEN 551 AND 800 THEN 'Very Good'
ELSE 'Exceptional' END AS credit_band
FROM Customers)t
GROUP BY credit_band
ORDER BY Avg_spending_score DESC;


-- Write a SQL query to find the Gender gap in Spending_Score within each Age_Group (difference Male vs Female).


SELECT Age_Group,AVG(CASE WHEN Gender='Male' THEN Spending_Score ELSE NULL END) AS male_spending_score, AVG(CASE WHEN Gender='Female' THEN Spending_Score ELSE NULL END) AS female_spending_score, ABS(AVG(CASE WHEN Gender='Male' THEN Spending_Score ELSE NULL END)-AVG(CASE WHEN Gender='Female' THEN Spending_Score ELSE NULL END)) AS Gender_gap
FROM Customers
GROUP BY Age_Group
ORDER BY Gender_gap DESC;

--- Write a SQL query to return the top 3 customers by Spending_Score within each Preferred_Category (rank per category).

SELECT CustomerID, Preferred_Category,  Spending_Score, rnk
FROM(
SELECT CustomerID, Preferred_Category, Spending_Score, DENSE_RANK() OVER(PARTITION BY Preferred_Category ORDER BY Spending_Score DESC) AS rnk
FROM Customers)t
WHERE rnk IN (1,2,3)

--Write a SQL query to compute the 90th percentile of Spending_Score overall and by Age_Group.

SELECT DISTINCT 'Overall' AS category, 
PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY Spending_Score) OVER() AS percentile_90
FROM Customers
UNION ALL
SELECT DISTINCT Age_Group AS category, 
PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY Spending_Score) OVER(PARTITION BY Age_Group) AS percentile_90
FROM Customers

--Write a SQL query to pivot Age_Group as rows and Preferred_Category as columns showing customer counts (or avg Spending_Score).

SELECT 
Age_Group AS Age_Group, 
SUM(CASE WHEN Preferred_Category='Budget' THEN 1 ELSE 0 END) AS budget_category,
SUM(CASE WHEN Preferred_Category='Electronics' THEN 1 ELSE 0 END) AS electronics_category,
SUM(CASE WHEN Preferred_Category='Fashion' THEN 1 ELSE 0 END) AS fashion_category,
SUM(CASE WHEN Preferred_Category='Luxury' THEN 1 ELSE 0 END) AS luxury_category
FROM Customers
GROUP BY Age_Group

--Write a SQL query to find customers whose Annual_Income is above their Age_Group average 
--AND whose Spending_Score is above their Age_Group average.

SELECT CustomerID,
Age_Group,
Annual_Income,
Spending_Score
FROM Customers c
WHERE Annual_Income > (SELECT AVG(Annual_Income) FROM Customers WHERE Age_Group = c.Age_Group) AND
Spending_Score > (SELECT AVG(Spending_Score) FROM Customers WHERE Age_Group = c.Age_Group)
ORDER BY Age_Group, CustomerID
