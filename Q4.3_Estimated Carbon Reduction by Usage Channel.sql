SELECT Transactions.usage_channel,
SUM((Products.baseline_carbon_footprint - Products.product_carbon_footprint) * Transaction_Items.quantity) AS 'Estimated Carbon Reduction'
FROM Transactions INNER JOIN Transaction_Items
ON Transactions.transaction_id = Transaction_Items.transaction_id
INNER JOIN Products
ON Products.product_id = Transaction_Items.product_id
WHERE carbon_classification = 'Low Carbon'
AND transaction_status = 'Completed'
GROUP BY Transactions.usage_channel