# exercise 1.1 - Film rental
# Based on the analogy with a bank transaction, write a film_rental procedure
# that uses the table trigger_exercise.stock_part_1 to check whether a given
# film_id can be rented - if so, reduce the stock by one and return 1, otherwise return 0.
#
# Take advantage of the transaction mechanism here by following the steps below:
#
# First write a query that finds the film and reduces its stock by 1,
# If the film is found and its count is sufficient to be rented, approve the transaction.
# Otherwise, cancel it.
USE trigger_exercise1_83;
DELIMITER $$
DROP PROCEDURE IF EXISTS film_rental;
CREATE PROCEDURE film_rental(IN id INT)
BEGIN
    DECLARE exit_code INT;
    START TRANSACTION;
        UPDATE trigger_exercise1_83.stock_part_1
            SET stock = stock - 1
            WHERE film_id = id AND stock > 0;

        IF ROW_COUNT() > 0 THEN
            SET exit_code = 1;
            COMMIT;
        ELSE
            SET exit_code = 0;
            ROLLBACK;
        END IF;
        SELECT exit_code AS result;
END $$
DELIMITER ;

CALL film_rental(1);

SELECT * FROM stock_part_1;
# musím zkontrolovat, v jakém jsem schématu

# exercise 2.1 - Stock
# Modify the solution of the previous
# task so that it also returns the number of movies available to rent.

DELIMITER $$
DROP PROCEDURE IF EXISTS film_rental_to_rent;
CREATE PROCEDURE film_rental_to_rent(IN id INT)
BEGIN
    DECLARE exit_code INT;
    START TRANSACTION;
        UPDATE trigger_exercise1_83.stock_part_1
            SET stock = stock - 1
            WHERE film_id = id AND stock > 0;
        IF ROW_COUNT() > 0 THEN
            COMMIT;
            SET exit_code = 1;
        ELSE
            ROLLBACK;
            SET exit_code = 0;
        END IF;
        SELECT
            exit_code AS result,
            (SELECT stock FROM trigger_exercise1_83.stock_part_1 WHERE film_id = id) AS movies_available;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS film_rental_to_rent;
CREATE PROCEDURE film_rental_to_rent(IN id INT)
BEGIN
    DECLARE exit_code INT;
    DECLARE original_stock INT;

    -- Uložení původní hodnoty stock do proměnné
    SELECT stock INTO original_stock
    FROM trigger_exercise1_83.stock_part_1
    WHERE film_id = id;

    START TRANSACTION;
        UPDATE trigger_exercise1_83.stock_part_1
            SET stock = stock - 1
            WHERE film_id = id AND stock > 0;

        IF ROW_COUNT() > 0 THEN
            COMMIT;
            SET exit_code = 1;
        ELSE
            ROLLBACK;
            SET exit_code = 0;
        END IF;

    -- Použití uložené hodnoty stock před update
    SELECT
        exit_code AS result,
        original_stock AS movies_available_before_update,
        (SELECT stock FROM trigger_exercise1_83.stock_part_1 WHERE film_id = id) AS movies_available_after_update;
END $$
DELIMITER ;

CALL film_rental_to_rent(8);
SELECT * FROM stock_part_1;

# 3.1 - Film rentals 2
# Write a procedure film_rental_store that tests if it is possible to rent
# the film at the given store (stock_part_2 table).
#
# If possible (the film is available), the procedure should:
#
# return the information, about the stock after renting the film
# and the information that the film is available to rent.
# Otherwise, the procedure should:
#
# return the information that the film is out of stock in the store,
# return the information whether the film can be rented from another store.
# If so, make a reservation there, that is: reduce the stock.
# What parameters does the procedure need to take to be executed?
#
# You may use this. Additionally, offer a different solution.
#
# Hint:
#
# The stock is updated by removing the appropriate record from the table;
# remember to start a transaction before DELETE.
SELECT
    store_id,
    film_id,
    stock
FROM stock_part_1
INNER JOIN stock_part_2
USING (film_id);

WITH join_table AS (
    SELECT store_id, film_id, SUM(stock) AS sum_total
    FROM stock_part_2
    INNER JOIN stock_part_1  USING (film_id)
    WHERE film_id = 3 AND store_id = 2
    GROUP BY store_id, film_id
)
SELECT sum_total
FROM join_table;


DELIMITER $$
DROP PROCEDURE IF EXISTS film_rental_store_dn;
CREATE PROCEDURE film_rental_store_dn(IN f_id INT, IN s_id INT)
BEGIN
    DECLARE exit_message VARCHAR(50);
    DECLARE available_stock INT;

    WITH join_table AS (
    SELECT store_id, film_id, SUM(stock) AS sum_total
    FROM stock_part_2
    INNER JOIN stock_part_1  USING (film_id)
    WHERE film_id = f_id AND store_id = s_id
    GROUP BY store_id, film_id
    )
    SELECT sum_total INTO available_stock
    FROM join_table;

    IF available_stock > 0 THEN
        START TRANSACTION;
        UPDATE stock_part_1 INNER JOIN stock_part_2 USING (film_id)
        SET stock = stock - 1
        WHERE film_id = f_id AND store_id = s_id;
        COMMIT;
        SET exit_message = 'Available to rent';
    ELSE
        WITH join_table AS (
        SELECT store_id, film_id, SUM(stock) AS sum_total
        FROM stock_part_2
        INNER JOIN stock_part_1  USING (film_id)
        WHERE film_id = f_id AND store_id != s_id AND stock > 0
        GROUP BY store_id, film_id
        )
        SELECT sum_total INTO available_stock
        FROM join_table;

        IF available_stock > 0 THEN
            START TRANSACTION;
            UPDATE stock_part_1 INNER JOIN stock_part_2 USING (film_id)
            SET stock = stock - 1
            WHERE film_id = f_id AND store_id != s_id AND stock > 0;
            COMMIT;
            SET exit_message = 'Out of stock. Reserved in another store.';
        ELSE
            SET exit_message = 'Out of stock.';
        END IF;
    END IF;


        SELECT exit_message AS result,
        (SELECT SUM(stock) FROM stock_part_1 INNER JOIN stock_part_2 USING (film_id)
        WHERE stock_part_1.film_id = f_id AND store_id = s_id) AS movies_available;
END $$

DELIMITER ;

CALL film_rental_store_dn(1, 2);

# Tomovo reseni:

DELIMITER $$
DROP PROCEDURE  IF EXISTS  film_rental_store;
CREATE PROCEDURE film_rental_store(IN id_film INT, IN id_stock INT)
BEGIN
    DECLARE stock_count INT;
    DECLARE id_store INT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET id_store = NULL;

    START TRANSACTION;
    UPDATE trigger_exercise1_83.stock_part_1 AS one
    INNER JOIN trigger_exercise1_83.stock_part_2 AS two
    USING (film_id)
    SET one.stock = one.stock - 1
    WHERE one.film_id = id_film AND two.store_id = id_stock;
    IF ROW_COUNT() > 0 THEN
        SELECT one.stock INTO stock_count FROM trigger_exercise1_83.stock_part_1 AS one
        INNER JOIN trigger_exercise1_83.stock_part_2 AS two
        USING (film_id) WHERE one.film_id = id_film AND two.store_id = id_stock LIMIT 1;
        SELECT 'Film is available for rent' as message, stock_count as availability_after_renting;
        COMMIT;
    ELSE
        SELECT two.store_id INTO id_store FROM trigger_exercise1_83.stock_part_1 AS one
        INNER JOIN trigger_exercise1_83.stock_part_2 AS two
        USING (film_id) WHERE one.film_id = id_film AND one.stock > 0 AND two.store_id != id_stock LIMIT 1;

        IF id_store IS NOT NULL THEN
            SELECT 'Film isn\'t available at this store' as message, id_store as available_at_this_store;
        ELSE
            SELECT 'Film isn\'t available at this store' as message;
        end if;
        ROLLBACK;
    end if;
end $$

CALL film_rental_store(8, 1);