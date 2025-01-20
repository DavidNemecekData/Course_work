# exercise 1.1 - Display the data from sakila.rental giving aliases to columns according to the requirements:
# leave the columns rental_id, inventory_id, customer_id unchanged,
# change rental_date column to date_of_rental,
# change return_date column to date_of_rental_return,
# list the columns in the order of your choice.
SELECT
    rental_id,
    inventory_id,
    customer_id,
    rental_date AS date_of_rental,
    return_date AS date_of_rental_return
FROM sakila1_83.rental;

# exercise 1.2 - Display the data from sakila.rental and translate names of the following column from English to your language:
# rental_id
# inventory_id
# rental_date
# return_date
SELECT
    rental_id AS "číslo výpujčky",
    inventory_id AS "skladové číslo",
    rental_date AS "datum výpujčky",
    return_date AS "datum vrácení"
FROM sakila1_83.rental;

# exercise 2.1 - Formatting dates
# In the sakila.payment table there is information about payments made by the clients of the DVD rental store. Write a query to display the payment_date column in the following formats:
#
# 'year/month/day',
# 'year-name_of_month-day_of_week',
# 'year-number_of_week',
# 'year/month/day@day_of week_name',
# 'year/month/day@day_of_week_number'.

SELECT
    payment_date,
    DATE_FORMAT(payment_date, '%Y/%m/%d') AS 'year/month/day',
    DATE_FORMAT(payment_date, '%Y-%M-%D') AS 'year-name_of_month-day_of_week',
    DATE_FORMAT(payment_date, '%Y-%v') AS 'year-number_of_week',
    DATE_FORMAT(payment_date, '%Y/%m/%d & %W') AS 'year/month/day@day_of week_name',
    DATE_FORMAT(payment_date, '%Y/%m/%d & %w') AS 'year/month/day@day_of_week_number'
FROM sakila1_83.payment;

# exercise 3.1 - Format the payment_date column from the sakila.payment table according to the US standard.
# Call the created column: payment_date_usa_formatted

SELECT
    payment_date,
    DATE_FORMAT(payment_date, GET_FORMAT(DATE, 'USA')) AS 'payment_date_usa_formatted'
FROM sakila1_83.payment;

# exercise 4.1 - Using sakila.film_list, write and perform a query that:
# returns the lowest value in the columns: price, length,
SELECT
    price,
    length,
    LEAST(price, length) AS lowest
FROM sakila1_83.film_list;

# exercise 4.2 -returns the lowest value in the columns: price, length, rating.
SELECT
    price,
    length,
    rating,
    LEAST(price, length, rating) AS lowest
FROM sakila1_83.film_list;

# exercise 5.1 - Similar to the exercise on LEAST, based on sakila.film_list, write and perform a query that:
# returns the highest value in the columns: price, length,
SELECT
    price,
    length,
    GREATEST(price, length) AS greatest
FROM sakila1_83.film_list;

# exercise 5.2
SELECT
    price,
    length,
    rating,
    GREATEST(price, length, rating) AS greatest
FROM sakila1_83.film_list;

SELECT
    film_id,
    COALESCE(title, description)
FROM sakila1_83.film;
