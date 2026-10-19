SELECT merchants.merchant_type,
ROUND(SUM((Products.baseline_carbon_footprint - Products.product_carbon_footprint) * Transaction_Items.quantity),2) AS 'Estimated Carbon Reduction'
FROM merchants INNER JOIN Transactions
ON merchants.merchant_id = Transactions.merchant_id
INNER JOIN Transaction_Items
ON Transactions.transaction_id = Transaction_Items.transaction_id
INNER JOIN Products
ON Products.product_id = Transaction_Items.product_id
WHERE Transactions.transaction_status = 'Completed'
AND Products.carbon_classification = 'Low Carbon'
AND merchants.merchant_type <> 'Unknown'
GROUP BY merchants.merchant_type
ORDER BY SUM((Products.baseline_carbon_footprint - Products.product_carbon_footprint) * Transaction_Items.quantity) DESC