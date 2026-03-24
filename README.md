# City Complaint (3 Microservices)

This app is now split into 3 backend microservices:

1. Complaint Service (`complaint-service`)
- Citizen issues complaint
- Endpoint: `POST /api/complaints`

2. Admin Service (`admin-service`)
- Admin updates complaint progress/status
- Endpoints:
  - `GET /api/admin/complaints`
  - `PUT /api/admin/complaints/{id}/status`

3. Progress Service (`progress-service`)
- Citizen views progress
- Endpoints:
  - `GET /api/progress`
  - `GET /api/progress/{id}`

## Frontend Portals

- Citizen Portal:
  - Issue complaint
  - View progress with color status

- Admin Portal:
  - View complaints
  - Update status (`Open`, `In Progress`, `Dismissed`, `Done`)

Status colors in the UI:
- `In Progress`: amber
- `Dismissed`: red
- `Done`: green

## Run

```bash
docker compose up --build
```

## URLs

- Frontend: `http://localhost:4200`
- Complaint Service: `http://localhost:8081`
- Admin Service: `http://localhost:8082`
- Progress Service: `http://localhost:8083`
- PostgreSQL host port: `5433`

## Stop

```bash
docker compose down
```
