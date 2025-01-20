# exercise 1.1 - Actors ranking
# Write a query that will create a ranking of actors based on the average
# rating from the movies they played in. To do the exercise assume the following:

# use the actor_analytics view,
# use the ROW_NUMBER() function to create the ranking.
# Sort the actors from the best to the worst, e.g.: 1 - highest rating.
#
# Additionally, review the table and see how rows that have the same values are treated.

SELECT
    actor_id,
    avg_film_rate,
    ROW_NUMBER() over (ORDER BY avg_film_rate DESC ) as rn
FROM sakila1_83.actor_analytics;

SELECT
    actor_id,
    first_name,
    last_name,
    avg_film_rate,
    ROW_NUMBER() over (rate_window) AS rn
FROM sakila1_83.actor_analytics
WINDOW rate_window AS (ORDER BY avg_film_rate DESC);

# exercise 2.1 - Cumulative sum
# Cumulative sum (often shortened to cumsum), as the name suggests,
# refers to the cumulative amount; window functions let us count according to
# a specified order: this is done using the ORDER BY clause.
#
# In a sense ROW_NUMBER() was already an example
# of a cumsum regarding the count of elements in a partition.
# In statistics this approach can be used to determine e.g.
# a cumulative distribution function
#
# Our task is going to be to write a clause that determines the following accumulating values.
#
# MIN for avg_film_rate,
# SUM for actor_payload,
# MAX for longest_movie_duration.
# Use actor_id as a sorting key - ascending.
SELECT * FROM sakila1_83.actor_analytics;

SELECT
    actor_id,
    first_name,
    last_name,
    MIN(avg_film_rate) OVER (actor_window),
    SUM(actor_payload) OVER (actor_window),
    MAX(longest_movie_duration) OVER (actor_window),
    ROW_NUMBER() over (actor_window) AS rn
FROM sakila1_83.actor_analytics
WINDOW actor_window AS (ORDER BY actor_id ASC);

# exercise 3.1 - Pareto principle
# Pareto principle In short states that 20% of the society holds 80% of wealth.
# In the context of a video rental company, we want to perform a similar analysis -
# to do this we will use window functions. Let's once again use the actor data
# from the actor_analytics view and check what % of actors is responsible for what % of
# income of the rental shop.
#
# How should we approach this task?
#
# Create a window function using ROW_NUMBER,
# Using COUNT and a empty window (OVER ()) count the number of rows in the table,
# Dividing point 1./2. you are going to get an
# increasing sequence representing the % of actors,
# Use your knowledge from subpoints 1-3, to do the calculation for the % of income.
# Make an interpretation of the query results for a sample actor.
# How should we approach this task?

SELECT
    actor_id,
    first_name,
    last_name,
    actor_payload,
    ROW_NUMBER() over (ORDER BY actor_payload DESC) AS actor_rank,
    COUNT(actor_id) OVER () AS total_actors,
    (ROW_NUMBER() over (ORDER BY actor_payload DESC) * 100.0 / COUNT(*) OVER ()) AS actor_percentage,
FROM sakila1_83.actor_analytics;

SELECT
    actor_id,
    first_name,
    last_name,
    actor_payload,
    ROW_NUMBER() OVER (payload) / COUNT(1) OVER () as count_percent,
    SUM(actor_payload) OVER (payload)  / SUM(actor_payload) OVER () as payload_percent
FROM sakila1_83.actor_analytics
WINDOW payload AS (ORDER BY actor_payload DESC);

# exercise 3.1 - Ranking
# Using RANK, DENSE_RANK and ROW_NUMBER, create a ranking of the movies by number of rentals.
# Notice the results of each function.
# When you do this exercise, add a partition according to rating.
# In this exercise you can use the sakila.film_analytics table.

SELECT
    film_id,
    title,
    rentals,
    RANK() over (rank_window) AS rnk,
    DENSE_RANK() over (rank_window) AS drn,
    ROW_NUMBER() over (rank_window) AS rn
FROM sakila1_83.film_analytics
WINDOW rank_window AS (ORDER BY rentals DESC);