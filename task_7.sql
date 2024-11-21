/*Транзакция на изменение номеров телефонов у менеджеров*/
BEGIN;  -- Начинаем транзакцию

-- Блокируем таблицу для записи, чтобы она была недоступна для изменений,
-- но доступна для чтения (блокировка уровня ACCESS EXCLUSIVE).
LOCK TABLE cafe.managers IN ACCESS EXCLUSIVE MODE;

-- Добавляем новое поле для хранения массива номеров телефонов
ALTER TABLE cafe.managers
ADD COLUMN manager_phone_array jsonb;

-- Обновляем новое поле с новым и старым номером, используя подзапрос
WITH ranked_managers AS (
    SELECT manager, manager_phone,
           ROW_NUMBER() OVER (ORDER BY manager) + 99 AS new_phone
    FROM cafe.managers
)
UPDATE cafe.managers
SET manager_phone_array = jsonb_build_array(
    CONCAT('8-800-2500-', LPAD(CAST(rm.new_phone AS TEXT), 3, '0')),  -- Новый номер
    rm.manager_phone  -- Старый номер
)
FROM ranked_managers rm
WHERE cafe.managers.manager = rm.manager;  -- Соединяем по имени менеджера

-- Удаляем старое поле с телефоном
ALTER TABLE cafe.managers
DROP COLUMN manager_phone;

-- Переименовываем новое поле в manager_phone
ALTER TABLE cafe.managers
RENAME COLUMN manager_phone_array TO manager_phone;

COMMIT;  -- Завершаем транзакцию, применяя изменения и снимая блокировку с таблицы
