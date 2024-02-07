/* 1. How many rows are in the data_analyst_jobs table? */

SELECT COUNT(*) AS num_rows
FROM data_analyst_jobs;

-- Answer: 1793

/* 2. Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row? */

SELECT *
FROM data_analyst_jobs
LIMIT 10;

-- Answer: ExxonMobil

/* 3. How many postings are in Tennessee? How many are there in either Tennessee or Kentucky? */

SELECT COUNT(*) AS num_tn_jobs
FROM data_analyst_jobs
WHERE location = 'TN';

SELECT COUNT(*) AS num_tn_and_ky_jobs
FROM data_analyst_jobs
WHERE location IN ('TN', 'KY');

-- Answer: 21 in TN, 27 in either TN or KY

/* 4. How many postings in Tennessee have a star rating above 4? */

SELECT COUNT(*) AS num_tn_jobs_four_stars
FROM data_analyst_jobs
WHERE location = 'TN'
	AND star_rating > 4;

-- Answer: 3

/* 5. How many postings in the dataset have a review count between 500 and 1000? */

SELECT COUNT(*) AS num_jobs_many_reviews
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;

-- Answer: 151

/* 6. Show the average star rating for companies in each state. The output should show the state as state and the average rating for the state as avg_rating. Which state shows the highest average rating? */

SELECT location AS state, 
	AVG(star_rating) AS avg_rating
FROM data_analyst_jobs
GROUP BY location
HAVING AVG(star_rating) IS NOT NULL
ORDER BY avg_rating DESC;

-- Answer: NE

/* 7. Select unique job titles from the data_analyst_jobs table. How many are there? */

SELECT DISTINCT title AS job_title
FROM data_analyst_jobs
ORDER BY title;

-- This query shows the count

SELECT COUNT(DISTINCT title) AS num_job_titles
FROM data_analyst_jobs;

-- Answer: 881

/* 8. How many unique job titles are there for California companies? */

SELECT COUNT(DISTINCT title) AS num_ca_job_titles
FROM data_analyst_jobs
WHERE location = 'CA';

-- Answer: 230

/* 9. Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations? */

SELECT company, 
	AVG(star_rating) AS avg_star_rating
FROM data_analyst_jobs
GROUP BY company
HAVING AVG(review_count) > 5000
ORDER BY company;

-- This query shows the count

SELECT COUNT(DISTINCT company) AS num_companies_over_5000_reviews
FROM (
	SELECT company
	FROM data_analyst_jobs
	GROUP BY company
	HAVING AVG(review_count) > 5000
	) AS num_companies_over_5000_reviews;

-- Answer: 40 (There is one additional row with >5000 reviews but no company name)

/* 10. Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating? */

SELECT company, 
	AVG(star_rating) AS avg_star_rating
FROM data_analyst_jobs
GROUP BY company
HAVING AVG(review_count) > 5000
ORDER BY avg_star_rating DESC;

-- Here is a version with rankings:

SELECT company, 
	AVG(star_rating) AS avg_star_rating,
	RANK() OVER (ORDER BY AVG(star_rating) DESC) AS rank_by_rating
FROM data_analyst_jobs
GROUP BY company
HAVING AVG(review_count) > 5000;

-- Answer: 6 companies tied for the highest star rating >5000 ratings: Unilever, Nike, American Express, Microsoft, Kaiser Permanente, and General Motors
--

/* 11. Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? */

SELECT DISTINCT title AS analyst_job_title
FROM data_analyst_jobs
WHERE title ILIKE '%analyst%';

-- This query shows the count

SELECT COUNT(DISTINCT title) AS num_analyst_jobs
FROM data_analyst_jobs
WHERE title ILIKE '%analyst%';

-- Answer: 774

/* 12. How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common? */

SELECT title AS job_title
FROM data_analyst_jobs
WHERE title NOT ILIKE '%analy%'

-- Just checking to make sure '%analy%' didn't pick up anything extra

SELECT title
FROM data_analyst_jobs
WHERE title NOT ILIKE '%analyst%' AND title NOT ILIKE '%analytics%'

-- Answer: 4 job titles, which are all data visualization jobs (Tableau)

/* BONUS You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.
-Disregard any postings where the domain is NULL.
-Order your results so that the domain with the greatest number of hard to fill jobs is at the top.
-Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4? */

SELECT domain AS industry, 
	COUNT(*) AS num_sql_jobs
FROM (
	SELECT * 
	FROM data_analyst_jobs 
	WHERE skill ILIKE '%SQL%' 
		AND days_since_posting > 21
	) AS sql_jobs
GROUP BY industry
HAVING domain IS NOT NULL
ORDER BY num_sql_jobs DESC;

-- Answer: The top 4 industries with hard to fill SQL jobs are Internet and Software, Banks and Financial Services, Consulting and Business Services, and Health Care. 
--