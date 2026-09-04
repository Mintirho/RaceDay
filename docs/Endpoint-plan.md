# RaceDay API Endpoint Plan

## Authentication Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/auth/register | Register a new user account | None (Public) | { "email": "string", "password": "string", "fullName": "string", "phoneNumber": "string", "role": "string" } | 201 Created - User registered, 400 Bad Request - Validation error, 409 Conflict - Email exists |
| POST | /api/auth/login | Authenticate user and return JWT token | None (Public) | { "email": "string", "password": "string" } | 200 OK - JWT token and user details, 401 Unauthorized - Invalid credentials |

## User Profile Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/users/profile | Get current user's profile information | Any (Logged In) | None | 200 OK - User profile data, 401 Unauthorized - Not logged in |
| PUT | /api/users/profile | Update current user's profile information | Any (Logged In) | { "fullName": "string", "phoneNumber": "string" } | 200 OK - Updated profile, 400 Bad Request - Invalid data, 401 Unauthorized - Not logged in |

## Event Management Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/events | Get list of all events with filters | None (Public) | None | 200 OK - Array of events with pagination, 500 Internal Server Error |
| POST | /api/events | Create a new event | Organiser | { "eventName": "string", "description": "string", "eventDate": "datetime", "location": "string", "maxParticipants": "int", "registrationDeadline": "datetime" } | 201 Created - Event details, 400 Bad Request - Validation error, 401 Unauthorized - Not logged in, 403 Forbidden - Not an organiser |
| GET | /api/events/{eventId} | Get specific event details | None (Public) | None | 200 OK - Event details, 404 Not Found - Event doesn't exist |
| PUT | /api/events/{eventId} | Update an existing event | Organiser | { "eventName": "string", "description": "string", "eventDate": "datetime", "location": "string", "maxParticipants": "int", "status": "string" } | 200 OK - Updated event, 400 Bad Request - Invalid data, 401 Unauthorized - Not logged in, 403 Forbidden - Not the event organiser, 404 Not Found - Event doesn't exist |
| DELETE | /api/events/{eventId} | Delete an event (soft delete) | Organiser | None | 200 OK - Event deleted, 401 Unauthorized - Not logged in, 403 Forbidden - Not the event organiser, 404 Not Found - Event doesn't exist |

## Category Management Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/events/{eventId}/categories | Add a category to an event | Organiser | { "categoryName": "string", "description": "string", "entryFee": "decimal" } | 201 Created - Category details, 400 Bad Request - Invalid data, 401 Unauthorized - Not logged in, 403 Forbidden - Not the event organiser, 404 Not Found - Event doesn't exist |
| PUT | /api/events/{eventId}/categories/{categoryId} | Update an event category | Organiser | { "categoryName": "string", "description": "string", "entryFee": "decimal" } | 200 OK - Updated category, 400 Bad Request - Invalid data, 401 Unauthorized - Not logged in, 403 Forbidden - Not the event organiser, 404 Not Found - Category doesn't exist |
| DELETE | /api/events/{eventId}/categories/{categoryId} | Delete an event category | Organiser | None | 200 OK - Category deleted, 401 Unauthorized - Not logged in, 403 Forbidden - Not the event organiser, 404 Not Found - Category doesn't exist |
| GET | /api/events/{eventId}/categories | Get all categories for an event | None (Public) | None | 200 OK - Array of categories, 404 Not Found - Event doesn't exist |

## Event Enrolment Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/events/{eventId}/enrol | Enrol in an event and category | Participant | { "categoryId": "int", "amountPaid": "decimal" } | 201 Created - Enrolment details, 400 Bad Request - Validation error, 401 Unauthorized - Not logged in, 403 Forbidden - Not a participant, 404 Not Found - Event/Category doesn't exist, 409 Conflict - Already enrolled or event full |
| GET | /api/users/enrolments | Get all enrolments for current user | Participant | None | 200 OK - Array of enrolments, 401 Unauthorized - Not logged in, 403 Forbidden - Not a participant |
| PUT | /api/events/{eventId}/enrolments/{enrolmentId} | Update enrolment status | Participant | { "status": "string" } | 200 OK - Updated enrolment, 400 Bad Request - Invalid data, 401 Unauthorized - Not logged in, 403 Forbidden - Not the enrollee, 404 Not Found - Enrolment doesn't exist |
| DELETE | /api/events/{eventId}/enrolments/{enrolmentId} | Cancel enrolment in event | Participant | None | 200 OK - Enrolment cancelled, 401 Unauthorized - Not logged in, 403 Forbidden - Not the enrollee, 404 Not Found - Enrolment doesn't exist |

## Results Endpoints

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/events/{eventId}/results | Add results for participants | Organiser | { "enrolmentId": "int", "finishTime": "time", "position": "int", "resultStatus": "string", "notes": "string" } | 201 Created - Result details, 400 Bad Request - Invalid data, 401 Unauthorized - Not logged in, 403 Forbidden - Not the event organiser, 404 Not Found - Enrolment doesn't exist, 409 Conflict - Result already exists |
| GET | /api/events/{eventId}/results | Get all results for an event | None (Public) | None | 200 OK - Array of results, 404 Not Found - Event doesn't exist |
| GET | /api/users/results | Get results for current user | Participant | None | 200 OK - Array of user results, 401 Unauthorized - Not logged in, 403 Forbidden - Not a participant |

## Summary Statistics

- **Total Endpoints**: 21
- **Authentication**: 2 endpoints
- **User Profile**: 2 endpoints
- **Event Management**: 5 endpoints
- **Category Management**: 4 endpoints
- **Event Enrolments**: 4 endpoints
- **Results**: 3 endpoints
- **Public Endpoints**: 4 endpoints
- **Authenticated Endpoints**: 17 endpoints
- **Organiser Only**: 7 endpoints
- **Participant Only**: 6 endpoints
