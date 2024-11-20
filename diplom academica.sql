CREATE DATABASE transactions_db;
USE transactions_db;

SELECT ID_client
FROM (
    SELECT ID_client, 
           COUNT(DISTINCT DATE_FORMAT(date_new, '%Y-%m')) AS month_count
    FROM transactions_info
    WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY ID_client
) AS client_activity
WHERE month_count = 12;


SELECT ID_client,
    AVG(Sum_payment) AS avg_check,
    SUM(Sum_payment) / 12 AS avg_monthly_sum,
    COUNT(*) AS total_operations
FROM transactions_info
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY ID_client;


SELECT DATE_FORMAT(date_new, '%Y-%m') AS month,
    AVG(Sum_payment) AS avg_monthly_check
FROM transactions_info
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month;


SELECT DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(*) AS total_operations,
    COUNT(*) / COUNT(DISTINCT ID_client) AS avg_operations_per_client
FROM transactions_info
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month;


SELECT DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(DISTINCT ID_client) AS avg_clients_per_month
FROM transactions_info
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month;


SELECT DATE_FORMAT(date_new, '%Y-%m') AS month,
COUNT(*) / (SELECT COUNT(*) FROM transactions WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01') AS share_operations,
SUM(Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01') AS share_sum
FROM transactions_info
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month;



SELECT DATE_FORMAT(t.date_new, '%Y-%m') AS month, c.Gender,
COUNT(*) AS operation_count,
SUM(t.Sum_payment) AS total_spent,
COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions_info WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01') AS operation_percentage,
SUM(t.Sum_payment) * 100.0 / (SELECT SUM(Sum_payment) FROM transactions_info WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01') AS spending_percentage
FROM transactions_info t
JOIN customer_info c ON t.ID_client = c.Id_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month, c.Gender;


SELECT 
    CASE
        WHEN Age IS NULL THEN 'No Data'
        WHEN Age < 20 THEN '<20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS operation_count,
    SUM(t.Sum_payment) AS total_spent
FROM transactions_info t
JOIN customers_info c ON t.ID_client = c.Id_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY age_group;



SELECT 
    CASE
        WHEN Age IS NULL THEN 'No Data'
        WHEN Age < 20 THEN '<20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    CONCAT(YEAR(date_new), ' Q', QUARTER(date_new)) AS quarter,
    COUNT(*) AS operation_count,
    SUM(t.Sum_payment) AS total_spent,
    AVG(t.Sum_payment) AS avg_spent,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions_info WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01') AS operation_percentage
FROM transactions_info t
JOIN customer_info c ON t.ID_client = c.Id_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY age_group, quarter;

