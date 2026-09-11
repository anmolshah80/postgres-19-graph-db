# PostgreSQL 19 Graph Database

A simple docker-compose.yml file to run a PostgreSQL 19 database and interact with the beta feature [Property Graphs](https://www.postgresql.org/docs/19/ddl-property-graphs.html).

## Setup

- Clone this repository.
- Run `docker-compose up -d` to start the PostgreSQL 19 container.
- Connect to the database using your preferred PostgreSQL client (e.g., pgAdmin, DBeaver, TablePlus or psql) with the following connection details:
  - Host: `localhost`
  - Port: `5434`
  - User: `admin`
  - Password: `password`
  - Database: `postgres19_graph_db`
- Start executing each SQL command one by one in the `create-db-template.sql` file to create a sample graph database and test the functionality.
- To stop the container, run `docker-compose down`.
- To remove the container and its associated data, run `docker-compose down -v`.
