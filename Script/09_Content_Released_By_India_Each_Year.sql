SELECT
	EXTRACT(YEAR FROM TO_DATE(DATE_ADDED, 'Month DD YYYY')) AS YEAR,
	COUNT(*) AS YEARLY_CONTENT,
	ROUND(COUNT()::NUMERIC / (SELECT COUNT() FROMNETFLIX
			         WHERE
				  COUNTRY = 'India'
		                  )::NUMERIC * 100,2) 
	AS AVG_CONTENT_PER_YEARFROM NETFLIX
WHERE
	COUNTRY = 'India'
GROUP BY 1
