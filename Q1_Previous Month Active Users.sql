-- Q1.2 Previous Month Active Users
With Monthly_Users AS (
Select YEAR(transaction_date) AS "Year",
Month(transaction_date) AS "Month",
Count(Distinct user_id) AS "ACTIVE_USER"
From dbo.Transactions
Group By YEAR(dbo.Transactions.transaction_date),
MONTH(dbo.Transactions.transaction_date)
),

User_Comparison AS (Select Year,
Month,
ACTIVE_USER,
LAG(ACTIVE_USER)OVER(ORDER BY Year,Month) AS Previous_Month_Users
From Monthly_Users)

Select Year,
Month,
ACTIVE_USER,
Previous_Month_Users,
ROUND(
(ACTIVE_USER - Previous_Month_Users)*100.0
/nullif(Previous_Month_Users,0),
2
) AS MoM_Percent
From User_Comparison
ORDER BY Year,
Month;
