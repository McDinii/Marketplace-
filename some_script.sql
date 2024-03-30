CREATE ROLE admin_role WITH LOGIN PASSWORD 'admin_password';
GRANT ALL PRIVILEGES ON DATABASE marketplace TO admin_role; 

CREATE ROLE client_role WITH LOGIN PASSWORD 'client_password';
GRANT SELECT ON base_product, base_review TO client_role;
GRANT INSERT, UPDATE, DELETE ON base_Order, base_orderitem, base_review TO client_role;

CREATE ROLE guest_role WITH LOGIN PASSWORD 'guest_password';
GRANT SELECT ON base_product, base_review TO guest_role;

CREATE ROLE courier_role WITH LOGIN PASSWORD 'courier_password';
GRANT SELECT, UPDATE ON base_shippingaddress TO courier_role;


-- Процедура добавления категории
CREATE OR REPLACE PROCEDURE public.add_category(p_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_category(name) VALUES(p_name);
END;
$$;

REVOKE ALL ON PROCEDURE public.add_category(VARCHAR) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_category(VARCHAR) TO admin_role;
-- Вызов процедуры создание тестовой категории
CALL public.add_category('TestCategory');

-- Процедура добавления продукта
CREATE OR REPLACE PROCEDURE public.add_product(p_name VARCHAR, p_brand VARCHAR, p_category_id INTEGER, p_description TEXT, p_rating NUMERIC, p_numReviews INTEGER, p_price NUMERIC, p_countInStock INTEGER, p_created_at DATA, p_user_id INTEGER, p_image VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_product(name, brand, category_id, description, rating, "numReviews", price, "countInStock",created_at user_id, image) 
    VALUES(p_name, p_brand, p_category_id, p_description, p_rating, p_numReviews, p_price, p_countInStock,p_created_at p_user_id, p_image);
END;
$$;

REVOKE ALL ON PROCEDURE public.add_product(VARCHAR, VARCHAR, INTEGER, TEXT, NUMERIC, INTEGER, NUMERIC, INTEGER, INTEGER, VARCHAR) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_product(VARCHAR, VARCHAR, INTEGER, TEXT, NUMERIC, INTEGER, NUMERIC, INTEGER, INTEGER, VARCHAR) TO admin_role;
--CALL public.add_product('TestProduct', 'TestBrand', 1, 'TestDescription', 4.5, 10, 100.00, 50, "10.05.2023", 1, 'TestImage');

-- Процедура добавления отзыва
CREATE OR REPLACE PROCEDURE public.add_review(p_name VARCHAR, p_rating INTEGER, p_comment TEXT, p_product_id INTEGER, p_user_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_review(name, rating, comment, product_id, user_id) 
    VALUES(p_name, p_rating, p_comment, p_product_id, p_user_id);
END;
$$;

REVOKE ALL ON PROCEDURE public.add_review(VARCHAR, INTEGER, TEXT, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_review(VARCHAR, INTEGER, TEXT, INTEGER, INTEGER) TO client_role;
CALL public.add_review('TestReview', 5, 'Great product!', 1, 1);


CREATE OR REPLACE PROCEDURE public.add_shipping_address(p_address VARCHAR, p_city VARCHAR, p_postalCode VARCHAR, p_country VARCHAR, p_shippingPrice NUMERIC, p_order_id INTEGER, p_courier_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_shippingaddress(address, city, postalCode, country, shippingPrice, order_id, courier_id) 
    VALUES(p_address, p_city, p_postalCode, p_country, p_shippingPrice, p_order_id, p_courier_id);
END;
$$;

REVOKE ALL ON PROCEDURE public.add_shipping_address(VARCHAR, VARCHAR, VARCHAR, VARCHAR, NUMERIC, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_shipping_address(VARCHAR, VARCHAR, VARCHAR, VARCHAR, NUMERIC, INTEGER, INTEGER) TO admin, courier;
CALL public.add_shipping_address('TestAddress', 'TestCity', 'TestPostalCode', 'TestCountry', 5.00, 1, 1);

set role mcdinii;
CREATE OR REPLACE PROCEDURE public.add_order(
    p_paymentMethod VARCHAR, 
    p_taxPrice NUMERIC, 
    p_shippingPrice NUMERIC, 
    p_totalPrice NUMERIC, 
    p_user_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_order(
        "paymentMethod", 
        "taxPrice", 
        "shippingPrice", 
        "totalPrice", 
        "isPaid", 
        "isDelivered", 
        "status",
        "createdAt", 
        "user_id",
		"deliveryTime"
    ) 
    VALUES(
        p_paymentMethod, 
        p_taxPrice, 
        p_shippingPrice, 
        p_totalPrice, 
        FALSE, 
        FALSE, 
        'Processing',
        NOW(), 
        p_user_id,
		NOW()
    );
END;
$$;


REVOKE ALL ON PROCEDURE public.add_order(VARCHAR, NUMERIC, NUMERIC, NUMERIC, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_order(VARCHAR, NUMERIC, NUMERIC, NUMERIC, INTEGER) TO admin_role;


REVOKE ALL ON PROCEDURE public.add_order(VARCHAR, NUMERIC, NUMERIC, NUMERIC, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_order(VARCHAR, NUMERIC, NUMERIC, NUMERIC, INTEGER) TO admin_role;


REVOKE ALL ON PROCEDURE public.add_order(VARCHAR, NUMERIC, NUMERIC, NUMERIC, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_order(VARCHAR, NUMERIC, NUMERIC, NUMERIC, INTEGER) TO client;
CALL public.add_order('TestPaymentMethod', 10.00, 5.00, 115.00, 4);

-- Процедура добавления элемента заказа
CREATE OR REPLACE PROCEDURE public.add_order_item(p_name VARCHAR, p_qty INTEGER, p_price NUMERIC, p_image VARCHAR, p_order_id INTEGER, p_product_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_orderitem(name, qty, price, image, order_id, product_id) 
    VALUES(p_name, p_qty, p_price, p_image, p_order_id, p_product_id);
END;
$$;

REVOKE ALL ON PROCEDURE public.add_order_item(VARCHAR, INTEGER, NUMERIC, VARCHAR, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_order_item(VARCHAR, INTEGER, NUMERIC, VARCHAR, INTEGER, INTEGER) TO client;
CALL public.add_order_item('TestOrderItem', 1, 100.00, 'TestImage', 1, 1);

-- Процедура добавления курьера
CREATE OR REPLACE PROCEDURE public.add_courier(p_name VARCHAR, p_active BOOLEAN, p_user_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_courier(name, active, user_id) 
    VALUES(p_name, p_active, p_user_id);
END;
$$;

REVOKE ALL ON PROCEDURE public.add_courier(VARCHAR, BOOLEAN, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_courier(VARCHAR, BOOLEAN, INTEGER) TO admin;
CALL public.add_courier('TestCourier', TRUE, 1);


-- Процедура просмотра пользователей
CREATE OR REPLACE PROCEDURE public.view_users(out ref REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN ref FOR SELECT id, username, first_name, last_name, email FROM public."auth_user";
END;
$$;

REVOKE ALL ON PROCEDURE public.view_users(REFCURSOR) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.view_users(REFCURSOR) TO admin_role;

CREATE OR REPLACE FUNCTION public.view_users_func()
RETURNS SETOF auth_user
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT * FROM public."auth_user";
END;
$$;
select username, email,  password,last_login from public.view_users_func();


-- Процедура просмотра товаров
CREATE OR REPLACE PROCEDURE public.view_products()
LANGUAGE plpgsql
AS $$
BEGIN
    CREATE TEMPORARY TABLE temp_products AS SELECT * FROM public.base_product;
    SELECT * FROM temp_products;
    DROP TABLE temp_products;
END;
$$;

REVOKE ALL ON PROCEDURE public.view_products() FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.view_products() TO admin_role;

CALL public.view_products();

-- Процедура просмотра всех заказов
CREATE OR REPLACE PROCEDURE public.view_orders()
LANGUAGE plpgsql
AS $$
BEGIN
    CREATE TEMPORARY TABLE temp_orders AS SELECT * FROM public.base_order;
    SELECT * FROM temp_orders;
    DROP TABLE temp_orders;
END;
$$;

REVOKE ALL ON PROCEDURE public.view_orders() FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.view_orders() TO admin_role;

CALL public.view_orders();


-- Процедура удаления продукта
CREATE OR REPLACE PROCEDURE public.delete_product(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public.base_product WHERE _id = p_id;
END;
$$;

REVOKE ALL ON PROCEDURE public.delete_product(INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.delete_product(INTEGER) TO admin;
CALL public.delete_product(1);




CREATE OR REPLACE FUNCTION update_delivery_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Delivered' THEN
        NEW."isDelivered" := TRUE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delivery_status_trigger
BEFORE UPDATE ON public."base_order"
FOR EACH ROW
WHEN (NEW.status <> OLD.status)
EXECUTE FUNCTION update_delivery_status();

SET ROLE mcdinii;
GRANT INSERT, UPDATE, DELETE ON TABLE public."base_order" TO admin_role;
GRANT USAGE ON SEQUENCE public.base_order_id_seq TO admin_role;

-- Установим роль админа, так как она имеет права на внесение изменений в заказы
SET ROLE admin_role;

-- Добавим новый заказ с помощью процедуры add_order
CALL public.add_order('TestPaymentMethod', 10.00, 5.00, 115.00, 4);


-- Проверим, что статус заказа установлен в 'Processing'
SELECT "status", "isDelivered" FROM public."base_order" WHERE "paymentMethod" = 'TestPaymentMethod';

-- Обновим статус заказа
UPDATE public."base_order" SET "status" = 'Delivered' WHERE "paymentMethod" = 'TestPaymentMethod';

-- Проверим, что статус заказа обновился
Select "status","isDelivered" FROM public."base_order" WHERE "paymentMethod" = 'TestPaymentMethod';



CREATE OR REPLACE FUNCTION update_payment_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Paid' THEN
        NEW."isPaid" := TRUE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER payment_status_trigger
BEFORE UPDATE ON public."base_order"
FOR EACH ROW
WHEN (NEW.status <> OLD.status)
EXECUTE FUNCTION update_payment_status();

CREATE OR REPLACE FUNCTION check_product_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT "countInStock" FROM public.base_product WHERE _id = NEW._id) <= 0 THEN
        RAISE EXCEPTION 'Product is not available.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_availability_trigger
BEFORE INSERT ON public."base_order"
FOR EACH ROW
EXECUTE FUNCTION check_product_availability();


CREATE OR REPLACE FUNCTION update_product_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public."base_product" 
    SET "countInStock" = "countInStock" - 1 
    WHERE _id = NEW._id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_count_trigger
AFTER INSERT ON public."base_order"
FOR EACH ROW
EXECUTE FUNCTION update_product_count();


-- Добавление нового заказа через процедуру добавления заказа
CALL public.add_order('TestPaymentMethod', 10.00, 5.00, 115.00, 1)
-- Проверка статуса оплаты и доставки
SELECT "isPaid", "isDelivered" FROM public."base_order" WHERE "paymentMethod" = 'TestPaymentMethod';

-- Обновление статуса заказа на 'Paid'
UPDATE public."base_order" SET "status" = 'Paid' WHERE "paymentMethod" = 'TestPaymentMethod';

-- Проверка, что статус оплаты обновился
SELECT "isPaid" FROM public."base_order" WHERE "paymentMethod" = 'TestPaymentMethod';

-- Процедура добавления отзыва к товару
CREATE OR REPLACE PROCEDURE public.add_review(
    p_name VARCHAR,
    p_id INTEGER,
    p_createdAt TIMESTAMP WITH TIME ZONE,
    p_comment VARCHAR,
    p_rating INTEGER,
    p_user_id INTEGER,
    p_product_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public."base_review"(name,_id,"createdAt","comment", "rating", "user_id", "product_id") 
    VALUES(p_name, p_id, p_createdAt, p_comment, p_rating, p_user_id, p_product_id);
END;
$$;

REVOKE ALL ON PROCEDURE public.add_review(VARCHAR, INTEGER, TIMESTAMP WITH TIME ZONE, VARCHAR, INTEGER, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON PROCEDURE public.add_review(VARCHAR, INTEGER, TIMESTAMP WITH TIME ZONE, VARCHAR, INTEGER, INTEGER, INTEGER) TO client_role;

-- Вызов процедуры добавления отзыва к товару
CALL public.add_review('Test Review', 1, CURRENT_TIMESTAMP, 'Great product!', 5, 4, 5);
select * from base_review;

--Просмотр категорий
CREATE OR REPLACE PROCEDURE public.view_categories(out ref REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN ref FOR SELECT * FROM public."base_category";
END;
$$;

-- Просмотр товаров в категории
CREATE OR REPLACE PROCEDURE public.view_products_in_category(out ref REFCURSOR, p_category_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN ref FOR SELECT * FROM public."base_product" WHERE "category_id" = p_category_id;
END;
$$;

-- Просмотр детальной информации о товаре
CREATE OR REPLACE PROCEDURE public.view_product_details(out ref REFCURSOR, p_product_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN ref FOR SELECT * FROM public."base_product" WHERE "id" = p_product_id;
END;
$$;

-- Просмотр отзывов о товаре
CREATE OR REPLACE PROCEDURE public.view_product_reviews(out ref REFCURSOR, p_product_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN ref FOR SELECT * FROM public."base_review" WHERE "product_id" = p_product_id;
END;
$$;

-- Процедура добавления товара в заказ
CREATE OR REPLACE PROCEDURE public.add_product_to_order(
    p_order_id INTEGER,
    p_product_id INTEGER,
    p_quantity INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.base_order_item(order_id, product_id, quantity)
    VALUES(p_order_id, p_product_id, p_quantity);
END;
$$;

-- Процедура обновления информации об адресе доставки
CREATE OR REPLACE PROCEDURE public.update_shipping_address(
    p_address_id INTEGER,
    p_new_address VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.base_shippingadress
    SET address = p_new_address
    WHERE id = p_address_id;
END;
$$;

-- Процедура для просмотра информации о статусе доставки заказа пользователя
CREATE OR REPLACE PROCEDURE public.view_order_delivery_status(
    p_order_id INTEGER,
    OUT status VARCHAR,
    OUT isDelivered BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT "status", "isDelivered" INTO status, isDelivered FROM public.base_order WHERE id = p_order_id;
END;
$$;

-- Вызов процедуры просмотра информации о статусе доставки заказа пользователя
CALL public.view_order_delivery_status(1);

CREATE OR REPLACE PROCEDURE public.view_product_reviews(p_product_id INTEGER, OUT ref REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN ref FOR SELECT * FROM public."base_review" WHERE "product_id" = p_product_id;
END;
$$;



-- Процедура просмотра товаров для гостя
CREATE OR REPLACE PROCEDURE public.view_products_for_guest(OUT ref refcursor)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN ref FOR SELECT * FROM public."base_product";
END;
$$;

-- Процедура просмотра товаров для гостя
CREATE OR REPLACE PROCEDURE public.view_products_for_guest()
LANGUAGE plpgsql
AS $$
DECLARE
    rec public."base_product"%rowtype; -- Переменная-запись для хранения строки
BEGIN
    FOR rec IN SELECT * FROM public."base_product" LOOP
        -- Выводим данные из таблицы
        RAISE NOTICE 'Product: %', rec;
    END LOOP;
END;
$$;

-- Вызов процедуры просмотра товаров для гостя
CALL public.view_products_for_guest();

CREATE OR REPLACE FUNCTION update_order_status() RETURNS TRIGGER AS $$
BEGIN
    IF NEW."deliveryTime" <= current_timestamp AND NEW."status" != 'Delivered' THEN
        NEW."status" := 'Delivered';
        NEW."isDelivered" := TRUE;
        NEW."deliveredAt" := current_timestamp;
        RAISE NOTICE 'Order % is now Delivered', NEW."_id";
    ELSIF NEW."deliveryTime" > current_timestamp AT TIME ZONE 'UTC' AND NEW."status" = 'Delivered' THEN
        RAISE NOTICE 'Order % should not be Delivered yet', NEW."_id";
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;





CREATE TRIGGER check_delivery_time
BEFORE UPDATE ON "base_order"
FOR EACH ROW
EXECUTE FUNCTION update_order_status();

-- Обновление статуса заказа на 'Paid'
UPDATE public."base_order" SET "status" = 'Delivered' WHERE "paymentMethod" = 'TestPaymentMethod';

-- Проверка, что статус оплаты обновился
SELECT * FROM public."base_order" WHERE "paymentMethod" = 'TestPaymentMethod';







drop function register_courier
CREATE OR REPLACE FUNCTION register_courier(
    courier_name VARCHAR, 
    user_name VARCHAR,
	first_name VARCHAR,
	last_name VARCHAR,
    user_password VARCHAR, 
    user_email VARCHAR
) RETURNS TEXT AS $$

DECLARE
    new_courier_id INTEGER;
BEGIN

    INSERT INTO auth_user (username,first_name,last_name, password, email, is_staff, is_active, is_superuser, date_joined)
    VALUES (user_name,first_name,last_name,  user_password, user_email, FALSE, TRUE, FALSE, NOW())
    RETURNING id INTO new_courier_id;

    INSERT INTO base_courier (user_id, name, active)
    VALUES (new_courier_id, courier_name, TRUE);
    RETURN 'Courier successfully registered with ID ' || new_courier_id;
EXCEPTION WHEN unique_violation THEN
    RETURN 'Registration failed. Courier with this name already exists.';
END;
$$ LANGUAGE plpgsql;


delete from base_courier ;
select register_courier('example_user','Pn','palh', 'example_user', 'Password', 'email@example.com');


BEGIN;
CALL public.view_couriers();
FETCH ALL IN "<cursor_name>";
COMMIT;
EXPLAIN SELECT * FROM base_order WHERE status = 'Delivered';

CREATE INDEX Auth_index ON auth_user (username);
CREATE INDEX Order_status_index ON "base_order" ("status");
CREATE INDEX Courier_active_index ON base_courier (active);
--CREATE INDEX Order_user_index ON "Order" (user_id);



CREATE OR REPLACE FUNCTION insert_random_orders() RETURNS VOID AS $$
DECLARE
    counter INTEGER := 0;
    user_count INTEGER;
    random_user_id INTEGER;
    random_status VARCHAR;
    statuses VARCHAR[] := ARRAY['Processing', 'Shipped', 'Delivered'];
BEGIN
    SELECT COUNT(*) INTO user_count FROM auth_user;

    WHILE counter < 100000 LOOP
        SELECT floor(random() * user_count) + 1 INTO random_user_id;
        random_status := statuses[floor(random() * array_length(statuses, 1)) + 1];
        
        INSERT INTO "base_order" (
            user_id, 
            "paymentMethod",
            "deliveryTime", 
            "taxPrice",
            "shippingPrice",
            "totalPrice",
            status,
            "isPaid",
            "paidAt",
            "isDelivered",
            "deliveredAt",
            "createdAt"
        )
        VALUES (
            (SELECT id FROM auth_user LIMIT 1 OFFSET random_user_id), 
            'Credit Card',
            NOW() + interval '1 day' * counter,
            10.00,
            5.00,
            100.00,
            random_status,
            TRUE,
            NOW(),
            FALSE,
            NULL,
            NOW()
        );
        
        counter := counter + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



SELECT insert_random_orders();
-- Сортировка заказов по дате создания
-- Создание индекса
CREATE INDEX IF NOT EXISTS idx_order_created_at ON public.base_order ("createdAt");


select * from base_order where "taxPrice" < 30;

CREATE OR REPLACE PROCEDURE export_posts_json(path_to_file text)
LANGUAGE plpgsql
AS $$
BEGIN
EXECUTE format('COPY (SELECT row_to_json(t) FROM (SELECT * FROM "base_product") t) TO %L', path_to_file);
END;
$$;

call export_posts_json('/Users/mcdinii/McDinii_backup/Study/01Univer/2nd-year/file.json');
CREATE OR REPLACE PROCEDURE import_posts_json(path_to_file text)
LANGUAGE plpgsql
AS $$
BEGIN
CREATE TEMP TABLE temp (data jsonb);

EXECUTE format('COPY temp (data) FROM %L', path_to_file);

INSERT INTO public.base_product ("name", "createdAt", "user_id")
SELECT data-»'Text', (data-»'CreationTime')::timestamp with time zone, (data-»'UserId')::integer
FROM temp;

DROP TABLE temp;
END;
$$;

SELECT * FROM pg_extension WHERE extname = 'adminpack';


CREATE OR REPLACE PROCEDURE import_json(file_path TEXT) AS $$
DECLARE
  usersJson JSON;
  fileContent TEXT;
  json_data JSON;
BEGIN
  SELECT pg_read_file(file_path) INTO fileContent;
  usersJson := fileContent::JSON;

  CREATE TEMP TABLE temp AS
  SELECT json_array_elements(usersJson) AS json_data;

  INSERT INTO "base_product" ("name", "createdAt", "user_id", "category_id", "rating")
  SELECT 
    (json_data->>'name'), 
    (json_data->>'createdAt')::timestamp, 
    (json_data->>'user_id')::integer, 
    (json_data->>'category_id')::integer, 
    (json_data->>'rating')::numeric 
  FROM temp
  WHERE json_data->>'createdAt' IS NOT NULL;

  RAISE NOTICE 'JSON data: %', usersJson;
END;
$$ LANGUAGE plpgsql;



CALL import_from_json('/Users/mcdinii/McDinii_backup/Study/01Univer/2nd-year/BD_courseproj/file.json');


drop procedure export_to_json
CREATE OR REPLACE PROCEDURE export_to_json(p_file_path TEXT)
LANGUAGE plpgsql AS $$
DECLARE  v_json JSON;
    BEGIN
        SELECT json_agg(t) INTO v_json FROM (SELECT * FROM "base_product") t  ;
        PERFORM pg_catalog.pg_file_write(p_file_path, v_json::text, 'true');
    END;
 $$;
CALL export_to_json('/Users/mcdinii/McDinii_backup/Study/01Univer/2nd-year/BD_courseproj/file.json');

CREATE EXTENSION adminpack;
SELECT * FROM pg_extension WHERE extname = 'adminpack';



CREATE OR REPLACE PROCEDURE import_to_json(path_to_file text)
LANGUAGE plpgsql
AS $$
BEGIN
CREATE TEMP TABLE temp (data jsonb);

EXECUTE format('COPY temp (data) FROM %L', path_to_file);

INSERT INTO "base_category" ("id", "name")
SELECT (data->>'id')::integer,data->>'name' 
FROM temp;

DROP TABLE temp;
END;
$$;

CREATE OR REPLACE PROCEDURE export_json(path_to_file text)
LANGUAGE plpgsql
AS $$
BEGIN
EXECUTE format('COPY (SELECT row_to_json(t) FROM (SELECT * FROM "base_category") t) TO %L', path_to_file);
END;
$$;
call export_p_json('/Users/mcdinii/McDinii_backup/Study/01Univer/2nd-year/BD_courseproj/file.json');

call import_to_json('/Users/mcdinii/McDinii_backup/Study/01Univer/2nd-year/BD_courseproj/file.json');

select * from base_category;
select count(*) from base_order;
SELECT 
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan AS times_index_scanned,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM 
    pg_stat_user_indexes;
	
CREATE OR REPLACE FUNCTION delete_review(review_id INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM base_review WHERE _id = review_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_review(review_id INTEGER, new_rating INTEGER, new_comment TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE base_review SET rating = new_rating, comment = new_comment WHERE _id = review_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_order(order_id INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM base_order WHERE _id = order_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_order(order_id INTEGER, new_status TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE base_order SET status = new_status WHERE _id = order_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_user(user_id INTEGER, new_name TEXT, new_email TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE auth_user SET first_name = new_name, email = new_email WHERE id = user_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_courier(courier_id INTEGER, new_name TEXT, new_active BOOLEAN)
RETURNS VOID AS $$
BEGIN
    UPDATE base_courier SET name = new_name, active = new_active WHERE _id = courier_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_category(category_id INTEGER, new_name TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE base_category SET name = new_name WHERE _id = category_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_order(
    p_user_id INTEGER,
    p_payment_method TEXT,
    p_delivery_time TIMESTAMP,
    p_tax_price DECIMAL,
    p_shipping_price DECIMAL,
    p_total_price DECIMAL,
    p_status TEXT,
    p_is_paid BOOLEAN,
    p_paid_at TIMESTAMP,
    p_is_delivered BOOLEAN,
    p_delivered_at TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO base_order (
        user_id,
        "paymentMethod",
        "deliveryTime",
        "taxPrice",
        "shippingPrice",
        "totalPrice",
        status,
        "isPaid",
        "paidAt",
        "isDelivered",
        "deliveredAt"
    )
    VALUES (
        p_user_id,
        p_payment_method,
        p_delivery_time,
        p_tax_price,
        p_shipping_price,
        p_total_price,
        p_status,
        p_is_paid,
        p_paid_at,
        p_is_delivered,
        p_delivered_at
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contact_support(user_id INTEGER, message TEXT)
RETURNS TEXT AS $$
BEGIN
    -- Ваш код для сохранения сообщения от пользователя в базе данных
    -- Можете использовать user_id для идентификации пользователя и сохранения сообщения
    -- Например, INSERT INTO support_messages (user_id, message) VALUES (user_id, message);
    
    -- Вернуть сообщение пользователю о успешной отправке сообщения
    RETURN 'Ваше сообщение было успешно отправлено в службу поддержки.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rate_delivery(courier_id INTEGER, rating INTEGER, comment TEXT)
RETURNS TEXT AS $$
DECLARE
    courier_name TEXT;
    message TEXT;
BEGIN
    -- Получить имя курьера по идентификатору
    SELECT name INTO courier_name FROM courier WHERE courier_id = courier_id;
    
    -- Ваш код для сохранения оценки доставки в базе данных
    -- Можете использовать courier_id для идентификации курьера и сохранения оценки и комментария
    -- Например, INSERT INTO courier_rating (courier_id, rating, comment) VALUES (courier_id, rating, comment);
    
    -- Сформировать сообщение с информацией о доставке и оценке курьера
    message := 'Доставка оценена. Курьер: ' || courier_name || ', Оценка: ' || rating;
    
    -- Вернуть сообщение
    RETURN message;
END;
$$ LANGUAGE plpgsql;







CREATE OR REPLACE FUNCTION check_long_running_queries(time_threshold INTERVAL)
RETURNS TABLE(query_text TEXT, duration INTERVAL) AS $$
BEGIN
    RETURN QUERY
    SELECT current_query AS query_text, now() - query_start AS duration
    FROM pg_stat_activity
    WHERE query_start < now() - time_threshold
    AND state = 'active'
    ORDER BY duration DESC;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_table_size(in_table_name TEXT)
RETURNS TABLE(table_name TEXT, size_bytes BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT CAST(t.table_name AS TEXT), pg_total_relation_size(t.table_name::regclass)
    FROM information_schema.tables AS t
    WHERE t.table_schema = 'public'
    AND t.table_name = in_table_name
    ORDER BY pg_total_relation_size(t.table_name::regclass) DESC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_connection_pool()
RETURNS TABLE(
    pid INTEGER, 
    datname TEXT, 
    usename TEXT, 
    application_name TEXT, 
    client_hostname TEXT, 
    client_port INTEGER, 
    backend_start TIMESTAMP WITH TIME ZONE, 
    query_start TIMESTAMP WITH TIME ZONE, 
    query TEXT, 
    state TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pid,
        datname,
        usename,
        application_name,
        client_hostname,
        client_port,
        backend_start,
        query_start,
        query,
        state
    FROM pg_stat_activity
    WHERE state = 'active';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_table_indexes_size(in_table_name TEXT)
RETURNS TABLE(index_name TEXT, size_bytes BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        CAST(i.relname AS TEXT) AS index_name,
        pg_total_relation_size(i.oid) AS size_bytes
    FROM
        pg_class t,
        pg_class i,
        pg_index ix
    WHERE
        t.oid = ix.indrelid
        AND i.oid = ix.indexrelid
        AND t.relkind = 'r'
        AND t.relname = in_table_name;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM check_table_size('base_product');

SELECT * FROM check_table_indexes_size('base_product');
select * from check_long_running_queries('1 hour');
-- Вызов функции check_connection_pool
SELECT * FROM check_connection_pool();

-- Вызов функции check_long_running_queries с параметром '1 hour'
SELECT * FROM check_long_running_queries('1 hour'::INTERVAL);

