USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from director_mapping;
select count(*) from genre;
select count(*) from movie;
select count(*) from names;
select count(*) from ratings;
select count(*) Total_Number_of_Rows from role_mapping;








-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT *
FROM movie
WHERE id IS NULL
   OR title IS NULL
   OR year IS NULL
   OR date_published IS NULL
   or duration IS NULL
   OR country IS NULL
   OR worlwide_gross_income IS NULL
   OR languages IS NULL
   OR production_company IS NULL;
   








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT YEAR(DATE_PUBLISHED) AS Year,
       COUNT(*) AS number_of_movies
FROM movie
GROUP BY YEAR(DATE_PUBLISHED)
ORDER BY Year;

 SELECT 
       MONTH(DATE_PUBLISHED) AS Month,
       COUNT(*) AS number_of_movies
FROM movie
GROUP BY  MONTH(DATE_PUBLISHED)
ORDER BY  Month;  









/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) AS movies_produced
FROM movie
WHERE (country = 'USA' or country = 'India')
  AND YEAR(date_published) = 2019;











/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, COUNT(*) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC;










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*)
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1
) AS single_genre_movies;










/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, AVG(m.duration) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre;








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH GenreCounts AS (
    SELECT 
        g.genre,
        COUNT(m.id) AS movie_count
    FROM 
        genre g
    JOIN 
        movie m ON g.movie_id = m.id
    GROUP BY 
        g.genre
),
RankedGenres AS (
    SELECT 
        genre,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
    FROM 
        GenreCounts
)
SELECT 
    genre,
    movie_count,
    genre_rank
FROM 
    RankedGenres
WHERE 
    genre = 'thriller';










/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM 
    ratings;






    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH RankedMovies AS (
    SELECT 
        m.title,
        r.avg_rating,
        RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank,
        dense_rank() over (order by r.avg_rating desc) as movie_dense_rank
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
)
SELECT 
    title,
    avg_rating,
    movie_rank,
    movie_dense_rank
FROM 
    RankedMovies
WHERE 
    movie_rank <= 10;








/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating,
    COUNT(movie_id) AS movie_count
FROM 
    ratings
GROUP BY 
    median_rating
ORDER BY 
    median_rating;










/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH HitMovies AS (
    SELECT 
        m.production_company,
        COUNT(m.id) AS movie_count
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
    WHERE 
        r.avg_rating > 8
    GROUP BY 
        m.production_company
),
RankedProductionCompanies AS (
    SELECT 
        production_company,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS prod_company_rank
    FROM 
        HitMovies
)
SELECT 
    production_company,
    movie_count,
    prod_company_rank
FROM 
    RankedProductionCompanies
WHERE 
    prod_company_rank = 1;






-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre,
    COUNT(m.id) AS movie_count
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
JOIN 
    genre g ON m.id = g.movie_id
WHERE 
    m.date_published BETWEEN '2017-03-01' AND '2017-03-31'
    AND m.country = 'USA'
    AND r.total_votes > 1000
GROUP BY 
    g.genre
ORDER BY 
    movie_count DESC;









-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
    m.title,
    r.avg_rating,
    g.genre
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
JOIN 
    genre g ON m.id = g.movie_id
WHERE 
    m.title LIKE 'The%'
    AND r.avg_rating > 8
ORDER BY 
    m.title;









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(*)
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND r.median_rating = 8;









-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT m.country, SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.country IN ('Germany', 'Italy')
GROUP BY m.country;








-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;








/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genres AS (
    SELECT g.genre
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
),
top_movies AS (
    SELECT m.id, g.genre
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8
      AND g.genre IN (SELECT genre FROM top_genres)
),
top_directors AS (
    SELECT d.name_id, COUNT(*) AS movie_count, g.genre
    FROM director_mapping d
    JOIN top_movies tm ON d.movie_id = tm.id
    JOIN genre g ON tm.id = g.movie_id
    GROUP BY d.name_id, g.genre
    ORDER BY movie_count DESC
)
SELECT n.name AS director_name, td.movie_count
FROM top_directors td
JOIN names n ON td.name_id = n.id
ORDER BY td.movie_count DESC
LIMIT 3;









/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_rated_movies AS (
    SELECT movie_id
    FROM ratings
    WHERE median_rating >= 8
),
actor_movie_counts AS (
    SELECT rm.name_id, COUNT(*) AS movie_count
    FROM role_mapping rm
    JOIN top_rated_movies trm ON rm.movie_id = trm.movie_id
    GROUP BY rm.name_id
    ORDER BY movie_count DESC
)
SELECT n.name AS actor_name, amc.movie_count
FROM actor_movie_counts amc
JOIN names n ON amc.name_id = n.id
ORDER BY amc.movie_count DESC
LIMIT 2;








/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_votes AS (
    SELECT m.production_company, SUM(r.total_votes) AS vote_count
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY m.production_company
),
ranked_prod_votes AS (
    SELECT pv.production_company, pv.vote_count, ROW_NUMBER() OVER (ORDER BY pv.vote_count DESC) AS prod_comp_rank
    FROM prod_votes pv
)
SELECT rp.production_company, rp.vote_count, rp.prod_comp_rank
FROM ranked_prod_votes rp
WHERE rp.prod_comp_rank <= 3;











/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH indian_movies AS (
    SELECT m.id AS movie_id, m.country, r.total_votes, r.avg_rating
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.country = 'India'
),
actor_ratings AS (
    SELECT rm.name_id, im.movie_id, im.total_votes, im.avg_rating
    FROM role_mapping rm
    JOIN indian_movies im ON rm.movie_id = im.movie_id
),
actor_stats AS (
    SELECT ar.name_id, COUNT(*) AS movie_count, SUM(ar.total_votes) AS total_votes,
           SUM(ar.total_votes * ar.avg_rating) / SUM(ar.total_votes) AS actor_avg_rating
    FROM actor_ratings ar
    GROUP BY ar.name_id
    HAVING COUNT(*) >= 5
),
ranked_actors AS (
    SELECT as_alias.name_id, as_alias.total_votes, as_alias.movie_count, as_alias.actor_avg_rating,
           ROW_NUMBER() OVER (ORDER BY as_alias.actor_avg_rating DESC, as_alias.total_votes DESC) AS actor_rank
    FROM actor_stats as_alias
)
SELECT n.name AS actor_name, ra.total_votes, ra.movie_count, ra.actor_avg_rating, ra.actor_rank
FROM ranked_actors ra
JOIN names n ON ra.name_id = n.id
ORDER BY ra.actor_rank;











-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH ActressMovies AS (
    SELECT 
        n.name AS actress_name,
        m.id AS movie_id,
        r.total_votes,
        r.avg_rating
    FROM 
        role_mapping rm
    JOIN 
        names n ON rm.name_id = n.id
    JOIN 
        movie m ON rm.movie_id = m.id
    JOIN 
        ratings r ON m.id = r.movie_id
    WHERE 
        rm.category = 'Actress'
        AND m.country = 'India'
),
ActressStats AS (
    SELECT
        actress_name,
        COUNT(movie_id) AS movie_count,
        SUM(total_votes) AS total_votes,
        SUM(avg_rating * total_votes) / SUM(total_votes) AS actress_avg_rating
    FROM
        ActressMovies
    GROUP BY
        actress_name
    HAVING
        COUNT(movie_id) >= 3
),
RankedActresses AS (
    SELECT
        actress_name,
        total_votes,
        movie_count,
        actress_avg_rating,
        ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
    FROM
        ActressStats
)
SELECT
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM
    RankedActresses
WHERE
    actress_rank <= 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT
    m.title,
    r.avg_rating,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS classification
FROM
    movie m
JOIN
    genre g ON m.id = g.movie_id
JOIN
    ratings r ON m.id = r.movie_id
WHERE
    g.genre = 'Thriller'
ORDER BY
    r.avg_rating DESC;









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH GenreDurations AS (
    SELECT
        g.genre,
        AVG(m.duration) AS avg_duration
    FROM
        genre g
    JOIN
        movie m ON g.movie_id = m.id
    GROUP BY
        g.genre
),
RunningTotals AS (
    SELECT
        genre,
        avg_duration,
        SUM(avg_duration) OVER (PARTITION BY genre ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_duration,
        AVG(avg_duration) OVER (PARTITION BY genre ORDER BY genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_duration
    FROM
        GenreDurations
)
SELECT
    genre,
    avg_duration,
    running_total_duration,
    moving_avg_duration
FROM
    RunningTotals
ORDER BY
    genre;









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Step 1: Find the top 3 genres with the most number of movies



-- Top 3 Genres based on most number of movies
WITH GenreCounts AS (
    SELECT genre, COUNT(*) AS genre_count
    FROM genre
    GROUP BY genre
    ORDER BY genre_count DESC
    LIMIT 3
),
TopGenres AS (
    SELECT g.genre, m.id AS movie_id, m.title, m.year
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    WHERE g.genre IN (SELECT genre FROM GenreCounts)
),
RankedMovies AS (
    SELECT 
        genre,
        year,
        title AS movie_name,
        worldwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY genre, year ORDER BY worldwide_gross_income DESC) AS movie_rank
    FROM TopGenres
)
SELECT 
    genre,
    year,
    movie_name,
    movie_rank
FROM RankedMovies
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank;











-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Step 1: Identify multilingual movies and filter movies with median rating >= 8
WITH MultilingualHits AS (
    SELECT
        m.production_company,
        m.id AS movie_id
    FROM
        movie m
    JOIN
        ratings r ON m.id = r.movie_id
    WHERE
        r.median_rating >= 8
        AND m.languages LIKE '%,%' -- Assuming languages are stored as a comma-separated string
),

-- Step 2: Count the number of hits for each production house
ProductionHouseHits AS (
    SELECT
        production_company,
        COUNT(movie_id) AS movie_count
    FROM
        MultilingualHits
    GROUP BY
        production_company
),

-- Step 3: Rank the production houses based on the count of hits
RankedProductionHouses AS (
    SELECT
        production_company,
        movie_count,
        ROW_NUMBER() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM
        ProductionHouseHits
)

-- Step 4: Select the top two production houses
SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM
    RankedProductionHouses
WHERE
    prod_comp_rank <= 2
ORDER BY
    prod_comp_rank;








-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Step 1: Identify Super Hit drama movies (average rating > 8)
-- Step 1: Identify Super Hit drama movies (average rating > 8)
WITH SuperHitDramaMovies AS (
    SELECT
        m.id AS movie_id,
        m.title,
        r.avg_rating
    FROM
        movie m
    JOIN
        ratings r ON m.id = r.movie_id
    JOIN
        genre g ON m.id = g.movie_id
    WHERE
        r.avg_rating > 8
        AND g.genre = 'drama'
),

-- Step 2: Find actresses who acted in these Super Hit drama movies
SuperHitDramaActresses AS (
    SELECT
        shdm.movie_id,
        n.name AS actress_name
    FROM
        SuperHitDramaMovies shdm
    JOIN
        role_mapping rm ON shdm.movie_id = rm.movie_id
    JOIN
        names n ON rm.name_id = n.id
    WHERE
        rm.category = 'actress'
),

-- Step 3: Count the number of Super Hit movies each actress has acted in and calculate total votes
ActressSuperHitCount AS (
    SELECT
        shda.actress_name,
        COUNT(shda.movie_id) AS movie_count,
        SUM(r.avg_rating) AS actress_avg_rating
    FROM
        SuperHitDramaActresses shda
    JOIN
        ratings r ON shda.movie_id = r.movie_id
    GROUP BY
        shda.actress_name
),

-- Step 4: Rank the actresses based on the number of Super Hit movies
RankedActresses AS (
    SELECT
        actress_name,
        movie_count,
        actress_avg_rating,
        ROW_NUMBER() OVER (ORDER BY movie_count DESC, actress_avg_rating DESC) AS actress_rank
    FROM
        ActressSuperHitCount
)

-- Step 5: Select the top 3 actresses
SELECT
    ra.actress_name,
    SUM(r.total_votes) AS total_votes,
    ra.movie_count,
    ra.actress_avg_rating / ra.movie_count AS actress_avg_rating,
    ra.actress_rank
FROM
    RankedActresses ra
JOIN
    SuperHitDramaActresses shda ON ra.actress_name = shda.actress_name
JOIN
    ratings r ON shda.movie_id = r.movie_id
WHERE
    ra.actress_rank <= 3
GROUP BY
    ra.actress_name,
    ra.movie_count,
    ra.actress_avg_rating,
    ra.actress_rank
ORDER BY
    ra.actress_rank;








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH DirectorMovieCount AS (
    SELECT dm.name_id AS director_id,
           n.name AS director_name,
           COUNT(dm.movie_id) AS number_of_movies
    FROM director_mapping dm
    JOIN names n ON dm.name_id = n.id
    GROUP BY dm.name_id, n.name
    ORDER BY COUNT(dm.movie_id) DESC
    LIMIT 9
),

DirectorMovieDetails AS (
    SELECT dm.name_id AS director_id,
           MIN(m.date_published) AS first_movie_date,
           MAX(m.date_published) AS last_movie_date,
           COUNT(dm.movie_id) - 1 AS movie_intervals,
           AVG(r.avg_rating) AS avg_rating,
           SUM(r.total_votes) AS total_votes,
           MIN(r.avg_rating) AS min_rating,
           MAX(r.avg_rating) AS max_rating,
           SUM(m.duration) AS total_duration
    FROM director_mapping dm
    JOIN movie m ON dm.movie_id = m.id
    JOIN ratings r ON dm.movie_id = r.movie_id
    GROUP BY dm.name_id
),

AverageInterMovieDays AS (
    SELECT director_id,
           CASE WHEN movie_intervals > 0 THEN DATEDIFF(last_movie_date, first_movie_date) / movie_intervals ELSE 0 END AS avg_inter_movie_days
    FROM DirectorMovieDetails
)

SELECT dmc.director_id,
       dmc.director_name,
       dmc.number_of_movies,
       COALESCE(aimd.avg_inter_movie_days, 0) AS avg_inter_movie_days,
       COALESCE(dmd.avg_rating, 0) AS avg_rating,
       COALESCE(dmd.total_votes, 0) AS total_votes,
       COALESCE(dmd.min_rating, 0) AS min_rating,
       COALESCE(dmd.max_rating, 0) AS max_rating,
       COALESCE(dmd.total_duration, 0) AS total_duration
FROM DirectorMovieCount dmc
LEFT JOIN AverageInterMovieDays aimd ON dmc.director_id = aimd.director_id
LEFT JOIN DirectorMovieDetails dmd ON dmc.director_id = dmd.director_id;








