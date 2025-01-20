# exercise 1.1 - Write a query that generates a report on:
# the store's total sales and its employees,
# the store's total sales (no division by employee),
# total sales.
# Additionally – choose your own way to sort rows.


SELECT * FROM sakila1_83.inventory;
SELECT * FROM sakila1_83.payment;
SELECT * FROM sakila1_83.store;

SELECT
    staff_id,
    store_id,
    sum(amount)
FROM sakila1_83.payment
INNER JOIN sakila1_83.store
ON sakila1_83.payment.staff_id = sakila1_83.store.manager_staff_id
GROUP BY staff_id, store_id
WITH ROLLUP;

# exercise 2.1 - ROLLUP and HAVING
# determines the sum of payments divided by client and by employee,
# determines the sum of payments per client,
# determines the sum of payments.

# Do two versions of the exercise:
# Using only ROLLUP,
# Adding the HAVING clause to the GROUP BY for payments above 70.
# How are the results of the queries different?
# To make it easier to notice the difference,
# do the exercise only for the first 3 customers (customer_id < 4).

SELECT
    customer_id,
    staff_id,
    sum(amount) as payments
FROM sakila1_83.payment
WHERE customer_id < 4
GROUP BY customer_id, staff_id
WITH ROLLUP;

SELECT
    customer_id,
    staff_id,
    sum(amount) as payments
FROM sakila1_83.payment
WHERE customer_id < 4
GROUP BY customer_id, staff_id
WITH ROLLUP
HAVING payments > 70;