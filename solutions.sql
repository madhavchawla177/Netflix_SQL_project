--Netflix Project 

Create TABLE Netflix(
	show_id varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(208),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
);
select * from netflix

select count(*) 
	as total_content 
from netflix; 

select distinct type 
from netflix;

select * from netflix;

-- 15 busniess problems 
1. count the number of movie vs TV shows 

select 
	type, count(*) as total_content
from netflix 
group by type;


2. find the most common rating for movies and TV shows 

select 
	type,
	rating
from 
(
	select 
		type, 
		rating,
		count(*),
		RANK() OVER (partition by type ORDER by count (*) DESC) as ranking 
	from netflix
	group by 1,2
) as t1
WHERE
	ranking=1;

3. list all the movies released in specific year (eg:2020)

SELECT * FROM netflix
WHERE 
	type ='Movie'
	AND 
	release_year=2020;


4. find the top 5 countries with most content on netflix 

select 
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	count(show_id) as total_count
from netflix
group by 1 
order by 2 desc 
limit 5
;

5. identify the longest movie 

select * from netflix
where 
	type='Movie'
	and
	duration=(select MAX (duration) from netflix);


6. find the content added in last 5 years 

select 
	*
from netflix
where 
	TO_DATE(date_added,'month,DD,YYYY') >= CURRENT_DATE-INTERVAL '5 YEARS'
;

7.find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT * FROM NETFLIX
WHERE director LIKE '%Rajiv Chilaka%';

8. list all the TV  shows with more that 5 seasons 

select 
	*
from netflix
where 
	type = 'TV Show'
	AND 
	split_part(duration,' ',1):: numeric > 5


9. count the number of content items in each genre 

select 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre, 
	count(show_id) as total_content
from netflix 
group by 1 


10. find each year and average number of content released in india on netflix.
return top 5 year with highest average content release 

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added ,'Month DD YYYY')) as year,
	count(*),
	ROUND(COUNT(*):: numeric/(SELECT COUNT(*) FROM netflix WHERE country='India'):: numeric*100 
	,2) as average_content_per_year
FROM netflix
WHERE country='India'
GROUP BY 1
ORDER BY average_content_per_year DESC
LIMIT 5

11. list all the movies that are documentaries

SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%' 


12. find all content wihtout a director 

select 
	* 
from netflix
where director is null


13. find how many movies actor 'salman khan' has appeared in last 10 years 

select * From netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10

14. find the top 10 actors who appeared in highest number of movies produced in india 

SELECT 
	UNNEST(STRING_TO_ARRAY(Casts,',')) as actors,
	count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10

15. categorise the content based on the presence of keywords 'kill' and 'voilence' 
in the description field. label content containg these keywords as 'bad' and all other content as 'good'.
count how many items fall into category .

SELECT 
  CASE 
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad Content '
    ELSE 'Good Content'
  END AS content_category,
  COUNT(*) AS total_items
FROM netflix
GROUP BY content_category; 
	


