/*добавьте сюда запрос для решения задания 2*/
CREATE MATERIALIZED VIEW avg_check_by_year AS 
WITH yearly_avg AS (
    SELECT
        EXTRACT(YEAR FROM date) AS year,
        r.cafe_name,
        r.cafe_type,
        ROUND(AVG(avg_check), 2) AS avg_check_this_year
    FROM cafe.sales s 
    LEFT JOIN cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
    GROUP BY year, r.cafe_name, r.cafe_type
)
SELECT
    year, 
    cafe_name, 
    cafe_type, 
    avg_check_this_year, 
    LAG(avg_check_this_year) OVER (PARTITION BY cafe_type, cafe_name ORDER BY year) AS avg_check_previous_year,
    ROUND((avg_check_this_year / NULLIF(LAG(avg_check_this_year) OVER (PARTITION BY cafe_type, cafe_name ORDER BY year), 0) - 1) * 100, 2) AS percent_change
FROM yearly_avg
WHERE year != EXTRACT(YEAR FROM CURRENT_DATE);