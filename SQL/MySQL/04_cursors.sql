# exercise 1.1 - Newsletter
# Write a procedure using cursors that for active clients from the Buenos Aires area
# returns the email to send the newsletter to.
#
# Separate elements with ;.
#
# Hint: Data needed to do it are in the customer and address tables.

SELECT
    email
FROM sakila1_83.customer
LEFT JOIN sakila1_83.address
USING (address_id)
WHERE active = 1 AND district = 'Buenos Aires';

DELIMITER $$
DROP PROCEDURE IF EXISTS newslleter_dn;
CREATE PROCEDURE newslleter_dn(INOUT e_adress varchar(16000))
BEGIN
  DECLARE finished INTEGER DEFAULT 0;
  DECLARE customer varchar(100) DEFAULT '';

  DECLARE cur_customer
      CURSOR FOR
            SELECT
                email
            FROM sakila1_83.customer
            LEFT JOIN sakila1_83.address
            USING (address_id)
            WHERE active = 1 AND district = 'Buenos Aires';

  DECLARE CONTINUE HANDLER
      FOR NOT FOUND SET finished = 1;

  OPEN cur_customer;

  get_customer: LOOP
      FETCH cur_customer INTO customer;

      IF finished = 1 THEN
          LEAVE get_customer;
      END IF;

      SET e_adress =
          concat(customer, ';', e_adress);
  END LOOP get_customer;
  CLOSE cur_customer;
END$$
DELIMITER ;


-- 2. Příprava proměnné pro INOUT parametr
SET @e_adress = '';

-- 3. Zavolání procedury
CALL newslleter_dn(@e_adress);

-- 4. Zobrazení výsledku
SELECT @e_adress AS result;