# City Complaint App (3-Tier)

A complete 3-tier application using:
- Angular frontend
- ASP.NET Core Web API backend
- PostgreSQL database
- Docker multi-stage builds + Docker Compose

## Project Structure

- `frontend/` - Angular app + frontend multi-stage Dockerfile + Nginx reverse proxy
- `backend/` - .NET Web API + EF Core + PostgreSQL + backend multi-stage Dockerfile
- `docker-compose.yml` - local orchestration for all tiers

## Run Locally with Docker

```bash
docker compose up --build
```

## App URLs

- Frontend: http://localhost:4200
- Backend API: http://localhost:8080
- Swagger (API docs): http://localhost:8080/swagger

## Main API Endpoints

- `GET /api/complaints` - list all complaints
- `GET /api/complaints/{id}` - get one complaint
- `POST /api/complaints` - create complaint
- `PUT /api/complaints/{id}/status` - update complaint status

## Stop Stack

```bash
docker compose down
```

To also remove DB volume:

```bash
docker compose down -v
```
