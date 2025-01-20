# exercise 1.1 - about rentals from 2005
SELECT * from sakila1_83.rental
WHERE rental_date LIKE '2005%';
SELECT * FROM sakila1_83.rental
WHERE year(rental_date) = 2005;

# exercise 1.2 - about rentals from 2005-05-24
SELECT * from sakila1_83.rental
WHERE rental_date BETWEEN '2005-05-24 00:00:00' AND '2005-05-24 23:59:59';
SELECT * FROM sakila1_83.rental
WHERE DATE(rental_date) = '2005-05-24';

# exercise 1.3 - about rentals after 2005-06-30
SELECT * from sakila1_83.rental
WHERE rental_date > '2005-06-30 23:59:59';
SELECT * FROM sakila1_83.rental
WHERE DATE(rental_date) > '2005-06-30';

# exercise 2.1 - all active customers,
SELECT * from sakila1_83.customer
WHERE active = 1;

# exercise 2.2 - all active customers or those starting from ` ANDRE'
SELECT * from sakila1_83.customer
WHERE active = 1 AND (last_name LIKE 'ANDRE%') OR (first_name LIKE 'ANDRE%');

# exercise 3.1 - all inactive customers with store_id = 1
SELECT * FROM sakila1_83.customer
WHERE active = 0 AND store_id = 1;

# exercise 3.2 customers whose email address is in a domain different from sakilacustomer.org
SELECT * FROM sakila1_83.customer
WHERE email NOT LIKE '%sakilacustomer.org';

# exercise 3.3 - customers with unique values in the create_date column
SELECT DISTINCT create_date
FROM sakila1_83.customer;
SELECT * FROM sakila1_83.customer
WHERE create_date IN ('2006-02-14 22:04:36', '2006-02-14 22:04:37');

# exercise 4.1 - display actors who played in more than 25 films
SELECT * FROM sakila1_83.actor_analytics
WHERE films_amount > 25;

# exercise 4.2 - display actors who played in more than 20 films and whose average rating is above 3.3
SELECT * FROM sakila1_83.actor_analytics
WHERE films_amount > 20 AND avg_film_rate > 3.3;

# exercise 4.3 - display actors who played in more than 20 films and whose average rating is above 3.3
# or the income from rentals (actor_payload) is above 2000.
SELECT * FROM sakila1_83.actor_analytics
WHERE films_amount > 20 AND (
    avg_film_rate > 3.3 OR actor_payload > 2000
    );
