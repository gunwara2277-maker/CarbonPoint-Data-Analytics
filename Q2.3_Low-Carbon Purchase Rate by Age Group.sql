WITH AGE_LowCarbon AS (SELECT users.age_group AS AGE,
SUM(Transaction_Items.quantity) AS Quantity_Lowcarbon
FROM Transaction_Items INNER JOIN Transactions
ON Transaction_Items.transaction_id = Transactions.transaction_id
INNER JOIN users
ON users.user_id = Transactions.user_id
INNER JOIN Products
ON Products.product_id = Transaction_Items.product_id
WHERE carbon_classification = 'Low Carbon' AND Transactions.transaction_status = 'Completed'
GROUP BY users.age_group
),

AGE_Total AS (SELECT users.age_group AS AGE,
SUM(Transaction_Items.quantity) AS Total_Quantity
FROM Transaction_Items INNER JOIN Transactions
ON Transaction_Items.transaction_id = Transactions.transaction_id
INNER JOIN users
ON users.user_id = Transactions.user_id
INNER JOIN Products
ON Products.product_id = Transaction_Items.product_id
WHERE Transactions.transaction_status = 'Completed'
GROUP BY users.age_group
)

SELECT AGE_Total.AGE,
AGE_LowCarbon.Quantity_Lowcarbon,
AGE_Total.Total_Quantity,
ROUND((Quantity_Lowcarbon * 100.0) / NULLIF(Total_Quantity,0),2) AS 'Low-Carbon Purchase Rate by Age Group'
FROM AGE_LowCarbon INNER JOIN AGE_Total
ON AGE_LowCarbon.AGE = AGE_Total.AGE
ORDER BY AGE_Total.AGE

