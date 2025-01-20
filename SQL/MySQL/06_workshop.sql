# 1) Database structure:
# What are the primary keys in the individual tables?

SHOW KEYS FROM account;
# table account - PRIMARY KEY -> account_id
SHOW KEYS FROM card;
# table card - PRIMARY KEY -> card_id
SHOW KEYS FROM client;
# table client - PRIMARY KEY -> client_id
SHOW KEYS FROM disp;
# table disp - PRIMARY KEY -> disp_id
SHOW KEYS FROM district;
# table district - PRIMARY KEY -> district_id
SHOW KEYS FROM loan;
# table loan - PRIMARY KEY -> loan_id
SHOW KEYS FROM `order`;
# table order - PRIMARY KEY -> order_id
SHOW KEYS FROM trans;
# table trans - PRIMARY KEY -> trans_id

# What relationships do particular pairs of tables have?

# disp -> card - one to many
# disp -> acount - one to many
# client -> disp - one to many
# district -> account - one to many
# district -> client - one to many
# account -> loan - one to many
# account -> order - one to many
# account -> trans - one to many

# 2) History of granted loans

SELECT
    YEAR(date) AS 'year',
    QUARTER(date) AS 'quarter',
    MONTH(date) AS 'month',
    SUM(amount) AS 'total_amount_of_loans',
    AVG(amount) AS 'average_loan_amount',
    COUNT(*) AS 'number_of_given_loans'
FROM loan
GROUP BY year, quarter, month
WITH ROLLUP;

# 3) Loan status
SELECT
    status,
    COUNT(status)
FROM loan
GROUP BY status;

SELECT
    status,
    COUNT(status)
FROM loan
WHERE status IN ('B', 'D')
GROUP BY status;
# Unpaid loans status = B and D

# 3) Analysis of accounts

WITH summary_table AS (SELECT account_id,
                               COUNT(amount) AS 'number_of_given_loans',
                               SUM(amount)   AS 'amount_of_given_loans',
                               AVG(amount)   AS 'average_loan_amount'
                        FROM loan
                        WHERE status NOT IN ('B', 'D')
                        GROUP BY account_id)
SELECT *,
       RANK() over (ORDER BY number_of_given_loans DESC) AS 'rank_given_loans',
       RANK() over (ORDER BY amount_of_given_loans DESC) AS 'rank_amount_loans'
FROM summary_table;

# 4) Fully paid loans
SELECT * FROM client; # gender
SELECT * FROM loan; # loans information
SELECT * FROM disp; # path to client
SELECT * FROM account; # path to client

SELECT
    gender AS 'client_gender',
    sum(amount) AS 'balance_of_repaid_loans'
FROM loan
INNER JOIN account USING (account_id)
INNER JOIN disp USING (account_id)
INNER JOIN client USING (client_id)
WHERE status NOT IN ('B', 'D')
GROUP BY gender
WITH ROLLUP;
# Verification
SELECT
    sum(amount) AS 'total'
FROM loan
WHERE status NOT IN ('B', 'D');
# It is not equal
# modification;
SELECT
    gender AS client_gender,
    sum(amount) AS balance_of_repaid_loans
FROM loan
INNER JOIN account USING (account_id)
INNER JOIN disp USING (account_id)
INNER JOIN client USING (client_id)
WHERE status NOT IN ('B', 'D') AND type = 'OWNER'
GROUP BY gender;


# 5) Client analysis - part 1
DROP TEMPORARY TABLE IF EXISTS client_with_age;
CREATE TEMPORARY TABLE client_with_age AS (
SELECT
    *,
    (2024 -year(birth_date)) AS 'age'
FROM client);

DROP TEMPORARY TABLE IF EXISTS loan_by_gender;
CREATE TEMPORARY TABLE loan_by_gender AS (
SELECT
    gender AS client_gender,
    sum(amount) AS balance_of_repaid_loans,
    count(amount) AS total_count_of_loans,
    avg(age) AS mean_age
FROM loan
INNER JOIN account USING (account_id)
INNER JOIN disp USING (account_id)
INNER JOIN client_with_age USING (client_id)
WHERE status NOT IN ('B', 'D') AND type = 'OWNER'
GROUP BY gender);

# 6) Client analysis - part 2
SELECT * FROM client; # clients
SELECT * FROM disp; # path to client
SELECT * FROM account; # path to client
SELECT * FROM loan; # loans information
SELECT * FROM district; # area

DROP TEMPORARY TABLE IF EXISTS area_report;
CREATE TEMPORARY TABLE area_report AS (
SELECT
    A2 AS area,
    COUNT(client_id) number_of_clients,
    COUNT(amount) AS count_of_loans,
    SUM(amount) AS amount_of_loans
FROM loan
INNER JOIN account USING (account_id)
INNER JOIN disp USING (account_id)
INNER JOIN client USING (client_id)
INNER JOIN district ON client.district_id = district.district_id
WHERE status NOT IN ('B', 'D') AND type = 'OWNER'
GROUP BY A2);

# which area has the most clients,
SELECT
    area,
    number_of_clients
FROM area_report
ORDER BY number_of_clients DESC;
# in which area the highest number of loans was paid,
SELECT
    area,
    count_of_loans
FROM area_report
ORDER BY count_of_loans DESC;
# in which area the highest amount of loans was paid.
SELECT
    area,
    amount_of_loans
FROM area_report
ORDER BY amount_of_loans DESC;

# 7) Client analysis - part 3
SELECT
    area,
    amount_of_loans,
    amount_of_loans / SUM(amount_of_loans) OVER () AS percentage_total_amount
FROM area_report;

# 8) Selection - part 1

SELECT
    client_id,
    YEAR(birth_date) AS birth_year,
    SUM(amount - payments) AS account_balance,
    COUNT(loan_id) AS number_of_loans
FROM loan
INNER JOIN account USING (account_id)
INNER JOIN disp USING (account_id)
INNER JOIN client USING (client_id)
WHERE status NOT IN ('B', 'D') AND type = 'OWNER'
GROUP BY client_id
HAVING account_balance > 1000 AND number_of_loans > 5 AND birth_year > 1990;

# 9) Selection - part 2
SELECT
    birth_date
FROM client
ORDER BY birth_date DESC;
# There are no clients born after 1990

SELECT
    client_id,
    COUNT(loan_id) AS number_of_loans
FROM loan
INNER JOIN account USING (account_id)
INNER JOIN disp USING (account_id)
INNER JOIN client USING (client_id)
GROUP BY client_id
ORDER BY number_of_loans DESC;
# There is no client who has more than one loan

SELECT
    client_id,
    SUM(amount - payments) AS account_balance
FROM loan
INNER JOIN account USING (account_id)
INNER JOIN disp USING (account_id)
INNER JOIN client USING (client_id)
WHERE status NOT IN ('B', 'D') AND type = 'OWNER'
GROUP BY client_id
HAVING account_balance > 1000;
# There are clients with a balance over 1000

# 10) Expiring cards

# example current date - 2001-01-01 and creating the table
DROP TABLE IF EXISTS cards_at_expiration_dn;
CREATE TABLE cards_at_expiration_dn AS (
WITH card_to_expiration AS (
SELECT
    client_id,
    card_id,
    A3,
    issued,
    ADDDATE(issued, INTERVAL 3 YEAR) AS date_of_expiration,
    (SELECT ADDDATE(date_of_expiration, INTERVAL -7 DAY)) AS date_for_expiry_notification
FROM  card
INNER JOIN disp USING (disp_id)
INNER JOIN client USING (client_id)
INNER JOIN district USING (district_id)
)
SELECT
    client_id,
    card_id,
    A3,
    date_of_expiration
FROM card_to_expiration
WHERE date_for_expiry_notification <= '2000-01-01');


# procedure
DROP PROCEDURE IF EXISTS cards_to_expiration;
DELIMITER $$

CREATE PROCEDURE cards_to_expiration(IN c_date DATE)
BEGIN
    TRUNCATE cards_at_expiration_dn;
    INSERT INTO cards_at_expiration_dn
        WITH card_to_expiration AS (
        SELECT
            client_id,
            card_id,
            A3,
            issued,
            ADDDATE(issued, INTERVAL 3 YEAR) AS date_of_expiration,
            (SELECT ADDDATE(date_of_expiration, INTERVAL -7 DAY)) AS date_for_expiry_notification
        FROM  card
        INNER JOIN disp USING (disp_id)
        INNER JOIN client USING (client_id)
        INNER JOIN district USING (district_id)
        )
        SELECT
            client_id,
            card_id,
            A3,
            date_of_expiration
        FROM card_to_expiration
        WHERE date_for_expiry_notification <= c_date;

END $$
DELIMITER ;

# call the procedure
CALL cards_to_expiration('1998-01-01');

# test
SELECT * FROM cards_at_expiration_dn;