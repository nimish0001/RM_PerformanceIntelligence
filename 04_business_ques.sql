                                    ==============   BUSINESS QUESTIONS   ===============

                                      
                                      
-- Ques-1) Who are the top-performing RMs based on total sales generated?
SELECT
    R.RM_ID,
    R.RM_Name,
    SUM(S.Amount) AS Total_Sales
FROM RM_Master R
JOIN Sales S
    ON R.RM_ID = S.RM_ID
GROUP BY
    R.RM_ID,
    R.RM_Name
ORDER BY Total_Sales DESC
LIMIT 10;



-- Ques-2) Which RMs sell the widest variety of products?
SELECT
    R.RM_ID,
    R.RM_Name,
    COUNT(DISTINCT S.Product) AS Products_Sold
FROM RM_Master R
JOIN Sales S
    ON R.RM_ID = S.RM_ID
GROUP BY
    R.RM_ID,
    R.RM_Name
ORDER BY Products_Sold DESC
LIMIT 10;



-- Ques-3) Which RMs manage the highest number of customers?
SELECT
    R.RM_ID,
    R.RM_Name,
    COUNT(C.Customer_ID) AS Customers_Managed
FROM RM_Master R
JOIN Customers C
    ON R.RM_ID = C.RM_ID
GROUP BY
    R.RM_ID,
    R.RM_Name
ORDER BY Customers_Managed DESC
LIMIT 10;



-- Ques-4) Which RMs have the highest customer satisfaction?
SELECT
    R.RM_ID,
    R.RM_Name,
    COUNT(F.Customer_ID) AS Feedback_Count,
    ROUND(AVG(F.Rating), 2) AS Average_Rating
FROM RM_Master R
JOIN Feedback F
    ON R.RM_ID = F.RM_ID
GROUP BY
    R.RM_ID,
    R.RM_Name
HAVING COUNT(F.Customer_ID) >= 5
ORDER BY Average_Rating DESC
LIMIT 10;



-- Ques-5) Which RMs have the highest number of complaints?
SELECT
    R.RM_ID,
    R.RM_Name,
    COUNT(C.Complaint_ID) AS Complaint_Count,
    ROUND(AVG(C.Resolution_Time), 2) AS Avg_Resolution_Time
FROM RM_Master R
JOIN Complaints C
    ON R.RM_ID = C.RM_ID
GROUP BY
    R.RM_ID,
    R.RM_Name
ORDER BY Complaint_Count DESC
LIMIT 10;



-- Ques-6) Which RMs are between 30 and 40 years old?
SELECT
    RM_ID,
    RM_Name,
    Age,
    Experience,
    City
FROM RM_Master
WHERE Age BETWEEN 30 AND 40
ORDER BY Age;



-- Ques-7) Which female RMs have more than 5 years of experience?
SELECT
    RM_ID,
    RM_Name,
    Gender,
    Age,
    Experience,
    City
FROM RM_Master
WHERE Gender = 'F'
  AND Experience > 5
ORDER BY Experience DESC;



-- Ques-8)  Which male RMs have more than 6 years of experience?
SELECT
    RM_ID,
    RM_Name,
    Gender,
    Age,
    Experience,
    City
FROM RM_Master
WHERE Gender = 'M'
  AND Experience > 6
ORDER BY Experience DESC;



-- Ques-9) Which RMs sold Fixed Deposit or Life Insurance?
SELECT
    R.RM_ID,
    R.RM_Name,
    S.Product,
    SUM(S.Amount) AS Total_Sales
FROM RM_Master R
JOIN Sales S
    ON R.RM_ID = S.RM_ID
WHERE S.Product IN ('Fixed Deposit', 'Life Insurance')
GROUP BY
    R.RM_ID,
    R.RM_Name,
    S.Product
ORDER BY Total_Sales DESC;



-- Ques-10) Which RMs achieved more than 100% in a particular month?
SELECT
    R.RM_ID,
    R.RM_Name,
    T.Month,
    T.Target,
    T.Achievement,
    T.Achievement_Pct
FROM RM_Master R
JOIN Targets T
    ON R.RM_ID = T.RM_ID
WHERE T.Month = '2023-01'
  AND T.Achievement_Pct > 100
ORDER BY T.Achievement_Pct DESC;



-- Ques-11) Which RMs have customers from the Premium segment?
SELECT
    R.RM_ID,
    R.RM_Name,
    COUNT(C.Customer_ID) AS Premium_Customers
FROM RM_Master R
JOIN Customers C
    ON R.RM_ID = C.RM_ID
WHERE C.Segment = 'Premium'
GROUP BY
    R.RM_ID,
    R.RM_Name
ORDER BY Premium_Customers DESC;



-- Ques-12) Which RMs are above the average RM sales performance?
WITH RM_Sales AS
(
    SELECT
        RM_ID,
        SUM(Amount) AS Total_Sales
    FROM Sales
    GROUP BY RM_ID
)

SELECT
    R.RM_ID,
    R.RM_Name,
    S.Total_Sales
FROM RM_Sales S
JOIN RM_Master R
    ON S.RM_ID = R.RM_ID
WHERE S.Total_Sales >
(
    SELECT AVG(Total_Sales)
    FROM RM_Sales
)
ORDER BY S.Total_Sales DESC;



-- Ques-13) Find RMs whose total loan portfolio is greater than average RM loan portfolio.
WITH rm_loans AS (
    SELECT
        RM_ID,
        SUM(Loan_Amount) AS total_loan
    FROM Loan
    GROUP BY RM_ID
),
avg_loan AS (
    SELECT AVG(total_loan) AS avg_rm_loan
    FROM rm_loans
)
SELECT
    r.RM_ID,
    r.total_loan
FROM rm_loans r
CROSS JOIN avg_loan a
WHERE r.total_loan > a.avg_rm_loan;



-- Ques-14) Find RMs who have achieved more than 80% of their target.
WITH rm_target AS (
    SELECT
        RM_ID,
        SUM(Target) AS total_target,
        SUM(Achievement) AS total_achievement
    FROM Target
    GROUP BY RM_ID
)
SELECT
    RM_ID,
    total_target,
    total_achievement,
    ROUND(
        total_achievement * 100.0 / total_target,
        2
    ) AS achievement_percentage
FROM rm_target
WHERE total_achievement * 100.0 / total_target > 80;



-- Ques-15) Find branches whose total sales are greater than average branch sales.
WITH branch_sales AS (
    SELECT
        rm.Branch,
        SUM(s.Amount) AS total_sales
    FROM Sales s
    JOIN RM_Master rm
        ON s.RM_ID = rm.RM_ID
    GROUP BY rm.Branch
),
avg_branch_sales AS (
    SELECT AVG(total_sales) AS avg_sales
    FROM branch_sales
)
SELECT
    b.Branch,
    b.total_sales
FROM branch_sales b
CROSS JOIN avg_branch_sales a
WHERE b.total_sales > a.avg_sales;



-- Ques-16) Find the latest transaction of every customer.
SELECT
    Customer_ID,
    Sale_Date,
    Amount
FROM (
    SELECT
        Customer_ID,
        Sale_Date,
        Amount,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_ID
            ORDER BY Sale_Date DESC
        ) AS rn
    FROM Sales
) x
WHERE rn = 1;



-- Ques-17) Find the top 3 RMs in each branch.
SELECT *
FROM (
    SELECT
        rm.Branch,
        s.RM_ID,
        SUM(s.Amount) AS total_sales,
        RANK() OVER (
            PARTITION BY rm.Branch
            ORDER BY SUM(s.Amount) DESC
        ) AS rnk
    FROM Sales s
    JOIN RM_Master rm
        ON s.RM_ID = rm.RM_ID
    GROUP BY
        rm.Branch,
        s.RM_ID
) x
WHERE rnk <= 3;



-- Ques-18) Find the second-highest RM in each branch.
SELECT *
FROM (
    SELECT
        rm.Branch,
        s.RM_ID,
        SUM(s.Amount) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY rm.Branch
            ORDER BY SUM(s.Amount) DESC
        ) AS rnk
    FROM Sales s
    JOIN RM_Master rm
        ON s.RM_ID = rm.RM_ID
    GROUP BY
        rm.Branch,
        s.RM_ID
) x
WHERE rnk = 2;



-- Ques-19) Calculate the difference between current and previous sales.
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


--------------------------------------------------------------------- END ---------------------------------------------------------------------------------------
