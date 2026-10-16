WITH Monthly_Category AS (SELECT MONTH(Transactions.transaction_date) AS Month,
Products.product_category,
SUM(Transaction_Items.quantity) AS Total_Quantity
FROM Products INNER JOIN Transaction_Items
ON Products.product_id = Transaction_Items.product_id
INNER JOIN Transactions
ON Transactions.transaction_id = Transaction_Items.transaction_id
WHERE Products.carbon_classification = 'Low Carbon'
GROUP BY MONTH(Transactions.transaction_date),
Products.product_category
),

Category_Ranking AS (SELECT Month,
product_category,
Total_Quantity,
DENSE_RANK()OVER(PARTITION BY Month ORDER BY Total_Quantity DESC) AS Highest_Rank,
DENSE_RANK()OVER(PARTITION BY Month ORDER BY Total_Quantity ASC) AS Lowest_Rank
FROM Monthly_Category
)

SELECT Month,
product_category,
Total_Quantity,
CASE WHEN Highest_Rank = 1 THEN 'Highest'
WHEN Lowest_Rank = 1 THEN 'Lowest'
END AS Purchase_Rank
FROM Category_Ranking
WHERE Highest_Rank = 1 OR Lowest_Rank = 1
ORDER BY Month, Highest_Rank;