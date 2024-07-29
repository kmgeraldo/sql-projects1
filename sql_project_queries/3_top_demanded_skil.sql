/*
Qn: What are the 5 most in-demand skils for data analysts?
- Join job postings to inner join table (almost as in qn 2)
- Focus on all job postings
- This will help us retrieve the top 5 skills with the highest demand in the job market. 
*/

SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
     skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY
    demand_count DESC
LIMIT 5;
