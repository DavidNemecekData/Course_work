# exercise 1.1 - Names in SakilaDB - Using tables:
# sakila.customer,
# sakila.actor,
# sakila.staff,
# display everybody's first name without repetitions.

SELECT first_name, 'customer' AS category
FROM sakila1_83.customer
UNION
SELECT first_name, 'actor' AS category
FROM sakila1_83.actor
UNION
SELECT staff.first_name, 'staff' AS category
FROM sakila1_83.staff;

# exercise 2.1
SELECT category
FROM sakila1_83.nicer_but_slower_film_list
UNION
SELECT category
FROM sakila1_83.nicer_but_slower_film_list;

SELECT DISTINCT category
FROM sakila1_83.nicer_but_slower_film_list;


