# exercise 1.1 -
SELECT *
FROM sakila1_83.sales_by_store
WHERE total_sales > (
    SELECT sales_total.total_sales/2 FROM sakila1_83.sales_total
    );

# exercise 2.1 - Analyzing only the data structure, consider
# which row can determine statistics for all ratings (without rating division),
SELECT *
FROM sakila1_83.rating_analytics;
SELECT *
FROM sakila1_83.rating_analytics
WHERE rating IS NULL;

# exircise 2.2 - Find the ratings which are higher than the average for all movies, without rating division,
SELECT * FROM sakila1_83.rating_analytics
WHERE avg_rental_rate > (SELECT avg_rental_rate
                         FROM sakila1_83.rating_analytics
                         WHERE rating IS NULL);

# exercise 2.3 - Find the ratings where the renting time is shorter than the global average
SELECT * FROM sakila1_83.rating_analytics
WHERE rating_analytics.avg_rental_duration < (SELECT avg_rental_duration
                         FROM sakila1_83.rating_analytics
                         WHERE rating IS NULL);

# exercise 2.4 - Use a subquery to display the statistics for id_rating = 3
SELECT *
FROM sakila1_83.rating;

SELECT * FROM sakila1_83.rating_analytics
WHERE rating IN (
    SELECT rating FROM sakila1_83.rating
                  WHERE id_rating = 3
    );

# exercise 2.5 - Use a subquery to display the statistics for id_rating = 3, 2, 5
SELECT * FROM sakila1_83.rating_analytics
WHERE rating IN (
    SELECT rating FROM sakila1_83.rating
                  WHERE id_rating IN (3, 2, 5)
    );

# exercise 3.1 - Find the actor/actress with the name of ZERO and the surname: CAGE, display all statistics for their id,
SELECT * FROM sakila1_83.actor;
SELECT * FROM sakila1_83.actor_analytics;

SELECT * FROM sakila1_83.actor_analytics
WHERE actor_id IN (SELECT actor_id WHERE first_name = 'ZERO'
                                   AND last_name = 'CAGE');
SELECT * FROM sakila1_83.actor_analytics
         WHERE first_name = 'ZERO' AND last_name = 'CAGE';

# exercise 3.2 - Display actors who played in at least 30 films
SELECT first_name, last_name, films_amount FROM sakila1_83.actor_analytics
WHERE films_amount > 30;

# exercise 3.3 - Using the results from the previous point display all of their information from sakila.actor
WITH actors AS (SELECT actor_id FROM sakila1_83.actor_analytics
                                WHERE films_amount > 30)
SELECT * FROM sakila1_83.actor
WHERE actor_id IN (SELECT * FROM actors);

# exercise 3.4 - Find the actors who played in the movies with the
# length of (longest_movie_duration) of 184, 174, 176, 164,
SELECT first_name, last_name, longest_movie_duration FROM sakila1_83.actor_analytics
WHERE longest_movie_duration IN (184, 174, 176, 164);

# exercise 3.5 - Using the results from the previous subpoint, find these films
# in sakila.film (this will require more than one subquery)
SELECT title, length FROM sakila1_83.film
WHERE length IN (184, 174, 176, 164);


# exercise 4.1 - Write a query to display the films with the genres:
# Horror, Documentary, and Family with the rating of P or NC-17,
SELECT * FROM sakila1_83.film_list
WHERE category IN ('Horror', 'Documentary', 'Family')
AND (rating = 'NC-17' OR film_list.rating LIKE 'P%');

# exercise 4.2 - Using the results of the previous task and
# sakila.film_text, display the descriptions of these films.
SELECT title, description FROM sakila1_83.film_text
WHERE film_text.film_id IN (SELECT FID FROM sakila1_83.film_list
    WHERE category IN ('Horror', 'Documentary', 'Family')
    AND (rating = 'NC-17' OR film_list.rating LIKE 'P%'));

# exercise 4.3 - Sort sakila.film_list by the Category key - ascending; Price - descending
SELECT * FROM sakila1_83.film_list
ORDER BY category, price DESC;

# exercise 4.4 - Sort sakila.film_list by key Rating - ascending; Length - descending.
SELECT * FROM sakila1_83.film_list
ORDER BY rating, length DESC;




