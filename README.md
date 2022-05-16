# Bungalow Take Home Project for Analytics Engineer Role (V1. 2022-03-03)

Welcome to the Bungalow Takehome Challenge for Data Analytics! This is a barebones repo to get you started.

## What to build
A common task for data analytics engineers at Bungalow involves modelling of data from the internal datasets, storing it and making it available for downstream teams such as finance and product and ultimately the entire organization.
For this challenge we'd like to give a brief snapshot of a common workload may entail. Of course, this might become a big task. Therefore, to save time for you, we did some of the heavy lifting, like the set up and some scaffolding of the environment.

For this challenge we will collect the [current weather data](https://openweathermap.org/current) from [OpenWeatherMap](https://openweathermap.org/). The free API will work for this assignment. You shouldn’t pay for the API key.

Please install [Docker Desktop](https://www.docker.com/get-started) on your laptop. It will contain the environment that we would need for the next steps.

The Docker compose would have two software applications and simple setup required for them.

- Airflow: To run your additions to the boilerplate DAGs.

- Postgres: To maintain your tables. (You can swap it with any other database or your choice, i.e. SQLite, MySQL)


Below are the steps in the data flow diagram:

- fetcher.py script, that represents the fetcher DAG, would retrieve the data from the current weather API.

- The fetcher script would process and clean the data, then stores it in the Postgres database considering relationships, integrity, performance, and extendability. We made a basic version of the fetcher Python script for you to save your time. You can improve the fetcher if you need to. For example, you will need to add 10 more cities to the list of cities for the next step.

- The transformer.py script, that represents the Transformer DAG, would transform the data from the previous step to prepare some derived dataset tables. You will have the choice to implement the transformations both in Python or SQL. This is the main part of your takehome challenge.

- The Transformer writes the datasets back to Postgres.

- The downstream customer(s) would read both original and derived tables. They will execute historical queries to run analytics and science models.


This project is meant to be flexible as to showcase your decision making capabilities and your overall technical experience. 

**Note:** If you are uncomfortable with Docker, Postgres or Airflow, please feel free to remove or replace them. They are meant to save time for you. As long as you can achieve the outcome feel free to use any additional tooling, programming language (i.e. Java or Scala) and approach you see fit. We will ask follow up questions about your decision mechanism in the follow up conversation.

We are more interested in seeing your thought process and approach to solving the problem!

##  Deliverables
We will expect to see the following items in your Github pull request:

- Your Python code for data fetcher and transformer.
  - In the transformer, please create data models for:
    - Top hot cities in your city list per day
    - Top 7 hottest day per city in each calendar year
    - An UPSERT dataset that keeps the latest weather information per city
    - The least humid city per state
    - Moving average of the temperature per city for 5 readings

- The data model SQL and your design for its data modelling

- Readme file with your notes

## Evaluation
We will use this project as our basis for our evaluation of your overall fit for a data engineering role from a technical viewpoint.

To do this, we will review your code with an eye for the following:

- Readability and usability

- Data processing and relational modelling

- Python and SQL know-how

## Time expectations
We know you are busy and likely have other commitments in your life, so we don't want to take too much of your time. We don't expect you to spend more than 2 hours working on this project. That being said, if you choose to put more or less time into it for whatever reason, that is your choice.

Feel free to indicate in your notes below if you worked on this for a different amount of time and we will keep that in mind while evaluating the project. You can also provide us with additional context if you would like to.

Additionally, we have left a spot below for you to note. If you have ideas for pieces that you would have done differently or additional things you would have implemented if you had more time, you can indicate those in your notes below as well, and we will use those as part of the evaluation.

## Public forks
We encourage you to try this project without looking at the solutions others may have posted. This will give the most honest representation of your abilities and skills. However, we also recognize that day-to-day programming often involves looking at solutions others have provided and iterating on them. Being able to pick out the best parts and truly understand them well enough to make good choices about what to copy and what to pass on by is a skill in and of itself. As such, if you do end up referencing someone else's work and building upon it, we ask that you note that as a comment. Provide a link to the source so we can see the original work and any modifications that you chose to make.

## Challenge instructions
Fork this repository and clone to your local environment

- Prepare your environment with Python and any other tools you may need. Docker can do it for you.
  - To run the docker-compose, you need to run the following commands:
      ```bash
      # Create you own .env file from our sample and edit the .env file with the OpenWeatherMap API key
      cp env.sample .env
      # Initializing the folders and the non-root user for Airflow
      mkdir -p  ./logs ./plugins
      echo -e "AIRFLOW_UID=$(id -u)" >> .env
      # Initializing airflow database
      docker-compose up airflow-init
      # Running the docker-compose
      docker-compose up 
      # You can see the Airflow UI in http://localhost:8080 with username/password: airflow
      ```
  - If you run to any problems with the environment, please refer to [here](https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html).
- Fill in the TODO in the repository. There are currently less than 5 TODOS, but you can go beyond and above.
  - Any problems with the DAGs? They are taken from [here](https://airflow.apache.org/docs/apache-airflow/stable/tutorial.html). Please take a look at the rest of tutorial if needed.
  - You can check Postgres operator from [here](https://airflow.apache.org/docs/apache-airflow-providers-postgres/stable/operators/postgres_operator_howto_guide.html)
  - To keep it simple, let's use the Airflow database for the storage of your dataset
- Write down the notes, in the Readme.md file.
- Complete the challenge and push back to the repo
  - If you have any questions in any step, please reach out to your recruiter. A member of engineering team will be involved to support you, as if you were working for Bungalow.
- **Note:** If you are using Apple hardware with M1 processor, there is a common challenge with Docker. You can read more about it [here](https://javascript.plainenglish.io/which-docker-images-can-you-use-on-the-mac-m1-daba6bbc2dc5).

## Your notes (Readme.md) 

### Time spent
* Overall I spent ~4 hours on this project. As a rough breakdown:
** In the first 30-45 minutes, I gathered context by reading assessment content, API docs, etc.
** In the next ~15-30 minutes, I focused on data modeling considerations.
** In the next ~1.5 hours, I implemented a draft of the solution.
** In the next ~30 minutes, I cleaned up DAGs and added comments.
** In the next ~30 minutes, I reviewed my code and compiled this doc.
** In the last ~30 minutes, I tested my code and ensured that code runs as expected.
* I moved this weekend from DC to LA! I wrapped up most of the project at the airport / on the plane, but had to wait until after I arrived and settled in at my new house (+ setting up Internet) to test my code and finalize the project.
* LAstly, I actually had a very mild concussion last week. So I felt fine enough for the assessment, but that might have contributed to some slowness. 

### Assumptions
* Metadata on cities (`dim_tables`) and weather types (`dim_weather_types`) should not change in any meaningful way (in terms of downstream impact). If substantial changes are needed (e.g. two cities merge into one), we expect new records to be generated with new IDs.
  * This allows us to normalize the raw dataset, and prevent duplicate records when joining the core weather table to dimension tables. (I.e. we can maintain dimension tables that are unique on each entity's ID.)
* On Question #4 (least humid city), the original prompt said "per state". However, the input cities are in Canada, and the API docs note that state information is only available in the US. So I updated the prompt to "per country"; but please let me know if I am misunderstanding the prompt.

### Next steps
* With more time, I would have focused next on considering additional table constraints, indexes and/or keys for optimizing downstream queries. 
* Depending on business requirements, I would also have wanted to consider whether some derived views should be reconstructed as tables instead.
* Adding tests to ensure data quality would also be a good next step. E.g., we should really test that updated dimension tables retain all entries that we used to have.
* Lastly, I would definitely want to incorporate a tool like dbt to run all relevant transformations. This would streamline the process with minimal code, and enable documentation, tracking, tests, etc.

### Instructions to the evaluator
n/a
