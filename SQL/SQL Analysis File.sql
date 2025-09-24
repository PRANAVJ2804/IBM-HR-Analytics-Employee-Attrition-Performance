create database IBM;
use IBM;

select * from HR;

ALTER TABLE HR RENAME COLUMN ï»¿Age TO Age;

SELECT COUNT(*) AS total_records FROM HR;

# Check null or missing values count per column
SELECT 
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_age,
  SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS missing_attrition,
  SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS missing_department,
  SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS missing_monthly_income
FROM HR;

# Summary statistics for key numeric columns
SELECT 
  AVG(Age) AS avg_age, MIN(Age) AS min_age, MAX(Age) AS max_age,
  AVG(MonthlyIncome) AS avg_monthly_income, MIN(MonthlyIncome) AS min_monthly_income, MAX(MonthlyIncome) AS max_monthly_income,
  AVG(DistanceFromHome) AS avg_distance_from_home
FROM HR;

# Frequency counts for important categorical variables
SELECT Attrition, COUNT(*) AS count FROM HR GROUP BY Attrition ORDER BY count DESC;
SELECT Department, COUNT(*) AS count FROM HR GROUP BY Department ORDER BY count DESC;
SELECT Gender, COUNT(*) AS count FROM HR GROUP BY Gender ORDER BY count DESC;
SELECT JobRole, COUNT(*) AS count FROM HR GROUP BY JobRole ORDER BY count DESC;

# Cross tabulation example: Attrition by Department
SELECT Department, Attrition, COUNT(*) AS count 
FROM HR 
GROUP BY Department, Attrition 
ORDER BY Department, Attrition;

# Average Monthly Income by Attrition
SELECT Attrition, AVG(MonthlyIncome) AS avg_monthly_income
FROM HR
GROUP BY Attrition;

# Distribution of YearsAtCompany
SELECT YearsAtCompany, COUNT(*) AS frequency
FROM HR
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;

# Average Age by Job Role
SELECT JobRole, AVG(Age) AS avg_age
FROM HR
GROUP BY JobRole
ORDER BY avg_age DESC;

# Average Performance Rating by Job Role
SELECT JobRole, AVG(PerformanceRating) AS avg_performance_rating
FROM HR
GROUP BY JobRole
ORDER BY avg_performance_rating DESC;

# Ranking employees by MonthlyIncome within each Department
SELECT 
  EmployeeNumber, Department, MonthlyIncome,
  RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS IncomeRankWithinDept
FROM HR;

# Calculate cumulative count of attrition by Department ordered by EmployeeNumber
SELECT 
  EmployeeNumber, Department, Attrition,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) OVER (PARTITION BY Department ORDER BY EmployeeNumber) AS CumulativeAttrition
FROM HR;

# Find departments with highest attrition rates
SELECT Department, AttritionRate
FROM (
  SELECT Department, 
  AVG(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) AS AttritionRate
  FROM HR
  GROUP BY Department
) AS DeptAttrition
WHERE AttritionRate = (SELECT MAX(AttritionRate) FROM (
                        SELECT Department, 
                        AVG(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) AS AttritionRate
                        FROM HR
                        GROUP BY Department) x);