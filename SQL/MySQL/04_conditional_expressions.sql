# exercise 1.1 - Using the actor_analyticstable write
# a query that groups actors according to the following criteria:
#
# if avg_film_rate < 2 - 'poor acting',
# if avg_film_rate is between 2 and 2.5 - 'fair acting',
# if avg_film_rate is between 2.5 and 3.5 - 'good acting',
# if avg_film_rate is above 3.5 - 'superb acting.

# Call the column created this way: acting_level and use it in an analysis that calculates:
# 1 - number of occurrences in each group,
# 2 - the total revenue of each group,
# 3 - number of films in each group,
# 4 - the average rating in a group.

# Hint: Do the exercise in two steps:
# Write a subquery that creates an acting_level column,
# Based on the results from the previous subpoint, do the rest of the exercise.

WITH acting_level_table AS (SELECT actor_id, avg_film_rate, actor_payload, films_amount,
                             CASE
                                 WHEN avg_film_rate < 2 THEN 'poor acting'
                                 WHEN avg_film_rate BETWEEN 2 AND 2.5 THEN 'fair acting'
                                 WHEN avg_film_rate BETWEEN 2.5 AND 3.5 THEN 'good acting'
                                 WHEN avg_film_rate > 3.5 THEN 'superb acting'
                                 ELSE 'error'
                                 END AS acting_level
                      FROM sakila1_83.actor_analytics)
SELECT
    acting_level,
    COUNT(acting_level) AS number_of_occurrence,
    SUM(actor_payload) AS total_revenue,
    SUM(films_amount) AS number_of_films,
    AVG(avg_film_rate) AS average_rating
FROM acting_level_table
GROUP BY acting_level;


# exercise 2.1 - Film duration
# Write a procedure that, based on the duration of the film (i.e. length column from film),
# assigns the record to one of the groups below:
#
# very short - film up to 1h,
# short - film up to 1.5h,
# normal - film up to 2h,
# long - film up to 2.5h,
# very long - film over 2.5h.
# Call the procedure film_classification.
#
# Hint:
# In this exercise, for now, we will not query any table.
# We will pass film duration as a procedure parameter.
SELECT * FROM sakila1_83.film;


DROP PROCEDURE IF EXISTS film_classification;
DELIMITER $$
CREATE PROCEDURE film_classification(IN length INT)
BEGIN
    DECLARE length_classification VARCHAR(20);
    IF length < 60 THEN
        SET length_classification = 'very short';
    ELSEIF length BETWEEN 60 AND 90 THEN
        SET length_classification = 'short';
    ELSEIF length BETWEEN 90 AND 120 THEN
        SET length_classification = 'normal';
    ELSEIF length BETWEEN 120 AND 150 THEN
        SET length_classification = 'long';
    ELSEIF length BETWEEN 150 AND 180 THEN
        SET length_classification = 'very long';
    ELSE
        SET length_classification = 'error';
    END IF;

    SELECT length_classification;
END $$
DELIMITER ;

CALL film_classification(100);
# Proceduru nemohu dát přímo do Selectu, tam lze umístit pouze funkci.

# exercise 3.1 - Payment amount
# Write a query that groups the payments according to the following classification:
#
# fee - payments below 2,
# regular - all others.
# Use the payment table to complete the exercise.
#
# Group the result and use SQL to find out what percent of the total payments were the fees.

WITH payment_class AS (
    SELECT
    *,
    IF(amount < 2, 'Fee', 'Regular') AS payment_classification
FROM sakila1_83.payment
)
SELECT
    payment_classification,
    SUM(amount) / SUM(SUM(amount)) OVER () AS payment_class_share
FROM payment_class
GROUP BY payment_classification;

