-- Q1.1 Monthly Active Users: Highest and Lowest Months
Select YEAR(transaction_date) AS "YEAR",
Month(transaction_date) AS "Month",
COUNT(distinct USER_ID)AS "Active_Users"
From dbo.Transactions
Group BY YEAR(transaction_date),
Month(transaction_date);