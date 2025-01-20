# exercise 1.1 - Multiplication
# Create a database procedure with a name of your choice that for the parameters:
# base and number_of_elements returns the multiple of base equal to the number of elements.

DELIMITER $$
DROP PROCEDURE IF EXISTS multiplication;
CREATE PROCEDURE multiplication()
BEGIN
    DECLARE base  INT;
    DECLARE number_of_elements INT;
    DECLARE str  VARCHAR(255);
    SET base = 2, number_of_elements = 10, str =  '';

    while_label:  WHILE base < 20 DO
        SET str = CONCAT(str,base,',');
        SET base = base + 2;
    END WHILE;
    SELECT str;
END$$
DELIMITER ;

CALL multiplication();

DELIMITER $$
DROP PROCEDURE  IF EXISTS multiplication_table;
CREATE PROCEDURE multiplication_table(IN p_base INT, IN p_number INT)
BEGIN
    DECLARE x INT;
    DECLARE str VARCHAR(255);

    SET x = 1;
    SET str = '';

    while_label: WHILE x < p_number DO
        SET str = concat(str, cast(p_base * x as CHAR(10)), ','
            );
        SET x = x+1;
    END WHILE;
    SELECT STR;
END $$

CALL multiplication_table(2, 10);

# exercise 2.1 Randomization
DROP TABLE IF EXISTS randomizer;
CREATE TABLE randomizer (
    id INT,
    value FLOAT
);

DELIMITER $$
DROP PROCEDURE  IF EXISTS fill_randomizer;
CREATE PROCEDURE fill_randomizer(IN n INT)
BEGIN
    DECLARE x INT;
    DECLARE value FLOAT;

    SET x = 1;
    TRUNCATE TABLE randomizer; -- removes all rows from table

    while_label: WHILE x <= n DO
        SET value = RAND();
        INSERT INTO randomizer VALUES (x, value);
        SET x = x+1;
    END WHILE;
END $$

CALL fill_randomizer(10);
SELECT * FROM randomizer;
