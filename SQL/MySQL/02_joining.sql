# exercise 1.1 - Write a join for rental and payment tables.
# Display only the following columns:
# payment_id,
# rental_id,
# amount,
# rental_date,
# payment_date.
SELECT
    payment_id,
    rental.rental_id,
    amount,
    rental_date,
    payment_date
FROM sakila1_83.rental
INNER JOIN sakila1_83.payment
ON rental.rental_id = payment.rental_id;

# exercise 2.1 - Write a query that joins the rental and
# inventory tables and displays the following columns:
# inventory_id,
# rental_id,
# film_id.

SELECT
    inventory_id,
    rental_id,
    film_id
FROM sakila1_83.rental
INNER JOIN
    sakila1_83.inventory
USING (inventory_id);

# exercise 3.1 - Write a query that joins the film and
# inventory tables and displays the following columns:
# inventory_id,
# film_id,
# title,
# description,
# release_year.
SELECT
    inventory_id,
    inventory.film_id,
    title,
    description,
    release_year
FROM sakila1_83.inventory
LEFT JOIN
    sakila1_83.film
ON inventory.film_id = film.film_id;

# exercise 4.1 - Rental report Using the queries and the joining method from the previous tasks,
# write a query that returns the following information about the rental:
# rental id,
# film id,
# film title,
# film description,
# film rating,
# rental rating,
# rental date,
# payment date,
# payment amount.
SELECT
    rental.rental_id,
    inventory.film_id,
    title AS film_title,
    description AS film_description,
    rating AS film_rating,
    rental_date,
    payment_date,
    amount
FROM sakila1_83.film
INNER JOIN
    sakila1_83.inventory
ON film.film_id = inventory.film_id
INNER JOIN
    sakila1_83.rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN
    sakila1_83.payment
ON rental.rental_id = payment.rental_id;

# exercise 5.1 - Using tasks.payment and sakila.rental tables
# find unpaid rentals (those with no payment).
WITH joined_tables AS (
    SELECT
        payment_id,
        rental.customer_id AS customer_ID,
        rental.staff_id AS staff_ID,
        rental.rental_id AS rental_ID,
        inventory_id,
        amount,
        rental_date,
        return_date,
        payment_date,
        payment.last_update AS last_update
    FROM tasks1_83.payment
             INNER JOIN
        sakila1_83.rental
             ON rental.rental_id = payment.rental_id
    )
SELECT * FROM joined_tables
WHERE amount = 0;

# sprváně je spíše toto
SELECT *
FROM tasks1_83.payment RIGHT JOIN sakila1_83.rental USING(rental_id)
WHERE tasks1_83.payment.payment_id IS NULL;
;




