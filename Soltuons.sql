-- Netflix Data Analysis Using SQL
-- Solutions of Business Problems

-- 1. Count Number of tv shows and movies
SELECT type , count(*) AS total_content FROM netflix GROUP BY type; 

-- 2. Most common rating for tv show and movies
SELECT
	TYPE,
	RATING
FROM
	(
		SELECT
			TYPE,
			RATING,
			COUNT(*),
			RANK() OVER (
				PARTITION BY
					TYPE
				ORDER BY
					COUNT(*) DESC
			) AS RANKING
		FROM
			NETFLIX
		GROUP BY
			1,
			2
	) AS T1
WHERE
	RANKING = 1;

-- 3. All the movies released in year 2022

-- filter by 2020 , then filter by movies
SELECT
	count(*)
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND RELEASE_YEAR = 2020;

-- 4. Top 5 countries having most content on netflix

SELECT
	UNNEST(STRING_TO_ARRAY(COUNTRY, ',')) AS NEW_COUNTRY,
	COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM
	NETFLIX
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5;
	
-- 5.Longest Movie

SELECT
	DURATION
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND DURATION = (
		SELECT
			MAX(DURATION)
		FROM
			NETFLIX
	)

-- 6. Content added in last 5 years

SELECT
	count(*)
FROM
	NETFLIX
WHERE
	TO_DATE(DATE_ADDED, 'Month DD YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'

-- 7. Movies / tv shows by director 'Rajiv Chilaka'

SELECT
	*
FROM
	NETFLIX
WHERE
	DIRECTOR ILIKE '%Rajiv Chilaka%'

-- 8. TV shows with more than 5 seasons
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'TV Show'
	AND 
	SPLIT_PART(DURATION, ' ', 1):: numeric > 5

-- 9. Number of content items in each genre
SELECT 
UNNEST(STRING_TO_ARRAY(listed_in ,',')),
COUNT(show_id)
from netflix
group by 1
ORDER BY 2 DESC

-- 10. Each year and content released by india on netflix ,
-- Top 5 year with highest content release
SELECT
	EXTRACT(
		YEAR
		FROM
			TO_DATE(DATE_ADDED, 'Month DD YYYY')
	) AS YEAR,
	COUNT(*) AS YEARLY_CONTENT,
	ROUND(
		COUNT(*)::NUMERIC / (
			SELECT
				COUNT(*)
			FROM
				NETFLIX
			WHERE
				COUNTRY = 'India'
		)::NUMERIC * 100,
		2
	) AS AVG_CONTENT_PER_YEARFROM
	NETFLIX
WHERE
	COUNTRY = 'India'
GROUP BY
	1


-- 11. All movies that are documentaries

SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE ILIKE'%Movie%'
	AND LISTED_IN ILIKE'%Documentaries%'

-- 12. All the content without a director

SELECT
	COUNT(*)
FROM
	NETFLIX
WHERE
	DIRECTOR IS NULL

-- 13. Number of movies actor = 'Salman Khan' appeared in last 10 years

SELECT
	COUNT(*)
FROM
	NETFLIX
WHERE
	CASTS ILIKE '%salman khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) -10
	
-- 14. Top 10 actors who have appeared in the highest number of movies produced in india

SELECT
	UNNEST(STRING_TO_ARRAY(CASTS, ',')) AS ACTORS,
	COUNT(*) AS TOTAL_CONTENT
FROM
	NETFLIX
WHERE
	COUNTRY ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC LIMIT 10

-- 15. Categorizing the content based on the presence of the keywords 'kill' and 'voilence' in the description field Label content containing these 
-- keywords as 'Bad' and allother as 'Good' Count of each category

WITH new_table 
AS(
SELECT *,
        CASE
		WHEN description ILIKE '%kill%' OR
		     description ILIKE '%voilence%' THEN 'Bad'
			 ELSE 'Good'
		END category
FROM NETFLIX
)
SELECT category,
COUNT(*) AS total_content
FROM  new_table
GROUP BY 1
