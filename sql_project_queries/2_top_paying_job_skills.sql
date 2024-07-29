/*
Qn: What skills are reqiured for the top_paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from the first query
- Add the specific skills required for each of these roles.
- The idea is to find out the skills rquired at these best paying jobs,
  helping us know which skills we might need to ease the job search! 
*/

WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        name AS company_name,
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
    LIMIT 10
)
SELECT top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON
    top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
     skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
After further analysis, SQL is the leading job_skill from the ads
Python comes a close second, followed by Tableau.
Other skills like R, Snowflake, Pandas, and Excel have varying degrees of demand.
*/