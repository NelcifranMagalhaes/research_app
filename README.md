# README

This project is a interview test based in this [repository](https://github.com/pin-people/tech_playground)

I implemented this tasks:

- Task 1: Create a Basic Database
- Task 3: Create a Test Suite
- Task 4: Create a Docker Compose Setup
- Task 9: Build a Simple API

# How to run

The project use docker and docker compose to build and run locally.

- Install docker and docker compose, i recommend this [tutorial](https://dev.to/kingyou/complete-guide-installing-docker-and-docker-compose-step-by-step-24e1), or just google it.

- Run inside the project's folder docker  `compose up --build`

- Use some request interface like [insominia](https://insomnia.rest/download) and make a get request to 
`http://localhost:3000/up` to check the service is up.

# API Endpoints

## Health Check

### Check Server Status
- **URL:** `/up`
- **Method:** `GET`
- **Description:** Verifies if the server is running properly
- **Response:** 
  - **200 OK:** Server is healthy
  - **500 Internal Server Error:** Server has issues

**Example:**
```bash
curl http://localhost:3000/up
```

---

## Research Import

### Import CSV File
- **URL:** `/v1/research_import`
- **Method:** `POST`
- **Description:** Uploads and queues a CSV file for processing and data import
- **Content-Type:** `multipart/form-data`
- **Parameters:**
  - `file` (required): CSV file to import

**Example:**
```bash
curl -X POST http://localhost:3000/v1/research_import \
  -F "file=@/path/to/sample.csv"
```

**Response (202 Accepted):**
```json
{
  "message": "Import queued",
  "file": "sample.csv",
  "job_id": "abc123-def456"
}
```

**Error Response (400 Bad Request):**
```json
{
  "error": "No file uploaded"
}
```

### Reset Database
- **URL:** `/v1/reset_database`
- **Method:** `DELETE`
- **Description:** Queues a job to reset the entire database (deletes all data)
- **⚠️ Warning:** This action is destructive and cannot be undone

**Example:**
```bash
curl -X DELETE http://localhost:3000/v1/reset_database
```

**Response (202 Accepted):**
```json
{
  "message": "Database reset queued"
}
```

---

## Employees

### List All Employees
- **URL:** `/v1/employees`
- **Method:** `GET`
- **Description:** Returns a paginated list of all employees
- **Query Parameters:**
  - `page` (optional): Page number (default: 1)
  - `items` (optional): Items per page (default: 20)

**Example:**
```bash
curl http://localhost:3000/v1/employees
curl http://localhost:3000/v1/employees?page=2&items=10
```

**Response (200 OK):**
```json
{
  "links": {
    "first": "http://localhost:3000/v1/employees?page=1",
    "last": "http://localhost:3000/v1/employees?page=5",
    "prev": null,
    "next": "http://localhost:3000/v1/employees?page=2"
  },
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "personal_email": "john@example.com",
      "corporate_email": "john@company.com",
      "gender": "Male",
      "generation": "Millennial",
      "company_tenure": "5 years",
      "created_at": "2026-02-19T10:00:00.000Z",
      "updated_at": "2026-02-19T10:00:00.000Z"
    }
  ]
}
```

---

## Organizations

### List All Organizations
- **URL:** `/v1/organizations`
- **Method:** `GET`
- **Description:** Returns a paginated list of all organizations
- **Query Parameters:**
  - `page` (optional): Page number (default: 1)
  - `items` (optional): Items per page (default: 20)

**Example:**
```bash
curl http://localhost:3000/v1/organizations
curl http://localhost:3000/v1/organizations?page=1&items=50
```

**Response (200 OK):**
```json
{
  "links": {
    "first": "http://localhost:3000/v1/organizations?page=1",
    "last": "http://localhost:3000/v1/organizations?page=3",
    "prev": null,
    "next": "http://localhost:3000/v1/organizations?page=2"
  },
  "data": [
    {
      "id": 1,
      "company_name": "Tech Corp",
      "company_role": "Developer",
      "localization": "São Paulo",
      "job_title": "Senior Developer",
      "board": "Technology",
      "department": "Engineering",
      "management": "Backend Team",
      "area": "API Development",
      "administration": "Tech Office",
      "created_at": "2026-02-19T10:00:00.000Z",
      "updated_at": "2026-02-19T10:00:00.000Z"
    }
  ]
}
```

---

## Questions

### List All Questions
- **URL:** `/v1/questions`
- **Method:** `GET`
- **Description:** Returns a paginated list of all survey questions
- **Query Parameters:**
  - `page` (optional): Page number (default: 1)
  - `items` (optional): Items per page (default: 20)

**Example:**
```bash
curl http://localhost:3000/v1/questions
```

**Response (200 OK):**
```json
{
  "links": {
    "first": "http://localhost:3000/v1/questions?page=1",
    "last": "http://localhost:3000/v1/questions?page=2",
    "prev": null,
    "next": "http://localhost:3000/v1/questions?page=2"
  },
  "data": [
    {
      "id": 1,
      "theme": "Career Development",
      "created_at": "2026-02-19T10:00:00.000Z",
      "updated_at": "2026-02-19T10:00:00.000Z"
    }
  ]
}
```

---

## Survey Responses

### List All Survey Responses
- **URL:** `/v1/survey_responses`
- **Method:** `GET`
- **Description:** Returns a paginated list of all survey responses
- **Query Parameters:**
  - `page` (optional): Page number (default: 1)
  - `items` (optional): Items per page (default: 20)

**Example:**
```bash
curl http://localhost:3000/v1/survey_responses
```

**Response (200 OK):**
```json
{
  "links": {
    "first": "http://localhost:3000/v1/survey_responses?page=1",
    "last": "http://localhost:3000/v1/survey_responses?page=10",
    "prev": null,
    "next": "http://localhost:3000/v1/survey_responses?page=2"
  },
  "data": [
    {
      "id": 1,
      "employee_id": 1,
      "organization_id": 1,
      "question_id": 1,
      "answer_date": "2026-02-15",
      "score": 5,
      "comment": "Great workplace!",
      "created_at": "2026-02-19T10:00:00.000Z",
      "updated_at": "2026-02-19T10:00:00.000Z"
    }
  ]
}
```

### Get Survey Responses by Employee
- **URL:** `/v1/survey_responses_by_employee`
- **Method:** `GET`
- **Description:** Returns survey responses filtered by employee ID
- **Query Parameters:**
  - `employee_id` (required): The ID of the employee
  - `page` (optional): Page number (default: 1)
  - `items` (optional): Items per page (default: 20)

**Example:**
```bash
curl http://localhost:3000/v1/survey_responses_by_employee?employee_id=1
```

**Response (200 OK):**
```json
{
  "links": {
    "first": "http://localhost:3000/v1/survey_responses_by_employee?employee_id=1&page=1",
    "last": "http://localhost:3000/v1/survey_responses_by_employee?employee_id=1&page=2",
    "prev": null,
    "next": "http://localhost:3000/v1/survey_responses_by_employee?employee_id=1&page=2"
  },
  "data": [
    {
      "id": 1,
      "employee_id": 1,
      "organization_id": 1,
      "question_id": 1,
      "answer_date": "2026-02-15",
      "score": 5,
      "comment": "Great workplace!",
      "created_at": "2026-02-19T10:00:00.000Z",
      "updated_at": "2026-02-19T10:00:00.000Z"
    }
  ]
}
```

**Error Response (400 Bad Request):**
```json
{
  "error": "employee_id is required"
}
```

---

## Notes

- All endpoints return JSON responses
- Pagination is implemented using the [Pagy gem](https://github.com/ddnexus/pagy)
- Default page size is 10 items
- Background jobs are processed asynchronously using Solid Queue
- Test implemented using the default rails test, just run `rails test`
- Quality code is implemented with [Rubocop gem](https://github.com/rubocop/rubocop)