WITH UserRedemptions_Completed AS (SELECT Month(redemptions.redemption_date) AS Month,
COUNT(Distinct redemptions.user_id) AS COUNT_UserRedemptions
FROM redemptions INNER JOIN Points
ON redemptions.user_id = Points.user_id
AND Month(redemptions.redemption_date) = Month(Points.earned_date)
WHERE redemptions.redemption_status = 'Completed'AND
points_redeemed > 0 AND
points_earned >0
GROUP BY Month(redemptions.redemption_date)
),

USERPoints_earned AS (SELECT Month(Points.earned_date) AS Month,
COUNT(DISTINCT Points.user_id) AS COUNT_UserPoints
FROM Points
WHERE points_earned > 0
GROUP BY Month(Points.earned_date)
),

RedemptionRate_MoMChange AS (SELECT UserRedemptions_Completed.Month,
COUNT_UserRedemptions,
COUNT_UserPoints,
(COUNT_UserRedemptions * 100.0) / NULLIF(COUNT_UserPoints,0) AS 'RedemptionRate_Current'
FROM UserRedemptions_Completed INNER JOIN USERPoints_earned
ON UserRedemptions_Completed.Month = USERPoints_earned.Month
)

SELECT RedemptionRate_MoMChange.Month,
COUNT_UserRedemptions,
COUNT_UserPoints,
ROUND(RedemptionRate_Current, 2) AS [Monthly Redemption Rate],
ROUND((RedemptionRate_Current - LAG(RedemptionRate_Current) OVER (ORDER BY Month)) * 100.0 / 
NULLIF(LAG(RedemptionRate_Current) OVER (ORDER BY Month),0),2) AS 'Redemption Rate MoM Change'
FROM RedemptionRate_MoMChange