USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
SHOW TABLES;
DESCRIBE movie ;
DESCRIBE genre;


-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT count(*)
FROM movie;
-- Total Number of Rows =  7997

SELECT count(*)
FROM genre;
-- Total Number of Rows = 14662

SELECT count(*)
FROM director_mapping;
-- Total Number of Rows = 3867

SELECT count(*)
FROM names;
-- Total Number of Rows= 25735

SELECT COUNT(*) FROM  ROLE_MAPPING;
-- Total Number of Rows = '15615'

-- Q2. Which columns in the movie table have null values?
-- Type your code below:


SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_null_count,
           Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_null_count,
           Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_null_count,
           Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_null_count,
           Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_null_count,
           Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_null_count,
           Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_null_count,
           Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_null_count,
           Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_null_count
FROM movie;

/* OUTPUT
 0	0	0	0	0	20	3724	194	528
-- 4 columns have null values
*/


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
-- Movie released each year
SELECT year,
		count(title) as number_of_movies
FROM movie
GROUP BY year;

/* OUTPUT  	  year   No_of_movies
                  2017		3052
                  2018		2944
			      2019		2001    */ 
                  
-- Movies released month wise

select month(date_published) as month_num,
		COUNT(*) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

/*  OUTPUT
	month_num  No_of_movies
		1		804
		2		640
		3		824
		4		680
		5		625
		6		580
		7		493
		8		678
		9		809
		10		801
		11		625
		12		438
		*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%India%'
          OR country LIKE '%USA%' )
       AND year = 2019; 
       
/* OUTPUT 	 year    No_of_movies
			'2019'     '1059'
 */  

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT distinct genre
FROM genre;
/*
 genre
'Thriller'
'Sci-Fi'
'Romance'
'Others'
'Mystery'
'Horror'
'Fantasy'
'Family'
'Drama'
'Crime'
'Comedy'
'Adventure'
'Action'
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, count(m.id) AS Number_of_Movies
FROM movie m
INNER JOIN genre g
on m.id=g.movie_id
GROUP BY genre
Order By Number_of_Movies desc;

-- Genre category 'Drama' has the highest number of movies = 4285.
/*
no_of_movies, genre
'4285', 'Drama'
'2412', 'Comedy'
'1484', 'Thriller'
'1289', 'Action'
'1208', 'Horror'
'906', 'Romance'
'813', 'Crime'
'591', 'Adventure'
'555', 'Mystery'
'375', 'Sci-Fi'
'342', 'Fantasy'
'302', 'Family'
'100', 'Others'

*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH Single_genre
AS (
	SELECT movie_id
	FROM genre 
	GROUP By movie_id
	HAVING count(DISTINCT genre) =1)
SELECT count(*) AS Single_genre
FROM Single_genre;

/* OUTPUT 
movie_with_one_genre
'3289'
*/
-- There are total of 3289 movies that belongs to only 1 genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		101.5		|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, round(avg(duration),2) as Average_Duration
FROM  movie m
INNER JOIN genre g
on m.id=g.movie_id
GROUP BY genre
ORDER BY Average_Duration desc; 

-- Action movies has highest duration with 112.88 minutes followed by Romance with 109.53 and Crime with 107.05 minutes.


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


SELECT  genre,
		count(m.id) AS movie_count,
        RANK() OVER (ORDER BY count(movie_id) DESC) AS genre_rank
FROM genre as c
INNER JOIN
movie as m
ON m.id = c.movie_id
group by genre;

-- Thriller ranked=3 with 1484 movies.

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
SELECT min(avg_rating) as min_avg_rating,
	   max(avg_rating) as max_avg_rating,
       min(total_votes) AS min_total_votes, 
       max(total_votes) AS max_total_votes, 
       min(median_rating) AS min_median_rating,
       max(median_rating) AS max_median_rating
FROM ratings;

/* min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
		'1.0',			 '10.0', 			'100', 		'725138', 			'1', 				'10'
*/

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
WITH Movie_Rank as (
select m.title,
		r.avg_rating,
         RANK() OVER(order by avg_rating desc) as movie_rank
FROM ratings r
INNER JOIN movie m
ON r.movie_id=m.id limit 10
)
SELECT *
FROM Movie_Rank;

-- Top 3 Movies have an avg_rating >=9.8

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
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- Movies with a median rating of 7 is highest in number

/* . 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_hit_movie_summary
     AS (SELECT production_company,
                Count(movie_id)                     AS MOVIE_COUNT,
                Rank() OVER(ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1; 


/*
production_company, MOVIE_COUNT, PROD_COMPANY_RANK
'Dream Warrior Pictures', '3', '1'
'National Theatre Live', '3', '1'

*/

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
SELECT genre,
		count(m.id) as movie_count
FROM movie m
INNER JOIN genre g
ON m.id=g.movie_id
INNER JOIN ratings r
ON r.movie_id =  m.id
WHERE year=2017 and month(date_published)=3 and country LIKE '%USA%' and total_votes>1000
GROUP BY genre
ORDER BY movie_count DESC;
		
--  24 Drama Movies were released in March 2017 in USA and has more than 1000 votes.


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

SELECT title,
		avg_rating,
        genre
FROM movie m
INNER JOIN genre g
ON m.id=g.movie_id
INNER JOIN ratings r
ON r.movie_id =  m.id
WHERE title LIKE 'THE%' and avg_rating>8
GROUP BY title
ORDER BY avg_rating DESC;

-- These 8 movies are there which have avg_rating of more than 8 and 'The Brighton Miracle' is the top most with 9.5 average rating.


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
		count(*) AS MOVIE_COUNTS
FROM movie m 
INNER JOIN ratings r
on r.movie_id=m.id
WHERE median_rating = 8 AND date_published between '2018-04-01' and '2019-04-01'
GROUP BY median_rating;

-- There are 361 movies which have a median rating of 8.



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT country, sum(total_votes) as total_votes
FROM movie AS m
	INNER JOIN ratings as r ON m.id=r.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country;

-- German movies have more votes than Italian movies
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
 
/*
name_nulls, height_nulls, date_of_birth_nulls, known_for_movies_nulls
	'0',		'17335', 		'13431',			 '15226'
*/

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
WITH top3_genres AS
(
SELECT genre,
		COUNT(m.id) as movie_counts
FROM movie m
INNER JOIN genre g
on m.id=g.movie_id
INNER JOIN ratings r
on r.movie_id=m.id
WHERE avg_rating>8
Group By genre 
ORDER BY movie_counts DESC LIMIT 3
)
SELECT n.name as director_name,
		count(d.movie_id) as movie_counts
FROM director_mapping d
INNER JOIN genre g
on d.movie_id=g.movie_id
INNER JOIN names n
on n.id=d.name_id
INNER JOIN top3_genres t
using (genre)
INNER JOIN movie m
on m.id=g.movie_id
INNER JOIN ratings r
on r.movie_id = m.id
WHERE avg_rating>8
GROUP BY name
ORDER BY movie_counts DESC LIMIT 3;


/* 
director_name,      movie_counts
'James Mangold', 		'4'
'Anthony Russo', 		'3'
'Soubin Shahir', 		'3'

James Mangold can be hired as the director for RSVP's next project. 

*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT n.name as actor_name,
		COUNT(movie_id) as movie_count
FROM role_mapping rg
INNER JOIN names n
on n.id=rg.name_id
INNER JOIN ratings r
using(movie_id)
INNER JOIN movie m
on m.id=rg.movie_id
WHERE r.median_rating>=8 AND category='ACTOR'
GROUP BY actor_name
ORDER BY movie_count DESC LIMIT 2;

/* 
actor_name,   movie_count
'Mammootty',    '8'
'Mohanlal',     '5'
*/


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
SELECT production_company,
		sum(total_votes) as vote_count,
        RANK() OVER(ORDER BY total_votes desc) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
on m.id = r.movie_id
GROUP BY production_company LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.
	production_company, vote_count,   prod_comp_rank
	'Marvel Studios',    	'2656967', 	'1'
	'Syncopy',			    '487517',   '2'
	'New Line Cinema', 		'599440',   '3'

.*/

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

-- SInce, there are multiple conditions so CTE can be used in this
WITH Actor_selection AS
(
SELECT n.name as actor_name,
		total_votes,
        count(r.movie_id) as movie_count,
        sum(avg_rating*total_votes)/sum(total_votes) as actor_avg_rating      
FROM movie m
INNER JOIN ratings r
on r.movie_id = m.id
INNER JOIN role_mapping rm
on rm.movie_id=m.id
INNER JOIN names as n
on n.id=rm.name_id
WHERE category='ACTOR' and Country='India'
GROUP BY name
Having movie_count>=5
)
SELECT *,
RANK() OVER (ORDER BY actor_avg_rating desc) as actor_rank
FROM actor_selection;

-- Top actor is Vijay Sethupathi with an avg rating of 8.4

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
WITH Actress_selection AS
(
SELECT n.name as actor_name,
		total_votes,
        count(r.movie_id) as movie_count,
        sum(avg_rating*total_votes)/sum(total_votes) as actress_avg_rating      
FROM movie m
INNER JOIN ratings r
on r.movie_id = m.id
INNER JOIN role_mapping rm
on rm.movie_id=m.id
INNER JOIN names as n
on n.id=rm.name_id
WHERE category='ACTRESS' and Country='India' AND languages = 'Hindi'
GROUP BY name
Having movie_count>=3
)
SELECT *,
RANK() OVER (ORDER BY actress_avg_rating desc) as actor_rank
FROM actress_selection;


/* Taapsee Pannu tops with average rating 7.74. 
*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,
		avg_rating,
        CASE
			WHEN avg_rating > 8 THEN 'Superhit movies'
			WHEN avg_rating between 7 and 8 THEN 'Hit movies'
			WHEN avg_rating between 5 and 7 THEN 'One-time-watch movies'
			ELSE 'Flop movies'
		END AS rating_Category
FROM movie m 
INNER JOIN ratings r
on r.movie_id=m.id
INNER JOIN genre g
on g.movie_id = m.id
WHERE genre='Thriller';


/* 
on the basis of ratings , movies have been shotlisted with safe having maximum of 9.5 avg_rating
.*/

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
SELECT genre,
		ROUND(avg(duration),2) AS Average_Duration,
        sum(ROUND(avg(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING ) AS Running_total_duration,
        avg(ROUND(avg(duration),2)) OVER ( ORDER BY genre ROWS 10 PRECEDING ) AS moving_avg_duration
FROM movie m
INNER JOIN genre g
on m.id=g.movie_id
GROUP BY genre
ORDER BY genre;

 /*
 Action movie have the highest average duraition of movies.
 */
   

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

-- Top 3 Genres based on most number of movies
WITH top3_genres AS
(
		SELECT genre,
				COUNT(m.id) as movie_counts
		FROM movie m
		INNER JOIN genre g
		on m.id=g.movie_id
		INNER JOIN ratings r
		on r.movie_id=m.id
		Group By genre 
		ORDER BY movie_counts DESC LIMIT 3	),
grossing_movies as
(
		SELECT genre,
				year,
				title AS movie_name,
				
				  CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
		FROM movie m
		INNER JOIN genre g
		on m.id=g.movie_id
		WHERE genre in 
        ( 
				SELECT genre
                FROM top3_genres)
		GROUP BY movie_name
		)
SELECT *
FROM   grossing_movies
WHERE  movie_rank<=5
ORDER BY YEAR;

-- Thriller movie(The Fate of the Furious) have the highest gross income worldwide followed by comedy (Despicable Me 3).



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
SELECT production_company,
		COUNT(m.id) as movie_counts,
        RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r
on m.id=r.movie_id
WHERE median_rating>=8
AND Position(',' IN languages) > 0
AND production_company is NOT NULL
GROUP BY production_company
ORDER BY movie_counts DESC
LIMIT 2;

/* Solution
production_company, movie_counts, prod_company_rank
'Star Cinema', '7', '1'
'Twentieth Century Fox', '4', '2'
*/


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
WITH Actress_selection AS
(
SELECT n.name as actor_name,
		sum(total_votes) as total_votes,
        count(r.movie_id) as movie_count,
        ROUND(sum(avg_rating*total_votes)/sum(total_votes),2) as actress_avg_rating      
FROM movie m
INNER JOIN ratings r
on r.movie_id = m.id
INNER JOIN role_mapping rm
on rm.movie_id=m.id
INNER JOIN names as n
on n.id=rm.name_id
INNER JOIN genre g
on m.id=g.movie_id
WHERE category='ACTRESS' and genre='Drama' and avg_rating>8
GROUP BY name
)
SELECT *,
		RANK() OVER(ORDER BY movie_count DESC) AS Actress_rank
FROM Actress_selection
LIMIT 3;

/* Solution
actor_name, total_votes, movie_count, actress_avg_rating, Actress_rank
'Parvathy Thiruvothu', '4974', '2', '8.25', '1'
'Susan Brown', '656', '2', '8.94', '1'
'Amanda Lawrence', '656', '2', '8.94', '1'

*/ 
   

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

WITH next_date AS
(
	SELECT     d.name_id,
			  NAME,
			  d.movie_id,
			  m.duration,
			  r.avg_rating,
			  total_votes,
			  m.date_published,
			  Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date
   FROM director_mapping d
   INNER JOIN names n
   ON n.id = d.name_id
   INNER JOIN movie AS m
   ON m.id = d.movie_id
   INNER JOIN ratings AS r
   ON r.movie_id = m.id ), 
   top_director AS
(
	SELECT *,
		  Datediff(next_date, date_published) AS date_diff
	FROM   next_date 
)
SELECT   name_id AS director_id,
	 NAME  AS director_name,
	 COUNT(movie_id) AS number_of_movies,
	 Round(Avg(date_diff),2) AS avg_inter_movie_days,
	 Round(Avg(avg_rating),2) AS avg_rating,
	 Sum(total_votes) AS total_votes,
	 Min(avg_rating)  AS min_rating,
	 Max(avg_rating)  AS max_rating,
	 Sum(duration) AS total_duration
FROM     top_director
GROUP BY director_id
ORDER BY Count(movie_id) DESC 
limit 9;

-- As per the table, it is clearly visible that Steven Soderbergh is the best director with respect to total votes and average ratings.
-- The Director who make movies more frequent is Sam Liu.



