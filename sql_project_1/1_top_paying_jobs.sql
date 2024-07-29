/*
Qn: What are the top-paying data analyst jobs according to the job listings?
- identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (excluding nulls to take out those with no salary listed).
- Why? Highligh the top paying opportunities for Data Analysts, offering insights into job listsings
*/

SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg
    
FROM 
    job_postings_fact
LEFT JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;




