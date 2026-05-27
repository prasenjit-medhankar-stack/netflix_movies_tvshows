--CREATING TABLE NAMED(NETFLIX)
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
select *from netflix
limit 10;

--1 Count the number of Movies vs TV Shows
select 
	type,
	count(*) as total_content 
	from netflix 
	group by type;

-- 2 Find the most common rating for movies and TV shows 
SELECT
    type,
    rating,
    total_count
FROM
(
    SELECT
        type,
        rating,
        COUNT(*) AS total_count,
        RANK() OVER(
            PARTITION BY type
            ORDER BY COUNT(*) DESC
        ) AS rank_num
    FROM netflix
    GROUP BY type, rating
) AS ranked_ratings
WHERE rank_num = 1;

-- 3 List all movies released in a specific year (e.g., 2020)
select *from netflix
	where type='Movie' and
	release_year='2020';

--4 Find the top 5 countries with the most content on Netflix
SELECT
    country,
    COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

--5.Identify the longest movie
SELECT * FROM netflix
	WHERE type = 'Movie'
	AND 
	duration=(select max(duration)from netflix);

--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY')
    >= CURRENT_DATE - INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix
	where director ilike '%Rajiv Chilaka%';

--8 List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

--9. Count the number of content items in each genre
select 
	listed_in,
	count(*) as total_content
	from netflix
	group by 1
	order by 2 desc;

-- 10. Top 5 Years with Highest Indian Content Release
SELECT
    release_year,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY release_year
ORDER BY total_content DESC
LIMIT 5;

--11. List all movies that are documentaries
SELECT *FROM netflix
	WHERE type = 'Movie'
    AND listed_in ILIKE '%Documentaries%';


--12. Find all content without a director
select * from netflix
	where director is null;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
    AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*) AS total_movies
FROM netflix
WHERE country ILIKE '%India%'
    AND type = 'Movie'
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;


/*15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
SELECT
    CASE
        WHEN description ILIKE '%kill%'
            OR description ILIKE '%violence%'
        THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_content
FROM netflix
GROUP BY content_category;
	


	
	




















