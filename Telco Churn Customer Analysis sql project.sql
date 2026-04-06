-- ================================================================
-- TELCO CUSTOMER CHURN ANALYSIS
-- Dataset: Telco Customer Churn Dataset
-- Description: End-to-end SQL analysis to identify churn patterns,
--              high-risk customers and business insights
-- ================================================================

CREATE DATABASE IF NOT EXISTS Customer_Churn_Analysis;
USE Customer_Churn_Analysis;

-- ================================================================
-- TABLE CREATION
-- ================================================================



CREATE TABLE telco_churn (
    customerID       VARCHAR(50)    PRIMARY KEY,
    gender           VARCHAR(10),
    SeniorCitizen    INT,
    Partner          VARCHAR(10),
    Dependents       VARCHAR(10),
    tenure           INT,
    PhoneService     VARCHAR(10),
    MultipleLines    VARCHAR(20),
    InternetService  VARCHAR(20),
    OnlineSecurity   VARCHAR(20),
    OnlineBackup     VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport      VARCHAR(20),
    StreamingTV      VARCHAR(20),
    StreamingMovies  VARCHAR(20),
    Contract         VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod    VARCHAR(50),
    MonthlyCharges   DECIMAL(10,2),
    TotalCharges     VARCHAR(50),   -- Keep VARCHAR
    Churn            VARCHAR(10)
);


-- ================================================================
-- SECTION 1: KEY PERFORMANCE INDICATORS (KPIs)
-- ================================================================

-- Q1: Total Customers
SELECT COUNT(*) AS total_customers
FROM telco_churn;


SELECT
    ROUND(AVG(CAST(
        NULLIF(TotalCharges, '') AS DECIMAL(10,2)
    )), 2) AS avg_customer_lifetime_value
FROM telco_churn
WHERE TotalCharges != '';



-- Q2: Total Churned Customers
SELECT COUNT(*) AS churn_customers
FROM telco_churn
WHERE Churn = 'Yes';


-- Q3: Total Retained Customers
SELECT COUNT(*) AS retained_customers
FROM telco_churn
WHERE Churn = 'No';


-- Q4: Churn Rate (%)
SELECT
    CONCAT(
        ROUND(
            COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100.0 / COUNT(*),
            2
        ),
        '%'
    ) AS churn_rate
FROM telco_churn;


-- Q5: Retention Rate (%)
SELECT
    CONCAT(
        ROUND(
            COUNT(CASE WHEN Churn = 'No' THEN 1 END) * 100.0 / COUNT(*),
            2
        ),
        '%'
    ) AS retention_rate
FROM telco_churn;


-- Q6: Average Monthly Charges
SELECT
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM telco_churn;

-- Q7: Average Tenure (in months)
SELECT
    ROUND(AVG(tenure), 1) AS avg_tenure_months
FROM telco_churn;


-- Q8: Average Customer Lifetime Value (CLV)
SELECT
    ROUND(AVG(TotalCharges), 2) AS avg_customer_lifetime_value
FROM telco_churn
WHERE TotalCharges IS NOT NULL;

-- ================================================================
-- SECTION 2: CHURN ANALYSIS BY DEMOGRAPHICS
-- ================================================================


-- Q9: Churn by Gender
SELECT
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY gender;


-- Q10: Churn by Senior Citizen
SELECT
    CASE WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
         ELSE 'Non-Senior Citizen' END AS customer_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY SeniorCitizen;


-- Q11: Churn by Partner Status
SELECT
    Partner,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY Partner;


-- ================================================================
-- SECTION 3: CHURN ANALYSIS BY SERVICES
-- ================================================================


-- Q12: Churn by Contract Type
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY Contract
ORDER BY churn_customers DESC;


-- Q13: Churn by Payment Method
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY PaymentMethod
ORDER BY churn_customers DESC;


-- Q14: Churn by Internet Service
SELECT
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY InternetService
ORDER BY churn_customers DESC;


-- Q15: Churn by Tech Support
SELECT
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY TechSupport;


-- ================================================================
-- SECTION 4: HIGH RISK CUSTOMER ANALYSIS
-- ================================================================


-- Q16: High Risk Customers Count
-- (tenure < 12 months AND MonthlyCharges > 70 AND Churned)
SELECT
    COUNT(*) AS high_risk_customers
FROM telco_churn
WHERE tenure < 12
  AND MonthlyCharges > 70
  AND Churn = 'Yes';


-- Q17: High Risk Customer Details
SELECT
    customerID,
    gender,
    tenure,
    MonthlyCharges,
    Contract,
    PaymentMethod,
    Churn
FROM telco_churn
WHERE tenure < 12
  AND MonthlyCharges > 70
  AND Churn = 'Yes'
ORDER BY MonthlyCharges DESC
LIMIT 10;


-- Q18: Revenue Lost Due to Churn
SELECT
    CONCAT('$', ROUND(SUM(MonthlyCharges), 2)) AS monthly_revenue_lost
FROM telco_churn
WHERE Churn = 'Yes';


-- ================================================================
-- SECTION 5: TENURE BASED ANALYSIS
-- ================================================================


-- Q19: Churn by Tenure Group
SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12  THEN '0-12 Months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60 Months'
        ELSE '60+ Months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
FROM telco_churn
GROUP BY tenure_group
ORDER BY churn_customers DESC;


-- ================================================================
-- SECTION 6: ADVANCED ANALYSIS USING WINDOW FUNCTIONS
-- ================================================================


-- Q20: Rank Payment Methods by Churn Count
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    RANK() OVER (ORDER BY SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) DESC) AS churn_rank
FROM telco_churn
GROUP BY PaymentMethod;


-- Q21: Running Total of Churned Customers by Tenure
SELECT
    tenure,
    COUNT(*) AS churned_customers,
    SUM(COUNT(*)) OVER (ORDER BY tenure) AS running_total_churned
FROM telco_churn
WHERE Churn = 'Yes'
GROUP BY tenure
ORDER BY tenure;


-- ================================================================
-- SECTION 7: STORED PROCEDURE
-- ================================================================


-- Q22: Stored Procedure — Get Churn Summary by Contract Type
DELIMITER //
CREATE PROCEDURE GetChurnByContract(IN contract_type VARCHAR(30))
BEGIN
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
        CONCAT(ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2), '%') AS churn_rate
    FROM telco_churn
    WHERE Contract = contract_type
    GROUP BY Contract;
END //
DELIMITER ;

-- Call Stored Procedure
CALL GetChurnByContract('Month-to-month');


-- ================================================================
-- SECTION 8: VIEW CREATION
-- ================================================================


-- Q23: Create View for High Risk Customers
CREATE VIEW vw_high_risk_customers AS
SELECT
    customerID,
    gender,
    SeniorCitizen,
    tenure,
    Contract,
    MonthlyCharges,
    PaymentMethod,
    Churn
FROM telco_churn
WHERE tenure < 12
  AND MonthlyCharges > 70;

-- Query the View
SELECT * FROM vw_high_risk_customers;


-- ================================================================
-- END OF ANALYSIS
-- ================================================================