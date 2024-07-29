# Introduction

# Background
Job searching can feel like a job itself! So, this SQL project aims to take a deep dive into the data job market with this SQL project, identifying which skills we might need to polish up on in order to ease the job search project. Therefore, the focus here will be on data analyst roles, where we explore the top paying jobs, most in-demand skills, and of course, the highest paying data analyst skills as per the job market.

Want to check out my queries? Simply navigate to the [sql_project_queries](/sql_project_queries/) folder.

The data was sourced from [Luke Barrouse's data analyst website](https://lukebarousse.com/sql) where he aggregates data from various job listings on sites like LinkedIn and several job boards from all over the world.

## I wanted to answer the folllowing questions:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top_paying jobs?
3. What skills are most in demand for data analysts?
4. What skills are associated with higher salaries?
5. What are the most optimal skills too learn? i.e high paying, and most in-demand.


# Tools Used
The main tools I used for this project were:
- SQL
- Git & GitHub
- PostgreSQL
- Visual Studio Code - I ran all the queries in here, giving me the opportunity to use a new tool!

# Analysis/ Approach
The aim of the project is to investigate the specific aspects of the data analyst job market.

Here's the approach to each question:

### 1. What are the top-paying data analyst jobs?
To identify the highest-paying roles or job titles,I filtered for jobs with the keyword data analyst and then by average yearly salary and location, focusing on remote jobs. The aim here is to highlight the highest paying opportunities in the field.

The reason for the focus on remote jobs because I fancy a remote role.

The analysis showed that the best paying roles or titles are: Data Analyst, Director of Analytics and Associate Director - Data Insights.


```sql
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
```

### 2. What skills are required for these top_paying jobs?

Uing the top 10 highest-paying Data Analyst jobs from query one, we add the specific skills required for each of these roles. The plan here is to find out the skills rquired at the top paying jobs,helping us know which skills are needed to ease the job search!

The results showed that SQL is the leading job_skill from the ads. Python comes a close second, followed by Tableau.
Other skills like R, Snowflake, Pandas, and Excel have varying degrees of demand.

```sql
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
```
### 3. What skills are most in demand for data analysts?

The approach is to Join job postings to inner join table with a focus on all job postings. The idea here is to help us retrieve the top 5 skills with the highest demand in the job market.

For Data Analysts job adverts, the most in demand skills were SQL, Excel and Pyhton. 

```sql
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
```

### 4. What skills are associated with higher salaries?

We look at the average salary associated with each skill for Data Analyst roles, focusing on roles with specified salaries, regardless of location.

The results showed that svn, solidity and couchbase were the top 3 paying skills on average.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
     skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY
   avg_salary DESC
LIMIT 25;
```

### 5. What are the most optimal skills too learn?

Now, we turn our focus on the skills on demand but focusing mainly on the highest paying ones, looking out for the juiciest jobs on the market! I decided to take only the top 25.

The analysis showed that Kafka (with an average salary of 129,999), pytorch, perl and tensorflow are the top paying Data Analyst skills in these job adverts.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,      
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

# What I learned from the Project

The project was a great way for me to practice all my SQL knowledge, testing concepts like JOINS, CTEs, as well as simple queries.


# Conclusions

1. The best paying roles or titles are: Data  Analyst, Director of Analytics and Associate Director - Data Insights.

2. The analysis showed that SQL is the leading job_skill from the ads. Python comes a close second, followed by Tableau.
Other skills like R, Snowflake, Pandas, and Excel have varying degrees of demand.

3. For Data Analysts jobs, the most in demand skills were SQL, Excel and Pyhton.

4. Svn, solidity and couchbase were the top 3 paying skills on average.
5. Kafka (with an average salary of 129,999), pytorch, perl and tensorflow rank as both the top paying and in-demand Data Analyst skills in these job adverts.

#### Closing Thoughts
This project really enhanced my SQL skills and also gave me valuable insights into the job market.

These findings will help me focus my job search and learning process, helping me adapt to market demands and get up to date with essential skills.