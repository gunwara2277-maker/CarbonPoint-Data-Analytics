With Attempt_Stages AS (
SELECT attempt_id,
Min(Case When event_name = 'Start Transaction' THEN event_timestamp END) AS "Start_Time",
Max(Case When event_name = 'Start Transaction' THEN 1 Else 0 END) AS "Started",
Max(Case When event_name = 'Scan QR' THEN 1 ELSE 0 END) AS "Scanned",
Max(Case When event_name = 'Verify Purchase' THEN 1 ELSE 0 END) AS "Verified",
Max(Case When event_name = 'Receive Points' THEN 1 ELSE 0 END) AS "Received"
FROM dbo.transaction_events
Group By attempt_id),

Quarterly_Funnel AS (
SELECT YEAR(Start_Time) AS "Year",
DATEPART(QUARTER, Start_Time) AS "QUARTER",
SUM(Started) AS "Start_Count",
SUM(Scanned) AS "Scan_Count",
SUM(Verified) AS "Verify_Count",
SUM(Received) AS "Receive_Count"
FROM Attempt_Stages
WHERE Start_Time IS NOT NULL
GROUP BY YEAR(Start_Time),
DATEPART(QUARTER, Start_Time)
)

Select YEAR, 
QUARTER,
Start_Count,
Scan_Count,
Verify_Count,
Receive_Count,
ROUND((Start_Count - Scan_Count) * 100.0 / NULLIF(Start_Count,0),2) AS Start_to_Scan_Dropoff,
ROUND((Scan_Count - Verify_Count) * 100.0 / NULLIF(Scan_Count,0),2) AS Scan_to_Verify_Dropoff,
ROUND((Verify_Count - Receive_Count) * 100.0 / NULLIF(Verify_Count,0),2) AS Verify_to_Receive_Dropoff
FROM Quarterly_Funnel
ORDER BY YEAR, 
QUARTER;