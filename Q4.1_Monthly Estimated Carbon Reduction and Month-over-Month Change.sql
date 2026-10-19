WITH Monthly_Reduction AS (SELECT 
Month(Transactions.transaction_date) AS Month,
SUM((Products.baseline_carbon_footprint - Products.product_carbon_footprint) * Transaction_Items.quantity) AS Carbon_Reduction
FROM Transactions INNER JOIN Transaction_Items
ON Transactions.transaction_id = Transaction_Items.transaction_id
INNER JOIN Products
ON Products.product_id = Transaction_Items.product_id
WHERE Transactions.transaction_status = 'Completed'
AND Products.carbon_classification = 'Low Carbon'
GROUP BY
Month(Transactions.transaction_date)
)

SELECT Monthly_Reduction.Month,
ROUND(Monthly_Reduction.Carbon_Reduction,2) AS Carbon_Reduction,
ROUND((Carbon_Reduction - LAG(Monthly_Reduction.Carbon_Reduction) OVER (ORDER BY Month)) * 100.0 / 
NULLIF(LAG(Monthly_Reduction.Carbon_Reduction) OVER (ORDER BY Month),0),2) AS MoM_Change_Percent
FROM Monthly_Reduction
ORDER BY Month