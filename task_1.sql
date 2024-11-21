/*Создание представления для расчета премии иенеджерам состоящих из топ 3 заведений каждого типа*/
CREATE VIEW cafe.max_avg_check AS 
WITH max_avg_check AS (
    SELECT 
        r.cafe_name,
        r.cafe_type,
        MAX(s.avg_check) AS max_avg_check
    FROM cafe.sales s
    LEFT JOIN cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
    GROUP BY r.cafe_name, r.cafe_type 
),
check_rank AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY cafe_type ORDER BY max_avg_check DESC) AS check_rank
    FROM max_avg_check
)
SELECT 
	cafe_name, 
	cafe_type, 
	max_avg_check
FROM check_rank
WHERE check_rank < 4;
