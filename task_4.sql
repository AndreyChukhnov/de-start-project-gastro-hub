/*добавьте сюда запрос для решения задания 4*/
WITH pizzeria AS (
    SELECT 
        r.cafe_name,
        r.menu
    FROM cafe.restaurants r
    WHERE r.cafe_type = 'pizzeria'
),
pizza_count_by_pizzeria AS (
    SELECT 
        p.cafe_name,
        COUNT(*) AS pizza_count
    FROM pizzeria p,
    LATERAL jsonb_object_keys(p.menu->'Пицца') AS pizza_name
    GROUP BY p.cafe_name
),
ranked_pizzerias AS (
    SELECT *,
        DENSE_RANK() OVER (ORDER BY pizza_count DESC) AS rank
    FROM pizza_count_by_pizzeria
)
SELECT 
	cafe_name, 
	pizza_count
FROM ranked_pizzerias
WHERE rank = 1;