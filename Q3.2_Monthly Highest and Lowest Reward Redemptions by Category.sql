WITH Monthly_Redemptions AS (SELECT Month(redemptions.redemption_date) AS Month,
rewards.reward_category AS reward_category, 
COUNT(redemptions.redemption_id) AS Count_Redemptions
FROM rewards INNER JOIN redemptions
ON rewards.reward_id = redemptions.reward_id
WHERE redemption_status = 'Completed'
AND redemptions.points_redeemed > 0
GROUP BY Month(redemptions.redemption_date),
rewards.reward_category
),

Ranked_Redemptions AS (SELECT Month,
reward_category,
Count_Redemptions,
DENSE_RANK() OVER(PARTITION BY Month ORDER BY Count_Redemptions DESC) AS Rank_Highest,
DENSE_RANK() OVER(PARTITION BY Month ORDER BY Count_Redemptions ASC) AS Rank_Lowest
FROM Monthly_Redemptions
)

SELECT Month,
reward_category,
Count_Redemptions,
CASE 
WHEN Rank_Highest = 1 THEN 'Highest'
WHEN Rank_Lowest = 1 THEN 'Lowest'
END AS Carbon_Rank
FROM Ranked_Redemptions
WHERE Rank_Highest = 1 OR
Rank_Lowest = 1
