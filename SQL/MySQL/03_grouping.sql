# exercise 1.1 - Aggregate the payment table according to the following rules:
# determine the total amount of rental shop's income,

SELECT
    staff_id,
    sum(amount) as amount
FROM sakila1_83.payment
GROUP BY staff_id
ORDER BY amount DESC;

# exercise 1.2 - determine the total amount of rental shop's
# income divided by customers (for now don't use JOIN, only customer_id)

SELECT
    customer_id,
    sum(amount) as amount
FROM sakila1_83.payment
GROUP BY customer_id
ORDER BY amount DESC;

# exercise 1.3 - determine the total amount of rented films per employee,

SELECT
    staff_id,
    count(rental_id) as amount
FROM sakila1_83.payment
GROUP BY staff_id
ORDER BY amount DESC;

# exercise 1.4 - using date_format function, do subpoints 2 and 3.
# split by months and sort the results by the keys:
# client_id/staff_id ascending, amount - descending.

SELECT
    DATE_FORMAT(payment_date, '%Y-%c') as date
FROM sakila1_83.payment;
#1.2
SELECT
    customer_id,
    DATE_FORMAT(payment_date, '%Y-%c') as date,
    sum(amount) as amount
FROM sakila1_83.payment
GROUP BY customer_id, date
ORDER BY
    customer_id ASC,
    amount DESC;
#1.3
SELECT
    staff_id,
    DATE_FORMAT(payment_date, '%Y-%c') as date,
    count(rental_id) as amount
FROM sakila1_83.payment
GROUP BY staff_id, date
ORDER BY
    staff_id ASC,
    amount DESC;

# exercise 2.1 - Payment report
# Using the appropriate tables from the sakila database,
# prepare a payment report showing the following information:
# client's name, sakila1_83.customer
# client's surname, sakila1_83.customer
# client's email, sakila1_83.customer
# amount of payments, sakila1_83.payment
# number of payments, sakila1_83.payment
# average payment amount, sakila1_83.payment
# date of last payment. sakila1_83.payment
# Save the query result to a database; use a view.
# How do you check if your query is correct? Write appropriate query/queries.

SELECT * FROM sakila1_83.payment;
SELECT * FROM sakila1_83.customer;

CREATE VIEW sakila1_83.payment_report_dn AS
SELECT
    first_name,
    last_name,
    email,
    sum(amount) as total_payment_amount,
    avg(amount) as average_payments_amount,
    count(payment_id) as number_of_payments,
    max(payment_date) as last_payment
FROM sakila1_83.payment
LEFT JOIN sakila1_83.customer
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id, first_name, last_name, email;

# exercise 3.1 - Most profitable film (part 1) - Number of actors in a film
# Write a query that returns the following information:
# film id,
# film title,
# number of actors playing in the film.
# Save the results to a temporary table, e.g. tmp_film_actors.
# Additionally, write a query to verify your query.

CREATE TEMPORARY TABLE tasks1_83.tmp_film_actors_dn AS
SELECT
    film_id,
    title,
    actors,
    count(actor_id) as number_of_actors
FROM sakila1_83.film_analytics
LEFT JOIN sakila1_83.film_actor
USING (film_id)
GROUP BY film_id, title, actors;

# exercise 4.1 - Most profitable film (part 2) - Number of film rentals
# Write a query that returns:
# film id,
# film title,
# number of film rentals.
# Save the results to a temporary table, e.g. tmp_film_rentals.
# Additionally, write a query that you can use to verify your solution.

CREATE TEMPORARY TABLE tasks1_83.tmp_film_rentals_dn AS
SELECT
    film_id,
    title,
    rentals
FROM sakila1_83.film_analytics;


# exercise 5.1 - Most profitable film (part 3) - Income by film
# Write a query that will return the amount of contributions from a movie in the following format:
# film id, the amount of payments from the film.
# Save the results to a temporary table, e.g. tmp_film_actors.
# Remember to test your solution.
# Hint for testing: Check if all rental_id are filled
CREATE TEMPORARY TABLE tasks1_83.tmp_film_income_dn AS
SELECT
        film_id,
        SUM(amount) AS income
    FROM sakila1_83.inventory
    INNER JOIN sakila1_83.rental ON inventory.inventory_id = rental.inventory_id
    INNER JOIN sakila1_83.payment ON rental.rental_id = payment.rental_id
    GROUP BY film_id;

# exercise 6.1 - Most profitable film (summary)
# Prepare a report that displays the top 10 most rented films.
# Make the following business assumptions to prepare the report:
# film title,
# number of actors who played in it,
# the amount of revenue of the film,
# number of film rentals.

SELECT
    film.title,
    number_of_actors,
    income,
    rentals
FROM tasks1_83.tmp_film_actors_dn AS film
INNER JOIN tasks1_83.tmp_film_rentals_dn USING(film_id)
INNER JOIN tasks1_83.tmp_film_income_dn USING(film_id)
ORDER BY income DESC
LIMIT 10;
