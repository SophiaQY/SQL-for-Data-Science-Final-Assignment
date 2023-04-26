--Part 1: Yelp Dataset Profiling and Understanding

--1. Profile the data by finding the total number of records for each of the tables below:

select count(*) from attribute
select count(*) from business
select count(*) from category
select count(*) from checkin
select count(*) from elite_years
select count(*) from friend
select count(*) from hours
select count(*) from photo
select count(*) from review
select count(*) from tip
select count(*) from user

--2. Find the total distinct records by either the foreign key or primary key for each table. If two foreign keys are listed in the table, please specify which foreign key.

select count(distinct id) from business
select count(distinct business_id) from hours
select count(distinct business_id) from category
select count(distinct business_id) from attribute
select count(distinct id) from review
select count(distinct business_id) from checkin
select count(distinct id) from photo
select count(distinct user_id) from tip
select count(distinct id) from user
select count(distinct user_id) from friend
select count(distinct user_id) from elite_years

--3. Are there any columns with null values in the Users table? Indicate "yes," or "no."

	Answer:
	
	
	SQL code used to arrive at answer:
	
	SELECT count(*) - count(id),
   count(*) - count(name),
   count(*) - count(review_count),
   count(*) - count(yelping_since),
   count(*) - count(useful),
   count(*) - count(cool),
   count(*) - count(fans),
   count(*) - count(average_stars),
   count(*) - count(compliment_hot),
   count(*) - count(compliment_more),
   count(*) - count(compliment_profile),
   count(*) - count(compliment_cute),
   count(*) - count(compliment_list),
   count(*) - count(compliment_note),
   count(*) - count(compliment_plain),
   count(*) - count(compliment_cool),
   count(*) - count(compliment_funny),
   count(*) - count(compliment_writer),
   count(*) - count(compliment_photos)
FROM user
	
	
--4. For each table and column listed below, display the smallest (minimum), largest (maximum), and average (mean) value for the following fields:


select min(stars), max(stars), avg(stars)
from review
select min(stars), max(stars), avg(stars)
from business
select min(likes), max(likes), avg(likes)
from tip
select min(count), max(count), avg(count)
from checkin
select min(review_count), max(review_count), avg(review_count)
from user

--5. List the cities with the most reviews in descending order:

	SQL code used to arrive at answer:
	
	select city, sum(review_count) as total_review
	from business
	group by city
	order by total_review desc
	
6. Find the distribution of star ratings to the business in the following cities:

i. Avon

SQL code used to arrive at answer:

select stars, count(stars) as count
from business
where city ='Avon'
group by stars



ii. Beachwood

SQL code used to arrive at answer:

select stars, count(stars) as count
from business
where city ='Beachwood'
group by stars



		

7. Find the top 3 users based on their total number of reviews:
		
	SQL code used to arrive at answer:
	
	select name, sum(review_count) as total_review 
	from user
	group by id
	order by total_review desc
	limit 3
	
	
8. Does posing more reviews correlate with more fans?

	Please explain your findings and interpretation of the results:
	
	SELECT range AS fans_range, 
       COUNT(*) AS num_user, 
       AVG(review_count) AS avg_num_review,     
       AVG(fans) AS avg_num_fans
FROM (SELECT CASE WHEN fans BETWEEN 0 AND 9 THEN '0 - 9'
                  WHEN fans BETWEEN 10 AND 99 THEN '10 - 99'
                  ELSE '100-1000' END AS range,
             review_count, 
             fans
      FROM user) AS subtable
GROUP BY subtable.range


9. Are there more reviews with the word "love" or with the word "hate" in them?

	Answer:
	
	select count(text) as love
	from review
	where lower(text) like '%love%'
	
	select count(text) as hate
	from review
	where lower(text) like '%hate%'
	
10. Find the top 10 users with the most fans:

	SQL code used to arrive at answer:
	
	select name, fans
	from user
	order by fans desc
	limit 10
	
	

	------------------------------------------------------
	Part 2: Inferences and Analysis

1. Pick one city and category of your choice and group the businesses in that city or category by their overall star rating. 
Compare the businesses with 2-3 stars to the businesses with 4-5 stars and answer the following questions. Include your code.
	
i. Do the two groups you chose to analyze have a different distribution of hours?

--see what city and category we have and choose target city and category

select distinct category  from category
select distinct city from business

--SQL code used for analysis:

SELECT CASE WHEN stars >= 4.0 THEN '4-5 stars'
            WHEN stars >= 2.0 THEN '2-3 stars'
            ELSE 'below 2' END AS 'STARS',               
       COUNT(DISTINCT business.id) AS id_count,            
       COUNT(hours) AS open_days_total,   -- number of openning days        
       COUNT(hours)*1.0 / COUNT(DISTINCT business.id)  AS open_days_avg
FROM ((business INNER JOIN hours ON business.id = hours.business_id)
     INNER JOIN category ON business.id = category.business_id)
WHERE city = 'Las Vegas' AND category.category ='Shopping'
GROUP BY STARS

+-----------+----------+-----------------+---------------+
| STARS     | id_count | open_days_total | open_days_avg |
+-----------+----------+-----------------+---------------+
| 2-3 stars |        2 |              13 |           6.5 |
| 4-5 stars |        2 |              12 |           6.0 |
+-----------+----------+-----------------+---------------+

ii. Do the two groups you chose to analyze have a different number of reviews?

--SQL code used for analysis:

SELECT CASE WHEN stars >= 4.0 THEN '4-5 stars'
            WHEN stars >= 2.0 THEN '2-3 stars'
            ELSE 'below 2' END AS 'STARS',               
       COUNT(DISTINCT business.id) AS id_count,            
       SUM(review_count) AS review_count_total,
       SUM(review_count)*1.0/COUNT(DISTINCT business.id)  AS review_count_avg
FROM business INNER JOIN category ON business.id = category.business_id
WHERE city = 'Las Vegas' AND category.category ='Shopping'
GROUP BY STARS

--results
+-----------+----------+--------------------+------------------+
| STARS     | id_count | review_count_total | review_count_avg |
+-----------+----------+--------------------+------------------+
| 2-3 stars |        2 |                 17 |              8.5 |
| 4-5 stars |        2 |                 36 |             18.0 |
+-----------+----------+--------------------+------------------+

The group with 4-5 stars tend to have almost double reviews of group with 2-3 stars
         
iii. Are you able to infer anything from the location data provided between these two groups? Explain.

--SQL code used for analysis:
SELECT CASE WHEN stars >= 4.0 THEN '4-5 stars'
            WHEN stars >= 2.0 THEN '2-3 stars'
            ELSE 'below 2' END AS 'STARS',      
			postal_code, address, neighborhood
			FROM business INNER JOIN category ON business.id = category.business_id
WHERE city = 'Las Vegas' AND category.category ='Shopping'
order BY STARS

--results
+-----------+-------------+-----------------------------+--------------+
| STARS     | postal_code | address                     | neighborhood |
+-----------+-------------+-----------------------------+--------------+
| 2-3 stars | 89121       | 3421 E Tropicana Ave, Ste I | Southeast    |
| 2-3 stars | 89121       | 3808 E Tropicana Ave        | Eastside     |
| 4-5 stars | 89161       | 1000 Scenic Loop Dr         |              |
| 4-5 stars | 89118       | 3555 W Reno Ave, Ste F      |              |
+-----------+-------------+-----------------------------+--------------+


The 2-3 stars group are all located in 89121 on Tropicana Ave, 4-5 groups are in different regions.




2. Group business based on the ones that are open and the ones that are closed. What differences can you find between the ones that are still open and the ones that are closed? 
List at least two differences and the SQL code you used to arrive at your answer.

         
--SQL code used for analysis:

SELECT is_open, 
       count(distinct business.id) num_business, 
       count(distinct review.id) num_review,
       avg(review.stars) avg_stars
FROM business
JOIN review ON business.id =  review.business_id
GROUP BY is_open

--Results:
+---------+--------------+------------+---------------+
| is_open | num_business | num_review |     avg_stars |
+---------+--------------+------------+---------------+
|       0 |           61 |         71 | 3.64788732394 |
|       1 |          446 |        565 |  3.7610619469 |
+---------+--------------+------------+---------------+
		
i. Difference 1: number of businesses, businesses still open are much more than those closed
         
         
ii. Difference 2: number of reviews, businesses still open have more reiews than those closed
         
         
		 
		 
3. For this last part of your analysis, you are going to choose the type of analysis you want to conduct on the Yelp dataset and are going to prepare the data for analysis.

Ideas for analysis include: Parsing out keywords and business attributes for sentiment analysis, clustering businesses to find commonalities or anomalies between them, 
predicting the overall star rating for a business, predicting the number of fans a user will have, and so on. 
These are just a few examples to get you started, so feel free to be creative and come up with your own problem you want to solve. Provide answers, in-line, to all of the following:
	
i. Indicate the type of analysis you chose to do:

         Find out what category of business is going to have highest star rating and likely to remain open
         
ii. Write 1-2 brief paragraphs on the type of data you will need for your analysis and why you chose that data:

         We choose business and category table, and investigage the is_open, stars, category variables.
		 we compute average is_open rate, average stars as star_rating of each category of business and see the comparison
		 Finally we pick the business that have the highest star_rating and is_open rate.
                  
iii. Output of your finished dataset:

+------------------------+-----------------+-------------+--------------+
| category               | business_number | star_rating | is_open_rate |
+------------------------+-----------------+-------------+--------------+
| Local Services         |              12 |        4.21 |         0.83 |
| Health & Medical       |              17 |        4.09 |         0.94 |
| Home Services          |              16 |         4.0 |         0.94 |
| Shopping               |              30 |        3.98 |         0.83 |
| Beauty & Spas          |              13 |        3.88 |         0.92 |
| American (Traditional) |              11 |        3.82 |         0.73 |
| Food                   |              23 |        3.78 |         0.87 |
| Bars                   |              17 |         3.5 |         0.65 |
| Nightlife              |              20 |        3.48 |          0.6 |
| Restaurants            |              71 |        3.46 |         0.75 |
+------------------------+-----------------+-------------+--------------+
         
         
iv. Provide the SQL code you used to create your final dataset:

	select category,
	count(distinct b.id) as business_number,
	round(avg(stars), 2 )as star_rating,
	round(avg(is_open), 2) as is_open_rate
	from business b inner join category c
	on b.id=c.business_id
	group by category
    HAVING business_number > 10
	order by star_rating desc, is_open_rate desc
	
	






