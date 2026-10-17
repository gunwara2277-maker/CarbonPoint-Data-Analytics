WITH USERRedemptions AS (SELECT DISTINCT redemptions.user_id
FROM redemptions INNER JOIN Points
ON redemptions.user_id = Points.user_id 
WHERE redemptions.redemption_status = 'Completed'
AND Points.points_earned >= 1
AND redemptions.redemption_date >= '2025-01-01'
AND redemptions.redemption_date < '2026-01-01'
AND Points.earned_date >= '2025-01-01'
AND Points.earned_date < '2026-01-01'
),

USERPOINT AS (SELECT DISTINCT Points.user_id
FROM Points
WHERE points_earned > 0
AND Points.earned_date >= '2025-01-01'
AND Points.earned_date < '2026-01-01'
)

SELECT COUNT(DISTINCT USERRedemptions.user_id) AS COUNT_USERRedemptions,
COUNT(DISTINCT USERPOINT.user_id) AS COUNT_USERPOINT,
ROUND(COUNT(DISTINCT USERRedemptions.user_id) * 100.0 / NULLIF(COUNT(DISTINCT USERPOINT.user_id),0),2) AS 'User Redemption Rate'
FROM USERPOINT LEFT JOIN USERRedemptions
ON USERPOINT.user_id = USERRedemptions.user_id;
