# Stock Management System – CMPE341 Group 10

Database Design & Management (CMPE341) term project.
A web application for managing products, stock levels in multiple warehouses, suppliers,
customers, purchase orders and sales orders. PostgreSQL 16 + Python (Flask).

**Live demo:** http://162.243.165.86  &nbsp;&nbsp;*(DigitalOcean Droplet – see [DEPLOYMENT.md](DEPLOYMENT.md))*

---

## Quick start (Docker)

Requirements: [Docker](https://docs.docker.com/get-docker/) with Docker Compose.

```bash
git clone https://github.com/kuzeykumrulu/stock_management_system_group10.git
cd stock_management_system_group10
docker compose up
```

This single command:
1. starts a PostgreSQL 16 database and automatically creates all tables and loads the sample data
   (`sql/01_schema.sql`, `sql/02_data.sql`, `sql/04_users.sql`),
2. builds and starts the web application.

**Open the app at: http://localhost**

> If port 80 is already in use on your computer, run `APP_PORT=8080 docker compose up`
> and open http://localhost:8080 instead.

To stop: `Ctrl+C` (or `docker compose down`).
To reset the database to the original sample data: `docker compose down -v` and then `docker compose up` again.

## Test accounts

| Role  | Username | Password    | Permissions |
|-------|----------|-------------|-------------|
| admin | `admin`  | `Admin123!` | Full access: view, insert, update and delete in all tables; manage application users |
| staff | `staff`  | `Staff123!` | View all tables; insert and update stock (inventory), customers, purchase orders and sales orders; **cannot delete** and cannot change master data (categories, suppliers, products, warehouses, employees) |

Passwords are never stored in plain text: the `app_user` table stores salted
PBKDF2-SHA256 hashes (`werkzeug.security`). Permissions are checked on the server for every request,
not only hidden in the user interface.

## Project structure

```
docker-compose.yml        # db + web services
sql/
  01_schema.sql           # CREATE TABLE statements with constraints (11 tables)
  02_data.sql             # sample data (at least 3 records per table)
  03_queries.sql          # report queries (JOIN, GROUP BY / HAVING / ORDER BY, subqueries)
  04_users.sql            # app_user table + test users (hashed passwords)
webapp/
  Dockerfile
  requirements.txt
  app.py                  # Flask application: authentication, authorization, CRUD
  templates/              # HTML pages (login, dashboard, list, form, users)
diagrams/                 # ER diagram and relational schema
DEPLOYMENT.md             # how the app is deployed to the cloud VM
```

## Running the queries

```bash
docker compose exec -T db psql -U stockuser -d stockdb < sql/03_queries.sql
```

## Running without Docker (optional)

```bash
createdb stockdb
psql -d stockdb -f sql/01_schema.sql -f sql/02_data.sql -f sql/04_users.sql
cd webapp
pip install -r requirements.txt
PGUSER=postgres PGPASSWORD=yourpassword python app.py     # http://localhost:5000
```

## Team

| Name | Student ID |
|------|------------|
| Ida Ilgın Sumen | |
| Defne Varurer | |
| Bülent Kuzey Kumrulu | |
| Efe Batuhan Çağlayan | |
