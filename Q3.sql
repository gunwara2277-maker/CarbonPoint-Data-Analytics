WITH TransactionsMORETHAN2 AS (SELECT Transactions.user_id
FROM Transactions
GROUP BY Transactions.user_id
HAVING COUNT(DISTINCT Transactions.transaction_id) >= 2
),

TransactionsMORETHAN1 AS (SELECT Transactions.user_id
FROM Transactions
GROUP BY Transactions.user_id
HAVING COUNT(DISTINCT Transactions.transaction_id) >= 1
)

SELECT 
(SELECT COUNT(*)  FROM TransactionsMORETHAN2) AS "จำนวนผู้ใช้ที่มี Transaction ≥ 2 ครั้ง",
(SELECT COUNT (*) FROM TransactionsMORETHAN1) AS "จำนวนผู้ใช้ที่มี Transaction อย่างน้อย 1 ครั้ง",
ROUND((SELECT COUNT(*)  FROM TransactionsMORETHAN2) * 100.0 / NULLIF((SELECT COUNT (*) FROM TransactionsMORETHAN1),0),2) AS Repeat_User_Rate
