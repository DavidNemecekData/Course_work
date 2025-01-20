# exercise 1.1 - There are three columns in the tasks.city_country table:
# city,
# country_id,
# country.
# At this point, the country column is empty;
# write the appropriate query and populate it using UPDATE.
#
# In addition, after executing your query, write another query that will check
# that this column has definitely been filled.

SELECT * from tasks1_83.city_country
WHERE country IS NULL;
SELECT * FROM sakila1_83.country;

UPDATE tasks1_83.city_country
LEFT JOIN sakila1_83.country
USING (country_id)
SET tasks1_83.city_country.country = sakila1_83.country.country
WHERE tasks1_83.city_country.country IS NULL;

# Příkaz od Tomáše:
 UPDATE
tasks1_83.city_country
INNER JOIN sakila1_83.country AS p
ON p.country_id = sakila1_83.country.country_id
SET tasks1_83.city_country.country = sakila1_83.country.country
WHERE tasks1_83.city_country.country IS NULL;

# exercise 2.1 - The table tasks.films_to_be_cleaned is a copy of the film table.
# We want to remove the movies that meet the following criteria:
# category_id in (1, 5, 7, 9),
# length is less than 1 hour,
# rating is not NC-17 or PG.
# Use JOIN to complete the exercise. After executing your query,
# write another one to check its correctness.
SELECT * FROM tasks1_83.films_to_be_cleaned;
SELECT * FROM sakila1_83.film_category;
# test
SELECT *
FROM tasks1_83.films_to_be_cleaned
LEFT JOIN sakila1_83.film_category USING (film_id)
WHERE category_id IN (1, 5, 7, 9)
AND films_to_be_cleaned.length < 60
AND films_to_be_cleaned.rating NOT IN ('NC-17', 'PG');
# query
DELETE tasks1_83.films_to_be_cleaned
FROM
    tasks1_83.films_to_be_cleaned
LEFT JOIN
        sakila1_83.film_category
USING (film_id)
WHERE category_id IN (1, 5, 7, 9)
AND films_to_be_cleaned.length < 60
AND films_to_be_cleaned.rating NOT IN ('NC-17', 'PG');

# Příkaz od Tomáše
DELETE tasks1_83.films_to_be_cleaned
FROM tasks1_83.films_to_be_cleaned
INNER JOIN sakila1_83.film_category
ON tasks1_83.films_to_be_cleaned.film_id = sakila1_83.film_category.film_id
WHERE
    category_id IN (1,5,7,9) AND
    length < 60 AND
    rating NOT IN ('NC-17', 'PG');

# exercise 3.1 - tasks.california_payments table is an empty copy of the sakila.payments table.
# Write a query that adds only the payments from the customers with addresses from California.
#
# Additionally, write a query that checks that customers available in the tasks.california_payments
# table, come only from this area.

SELECT * FROM tasks1_83.california_payments;
SELECT * FROM sakila1_83.payment;
SELECT * FROM sakila1_83.customer;
SELECT * FROM sakila1_83.address
WHERE district = 'California';

INSERT INTO tasks1_83.california_payments(
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date,
    last_update
)
SELECT
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date,
    payment.last_update
FROM sakila1_83.payment
INNER JOIN
    sakila1_83.customer
USING (customer_id)
INNER JOIN sakila1_83.address
USING (address_id)
WHERE district = 'California';

# řešení od Tomáše
INSERT INTO tasks1_83.california_payments (
      SELECT payment_records.*
      FROM sakila1_83.payment as payment_records
      INNER JOIN sakila1_83.customer ON payment.customer_id = customer.customer_id
      INNER JOIN sakila1_83.address ON customer.address_id = address.address_id
      WHERE district = 'California'
);

