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
GROUP BY 1
