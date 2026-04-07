
-- =====================================================
-- 🚗 New Wheels Sales & Customer Analytics (SQL Analysis)
-- =====================================================

-- Objective:
-- Analyze customer behavior, sales performance, and feedback trends
-- to identify key business insights and support decision-making.

--------------------------------------------------------
-- Q1: Customer Distribution by State
--------------------------------------------------------
-- Identify total customers and how they are distributed geographically

SELECT state, COUNT(DISTINCT customer_id) AS total_customers
FROM online_customer
GROUP BY state
ORDER BY total_customers DESC;


--------------------------------------------------------
-- Q2: Top 5 Vehicle Makers Preferred by Customers
--------------------------------------------------------
-- Find most popular vehicle makers based on number of orders

SELECT vehicle_maker, COUNT(*) AS total_orders
FROM order_t
GROUP BY vehicle_maker
ORDER BY total_orders DESC
LIMIT 5;


--------------------------------------------------------
-- Q3: Most Preferred Vehicle Maker per State
--------------------------------------------------------
-- Identify top vehicle maker in each state

SELECT state, vehicle_maker, COUNT(*) AS total_orders
FROM order_t o
JOIN online_customer c ON o.customer_id = c.customer_id
GROUP BY state, vehicle_maker
ORDER BY state, total_orders DESC;


--------------------------------------------------------
-- Q4: Average Customer Rating Overall and by Quarter
--------------------------------------------------------
-- Convert feedback into numeric scale:
-- Very Bad = 1, Bad = 2, Okay = 3, Good = 4, Very Good = 5

SELECT 
    quarter,
    AVG(
        CASE feedback
            WHEN 'Very Bad' THEN 1
            WHEN 'Bad' THEN 2
            WHEN 'Okay' THEN 3
            WHEN 'Good' THEN 4
            WHEN 'Very Good' THEN 5
        END
    ) AS avg_rating
FROM feedback_table
GROUP BY quarter
ORDER BY quarter;


--------------------------------------------------------
-- Q5: Feedback Distribution
--------------------------------------------------------
-- Understand customer satisfaction trends

SELECT feedback, COUNT(*) AS total_count
FROM feedback_table
GROUP BY feedback
ORDER BY total_count DESC;


--------------------------------------------------------
-- Q6: Number of Orders by Quarter
--------------------------------------------------------
-- Analyze order trend over time

SELECT quarter, COUNT(order_id) AS total_orders
FROM order_t
GROUP BY quarter
ORDER BY quarter;


--------------------------------------------------------
-- Q7: Total Revenue and Quarter-over-Quarter Change
--------------------------------------------------------
-- Calculate revenue and growth trend

SELECT 
    quarter,
    SUM(order_amount) AS total_revenue,
    LAG(SUM(order_amount)) OVER (ORDER BY quarter) AS prev_revenue,
    (SUM(order_amount) - LAG(SUM(order_amount)) OVER (ORDER BY quarter)) 
        / LAG(SUM(order_amount)) OVER (ORDER BY quarter) * 100 AS revenue_growth_pct
FROM order_t
GROUP BY quarter
ORDER BY quarter;


--------------------------------------------------------
-- Q8: Revenue vs Orders Trend
--------------------------------------------------------
-- Compare revenue and order volume

SELECT 
    quarter,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_revenue
FROM order_t
GROUP BY quarter
ORDER BY quarter;


--------------------------------------------------------
-- Q9: Average Discount by Payment Type
--------------------------------------------------------
-- Analyze discount patterns

SELECT payment_type, AVG(discount) AS avg_discount
FROM order_t
GROUP BY payment_type
ORDER BY avg_discount DESC;


--------------------------------------------------------
-- Q10: Average Shipping Time by Quarter
--------------------------------------------------------
-- Evaluate logistics performance

SELECT 
    quarter,
    AVG(DATEDIFF(ship_date, order_date)) AS avg_shipping_days
FROM order_t
GROUP BY quarter
ORDER BY quarter;
