WITH Count_Lowcarbon AS (SELECT Month(Transactions.transaction_date) AS Month, SUM(Transaction_Items.quantity) AS 'Low_Carbon_Quantity'
FROM Transaction_Items INNER JOIN Products
ON Transaction_Items.product_id = Products.product_id
INNER JOIN Transactions
ON Transactions.transaction_id = Transaction_Items.transaction_id
WHERE Products.carbon_classification = 'Low Carbon'
AND transaction_status = 'Completed'
GROUP BY Month(Transactions.transaction_date)
),

COUNT_Quantity AS (SELECT SUM(Transaction_Items.quantity) AS 'Total_Quantity',
Month(Transactions.transaction_date) AS 'Month'
FROM Transaction_Items INNER JOIN Transactions
ON Transactions.transaction_id = Transaction_Items.transaction_id
WHERE Transactions.transaction_status = 'Completed'
GROUP BY Month(Transactions.transaction_date)
),

Monthly_Share AS (SELECT COUNT_Quantity.Month,
Low_Carbon_Quantity,
Total_Quantity,
ROUND((Low_Carbon_Quantity * 100.0) / NULLIF(Total_Quantity,0),2) AS LowCarbon_PurchaseRate
FROM COUNT_Quantity LEFT JOIN Count_Lowcarbon
ON Count_Lowcarbon.Month = COUNT_Quantity.Month
)

SELECT Month,
Low_Carbon_Quantity,
Total_Quantity,
LowCarbon_PurchaseRate,
ROUND((LowCarbon_PurchaseRate - LAG(LowCarbon_PurchaseRate) OVER (ORDER BY Month)) * 100.0
/ NULLIF(LAG(LowCarbon_PurchaseRate) OVER (ORDER BY Month),0),2) AS MoM_Change_Percent
FROM Monthly_Share
ORDER BY Month;
