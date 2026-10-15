
USE CarbonPointDB;
GO

/* =====================================================
   CARBON POINT PROJECT
   DATA VALIDATION USING SQL SERVER
   ===================================================== */


/* =====================================================
   STEP 1: ROW COUNT VALIDATION
   ตรวจสอบจำนวนแถวทั้ง 9 ตาราง
   ===================================================== */

SELECT 'Users' AS Table_Name, COUNT(*) AS Total_Rows
FROM dbo.users

UNION ALL
SELECT 'Merchants', COUNT(*)
FROM dbo.merchants

UNION ALL
SELECT 'Products', COUNT(*)
FROM dbo.Products

UNION ALL
SELECT 'Transactions', COUNT(*)
FROM dbo.Transactions

UNION ALL
SELECT 'Transaction_Items', COUNT(*)
FROM dbo.Transaction_Items

UNION ALL
SELECT 'Points', COUNT(*)
FROM dbo.Points

UNION ALL
SELECT 'Rewards', COUNT(*)
FROM dbo.rewards

UNION ALL
SELECT 'Redemptions', COUNT(*)
FROM dbo.redemptions

UNION ALL
SELECT 'Transaction_Events', COUNT(*)
FROM dbo.transaction_events;
GO


/* =====================================================
   STEP 2: PRIMARY KEY DUPLICATE VALIDATION
   ตรวจสอบ ID ซ้ำทั้ง 9 ตาราง
   ผลลัพธ์ที่ต้องการ: Duplicate_Groups = 0
   ===================================================== */

SELECT 'Users' AS Table_Name, COUNT(*) AS Duplicate_Groups
FROM (
    SELECT user_id
    FROM dbo.users
    GROUP BY user_id
    HAVING COUNT(*) > 1
) AS a

UNION ALL
SELECT 'Merchants', COUNT(*)
FROM (
    SELECT merchant_id
    FROM dbo.merchants
    GROUP BY merchant_id
    HAVING COUNT(*) > 1
) AS b

UNION ALL
SELECT 'Products', COUNT(*)
FROM (
    SELECT product_id
    FROM dbo.Products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) AS c

UNION ALL
SELECT 'Transactions', COUNT(*)
FROM (
    SELECT transaction_id
    FROM dbo.Transactions
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
) AS d

UNION ALL
SELECT 'Transaction_Items', COUNT(*)
FROM (
    SELECT transaction_item_id
    FROM dbo.Transaction_Items
    GROUP BY transaction_item_id
    HAVING COUNT(*) > 1
) AS e

UNION ALL
SELECT 'Points', COUNT(*)
FROM (
    SELECT point_transaction_id
    FROM dbo.Points
    GROUP BY point_transaction_id
    HAVING COUNT(*) > 1
) AS f

UNION ALL
SELECT 'Rewards', COUNT(*)
FROM (
    SELECT reward_id
    FROM dbo.rewards
    GROUP BY reward_id
    HAVING COUNT(*) > 1
) AS g

UNION ALL
SELECT 'Redemptions', COUNT(*)
FROM (
    SELECT redemption_id
    FROM dbo.redemptions
    GROUP BY redemption_id
    HAVING COUNT(*) > 1
) AS h

UNION ALL
SELECT 'Transaction_Events', COUNT(*)
FROM (
    SELECT event_id
    FROM dbo.transaction_events
    GROUP BY event_id
    HAVING COUNT(*) > 1
) AS i;
GO


/* =====================================================
   STEP 3: FOREIGN KEY VALIDATION
   ตรวจสอบความสัมพันธ์ระหว่างตาราง
   ผลลัพธ์ที่ต้องการ: Invalid_Count = 0
   ===================================================== */

-- 3.1 Transactions -> Users
SELECT COUNT(*) AS Invalid_User_ID
FROM dbo.Transactions AS t
LEFT JOIN dbo.users AS u
    ON t.user_id = u.user_id
WHERE u.user_id IS NULL;
GO

-- 3.2 Transactions -> Merchants
SELECT COUNT(*) AS Invalid_Merchant_ID
FROM dbo.Transactions AS t
LEFT JOIN dbo.merchants AS m
    ON t.merchant_id = m.merchant_id
WHERE m.merchant_id IS NULL;
GO

-- 3.3 Transaction_Items -> Transactions
SELECT COUNT(*) AS Invalid_Transaction_ID
FROM dbo.Transaction_Items AS ti
LEFT JOIN dbo.Transactions AS t
    ON ti.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;
GO

-- 3.4 Transaction_Items -> Products
SELECT COUNT(*) AS Invalid_Product_ID
FROM dbo.Transaction_Items AS ti
LEFT JOIN dbo.Products AS p
    ON ti.product_id = p.product_id
WHERE p.product_id IS NULL;
GO

-- 3.5 Points -> Users
SELECT COUNT(*) AS Invalid_User_ID
FROM dbo.Points AS p
LEFT JOIN dbo.users AS u
    ON p.user_id = u.user_id
WHERE u.user_id IS NULL;
GO

-- 3.6 Points -> Transactions
SELECT COUNT(*) AS Invalid_Transaction_ID
FROM dbo.Points AS p
LEFT JOIN dbo.Transactions AS t
    ON p.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;
GO

-- 3.7 Redemptions -> Users
SELECT COUNT(*) AS Invalid_User_ID
FROM dbo.redemptions AS r
LEFT JOIN dbo.users AS u
    ON r.user_id = u.user_id
WHERE u.user_id IS NULL;
GO

-- 3.8 Redemptions -> Rewards
SELECT COUNT(*) AS Invalid_Reward_ID
FROM dbo.redemptions AS r
LEFT JOIN dbo.rewards AS rw
    ON r.reward_id = rw.reward_id
WHERE rw.reward_id IS NULL;
GO

-- 3.9 Transaction_Events -> Users
SELECT COUNT(*) AS Invalid_User_ID
FROM dbo.transaction_events AS e
LEFT JOIN dbo.users AS u
    ON e.user_id = u.user_id
WHERE u.user_id IS NULL;
GO

-- 3.10 Transaction_Events -> Transactions
SELECT COUNT(*) AS Invalid_Transaction_ID
FROM dbo.transaction_events AS e
LEFT JOIN dbo.Transactions AS t
    ON e.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;
GO


/* =====================================================
   STEP 4: CROSS-TABLE CONSISTENCY VALIDATION
   ตรวจสอบว่า user_id ตรงกับเจ้าของ Transaction
   ผลลัพธ์ที่ต้องการ: Mismatched_User_ID = 0
   ===================================================== */

-- 4.1 Points vs Transactions
SELECT COUNT(*) AS Mismatched_User_ID
FROM dbo.Points AS p
INNER JOIN dbo.Transactions AS t
    ON p.transaction_id = t.transaction_id
WHERE p.user_id <> t.user_id;
GO

-- 4.2 Transaction_Events vs Transactions
SELECT COUNT(*) AS Mismatched_User_ID
FROM dbo.transaction_events AS e
INNER JOIN dbo.Transactions AS t
    ON e.transaction_id = t.transaction_id
WHERE e.user_id <> t.user_id;
GO
