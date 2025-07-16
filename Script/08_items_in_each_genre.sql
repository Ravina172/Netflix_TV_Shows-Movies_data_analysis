SELECT 
UNNEST(STRING_TO_ARRAY(listed_in ,',')),
COUNT(show_id)
from netflix
group by 1
ORDER BY 2 DESC
