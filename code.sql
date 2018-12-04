/* Select all columns from the first 10 rows. */
SELECT *
FROM survey
LIMIT 10;

/* Create a quiz funnel using the GROUP BY command. */
SELECT question AS 'Style Quiz Question',
    COUNT(DISTINCT user_id) AS 'Number of Responses'
FROM survey
GROUP BY 1;

/* Examine the first five rows of each of our three data tables, 'quiz', 'home_try_on' and 'purchase'. */
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/* Create a new table with the specified layout. Use LEFT JOIN, starting with 'browse' and end with 'purchase'. Select only the first 10 rows of each table. */
SELECT DISTINCT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try_on',
    h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
    ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
    ON p.user_id = q.user_id
LIMIT 10;

/* Calculate overall conversion rates by aggregating across all rows. Compare conversion from 'quiz' to 'home_try_on' and 'home_try_on' to 'purchase'. */
WITH funnels AS (
    SELECT DISTINCT q.user_id,
        h.user_id IS NOT NULL AS 'is_home_try_on',
        h.number_of_pairs,
        p.user_id IS NOT NULL AS 'is_purchase'
    FROM quiz AS 'q'
    LEFT JOIN home_try_on AS 'h'
        ON q.user_id = h.user_id
    LEFT JOIN purchase AS 'p'
        ON p.user_id = q.user_id)
SELECT COUNT(*) AS 'num_quiz',
    SUM(is_home_try_on) AS 'num_home_try_on',
    SUM(is_purchase) AS 'num_purchased',
    1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'quiz_to_try',
    1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try_to_buy'
FROM funnels;

/* Calculate the difference in purchase rates between 3 and 5 for 'number_of_pairs'. This is A/B Testing. */
WITH funnels AS (
    SELECT DISTINCT q.user_id,
        h.user_id IS NOT NULL AS 'is_home_try_on',
        h.number_of_pairs,
        p.user_id IS NOT NULL AS 'is_purchase'
    FROM quiz AS 'q'
    LEFT JOIN home_try_on AS 'h'
        ON q.user_id = h.user_id
    LEFT JOIN purchase AS 'p'
        ON p.user_id = q.user_id)
SELECT number_of_pairs,
    COUNT(*) AS 'num_quiz',
    SUM(is_home_try_on) AS 'num_try_on',
    SUM(is_purchase) AS 'num_purchased',
    1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'try_to_buy'
FROM funnels
WHERE number_of_pairs IS NOT NULL
GROUP BY 1;

/* The most common results of the style quiz. */
SELECT STYLE AS 'Style Preference Selection',
    COUNT(STYLE) 'Number of Selections'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT fit AS 'Fit Preference Selection',
    COUNT(fit) 'Number of Selections'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT shape AS 'Shape Preference Selection',
    COUNT(shape) 'Number of Selections'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT color AS 'Color Preference Selection',
    COUNT(color) 'Number of Selections'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

/* How many of each color is sold? */
SELECT color AS 'Color',
    COUNT(color) 'Units Sold'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

/* How many of each model is sold? */
SELECT model_name AS 'Model Name',
    COUNT(model_name) AS 'Units Sold'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

/* How many of each price group is sold? */
SELECT price AS 'Product Price ($)',
    COUNT(price) AS 'Units Sold'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

/* Total units sold and for how much total gross sales? */
SELECT COUNT(*) AS 'Total Units Sold',
    SUM(price) AS 'Total Gross Sales ($)'
FROM purchase;
