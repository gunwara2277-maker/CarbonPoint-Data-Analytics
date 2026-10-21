WITH Quantity_HighCarbon AS (SELECT Transactions.user_id AS USER_ID,
SUM(Transaction_Items.quantity) AS 'SUMQuantity_HighCarbon'
FROM Transaction_Items INNER JOIN Products
ON Transaction_Items.product_id = Products.product_id
INNER JOIN Transactions
ON Transactions.transaction_id = Transaction_Items.transaction_id
WHERE carbon_classification = 'High Carbon'
AND transaction_status = 'Completed'
GROUP BY Transactions.user_id
),

Total_Quantity AS (SELECT Transactions.user_id AS USER_ID,
SUM(Transaction_Items.quantity) AS TotalQuantity
FROM Transactions INNER JOIN Transaction_Items
ON Transactions.transaction_id = Transaction_Items.transaction_id
WHERE Transactions.transaction_status = 'Completed'
GROUP BY Transactions.user_id
),

Earning_Count AS (SELECT Points.user_id,
COUNT(Points.user_id) AS 'EarnCount'
FROM Points
WHERE points_earned > 0
GROUP BY Points.user_id
),

Redeeming AS (SELECT users.user_id,
COUNT(redemptions.user_id) AS 'Redemption_Count'
FROM users LEFT JOIN redemptions
ON users.user_id = redemptions.user_id
AND redemptions.redemption_status = 'Completed'
AND redemptions.points_redeemed > 0
GROUP BY users.user_id
),

Reward_Engagement_Data AS (SELECT Redeeming.user_id AS USER_ID,
Earning_Count.EarnCount,
Redeeming.Redemption_Count,
CASE
WHEN Earning_Count.EarnCount > 15
OR Redeeming.Redemption_Count >= 3
THEN 'High Engagement'
WHEN Earning_Count.EarnCount BETWEEN 6 AND 15
OR Redeeming.Redemption_Count BETWEEN 1 AND 2
THEN 'Medium Engagement'
WHEN Earning_Count.EarnCount BETWEEN 1 AND 5
OR Redeeming.Redemption_Count = 0 
THEN 'Low Engagement'
END AS Reward_Engagement
FROM Earning_Count INNER JOIN Redeeming
ON Earning_Count.user_id = Redeeming.user_id
)

SELECT Reward_Engagement_Data.Reward_Engagement,
SUM(Total_Quantity.TotalQuantity) AS TotalQuantity,
SUM(COALESCE (Quantity_HighCarbon.SUMQuantity_HighCarbon,0)) AS HighCarbonQuantity,
ROUND(SUM(COALESCE (Quantity_HighCarbon.SUMQuantity_HighCarbon,0)) * 100.0 / 
NULLIF(SUM(Total_Quantity.TotalQuantity),0),2) AS 'High-Carbon Purchase Rate'
FROM Reward_Engagement_Data INNER JOIN Total_Quantity
ON Reward_Engagement_Data.USER_ID = Total_Quantity.USER_ID
LEFT JOIN Quantity_HighCarbon
ON Total_Quantity.USER_ID = Quantity_HighCarbon.USER_ID
GROUP BY Reward_Engagement_Data.Reward_Engagement
