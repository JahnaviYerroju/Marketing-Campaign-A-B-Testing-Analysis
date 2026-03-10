USE DATABASE USER$JAHNAVI2001 ;

CREATE TEMPORARY TABLE ab_test_results (
    user_id INT,
    variant STRING,
    event_time DATE,
    converted INT,
    revenue FLOAT
);

INSERT INTO ab_test_results VALUES
(1,'A','2024-01-01',0,0),
(2,'B','2024-01-01',1,120),
(3,'A','2024-01-02',0,0),
(4,'B','2024-01-02',1,150);

//Users per Variant
SELECT
variant,
COUNT(*) AS total_users
FROM ab_test_results
GROUP BY variant;

//Conversion Rate
SELECT
variant,
COUNT(*) AS users,
SUM(converted) AS conversions,
SUM(converted)*1.0/COUNT(*) AS conversion_rate
FROM ab_test_results
GROUP BY variant;

//Revenue per User
SELECT
variant,
SUM(revenue) AS total_revenue,
SUM(revenue)/COUNT(*) AS revenue_per_user
FROM ab_test_results
GROUP BY variant;

//Daily Conversion Trend
SELECT
event_time,
variant,
COUNT(*) users,
SUM(converted) conversions
FROM ab_test_results
GROUP BY event_time,variant
ORDER BY event_time;

//Conversion Lift
WITH rates AS (
SELECT
variant,
SUM(converted)*1.0/COUNT(*) AS conversion_rate
FROM ab_test_results
GROUP BY variant
)

SELECT
(b.conversion_rate - a.conversion_rate)/a.conversion_rate*100 AS lift_percent
FROM rates a
JOIN rates b
ON a.variant='A'
AND b.variant='B';
