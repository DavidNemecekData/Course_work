# exercise 1.1 - Using ROW_NUMBER and appropriate date values create
# a calendar table in the database, that:
#
# will start from '2000-01-01',
# will end on '2030-12-31'.
# The calendar table should have the following columns:
#
# date (date),
# year (date_year),
# month (date_month),
# day (date_day),
# number of day of week (day_of_week),
# number of week in the year (week_of_year),
# date of generating the calendar (last_update).

SELECT DATEDIFF('2030-12-31', '2000-01-01') AS date_diff;

SELECT
    ADDDATE('2000-01-01', ROW_NUMBER() over ()) AS date
FROM sakila1_83.payment
LIMIT 11323;

WITH calendar AS(
    SELECT
    ADDDATE('2000-01-01', ROW_NUMBER() over ()) AS date
    FROM sakila1_83.payment
    LIMIT 11323
)
SELECT
    date,
    EXTRACT(YEAR FROM date) as YEAR,
    EXTRACT(MONTH FROM date) as MONTH,
    EXTRACT(DAY FROM date) as DAY,
    DAYOFWEEK(date) as DAY_OF_WEEK,
    WEEKOFYEAR(date) as WEEK_OF_YEAR,
    NOW()
FROM calendar;

# exercise 2.1 - Payments
# Using the payment table, create a view that displays the following summaries:
#
# sum of payments in one year - name the column payment_year,
# sum of payments per month - name the column payment_month,
# total amount of payments.
# Additionally, take care to display the result in a logical way using ORDER BY.

SELECT * FROM sakila1_83.payment;

SELECT
    EXTRACT(YEAR FROM payment_date) AS year,
    EXTRACT(MONTH FROM payment_date) AS month,
    SUM(amount) AS amount
FROM sakila1_83.payment
GROUP BY year, month
WITH ROLLUP;


SELECT
    EXTRACT(year from payment_date) as payment_year,
    EXTRACT(month from payment_date) as payment_month,
    SUM(amount) as amount
FROM sakila1_83.payment
GROUP BY 1, 2 WITH ROLLUP;