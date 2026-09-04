# 🏃 RaceDay System - Event Management Platform

[![CI/CD](https://github.com/YOUR_USERNAME/RaceDay-System/workflows/Validate%20Documentation/badge.svg)](https://github.com/YOUR_USERNAME/RaceDay-System/actions)
[![GitHub commits](https://img.shields.io/github/commit-activity/m/YOUR_USERNAME/RaceDay-System)](https://github.com/YOUR_USERNAME/RaceDay-System/commits/main)
[![GitHub last commit](https://img.shields.io/github/last-commit/YOUR_USERNAME/RaceDay-System)](https://github.com/YOUR_USERNAME/RaceDay-System/commits/main)
[![GitHub repo size](https://img.shields.io/github/repo-size/YOUR_USERNAME/RaceDay-System)](https://github.com/YOUR_USERNAME/RaceDay-System)

---

## 📋 Table of Contents
- [System Overview](#system-overview)
- [System Roles](#system-roles)
- [Repository Structure](#repository-structure)
- [Documentation Files](#documentation-files)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
- [CI/CD Status](#cicd-status)
- [Commit History](#commit-history)
- [Setup Instructions](#setup-instructions)
- [YouTube Walkthrough](#youtube-walkthrough)
- [Contributors](#contributors)
- [Project Status](#project-status)

---

## System Overview

**RaceDay** is a comprehensive event management system designed for organizing and managing running events, marathons, and races. The system streamlines the entire race lifecycle from event creation to result tracking.

### Key Features
- 🏃 **Event Creation & Management** - Create, update, and manage race events
- 👥 **Participant Registration** - User registration and profile management
- 📊 **Category Management** - Multiple event categories with entry fees
- 💳 **Payment Tracking** - Track participant payments and status
- 🏆 **Race Results** - Record and display race results with positions
- 📈 **Real-time Status** - Event status updates and notifications
- 🔒 **Role-Based Access** - Separate functionality for Organisers and Participants

---

## System Roles

### 1. Organiser 👨‍💼
Organisers are responsible for creating and managing events. They have full control over:

| Capability | Description |
|------------|-------------|
| **Event Management** | Create, update, delete, and cancel events |
| **Category Management** | Add and manage event categories with entry fees |
| **Participant Management** | View all enrolments and participant details |
| **Results Management** | Record and update race results |
| **Event Status** | Open, close, or cancel events as needed |
| **Reports** | View participant statistics and reports |

### 2. Participant 🏃
Participants can register for events and track their performance:

| Capability | Description |
|------------|-------------|
| **Profile Management** | Create and update personal information |
| **Event Discovery** | Browse and search for available events |
| **Enrollment** | Register for events and select categories |
| **Payment** | Process payments for event participation |
| **Results Viewing** | Track personal race results and history |
| **Enrolment Management** | View and cancel enrolments |

---

## Repository Structure
RaceDay-System/
│
├── .github/
│ └── workflows/
│ └── validate-docs.yml # CI/CD workflow for validation
│
├── docs/
│ ├── .gitignore # Docs-specific gitignore
│ ├── .gitkeep # Keeps empty folder in git
│ ├── Endpoint-plan.md # API endpoint plan (21 endpoints)
│ ├── Prog API.pdf # API documentation (PDF)
│ ├── README # Documentation overview
│ ├── Saction A ERD.png # Entity Relationship Diagram
│ ├── Screenshot 2026-09-04 222639.png # Database verification screenshot
│ └── wkrhzjvn.sql # Database schema with sample data
│
├── .gitignore # Root gitignore
└── README.md # This file

text

---

## Documentation Files

All planning and design documents are stored in the `/docs` folder:

| File | Description | Status |
|------|-------------|--------|
| [Saction A ERD.png](docs/Saction%20A%20ERD.png) | Entity Relationship Diagram showing all 6 database entities with relationships, primary keys, foreign keys, and cardinalities | ✅ Complete |
| [wkrhzjvn.sql](docs/wkrhzjvn.sql) | Complete SQL database schema with CREATE TABLE statements, constraints, indexes, and sample data (2 organizers, 2 participants, 3 events) | ✅ Complete |
| [Endpoint-plan.md](docs/Endpoint-plan.md) | Comprehensive RESTful API endpoint plan with 21+ endpoints including authentication, users, events, categories, enrolments, and results | ✅ Complete |
| [Prog API.pdf](docs/Prog%20API.pdf) | Detailed API specification and documentation with request/response examples | ✅ Complete |
| [README](docs/README) | Documentation folder overview with file descriptions and quick start guide | ✅ Complete |
| [Screenshot 2026-09-04 222639.png](docs/Screenshot%202026-09-04%20222639.png) | Database sample data and structure verification | ✅ Complete |
| [.gitignore](docs/.gitignore) | Excludes SQL Server files (*.mdf, *.ldf) and other unnecessary files from docs | ✅ Complete |
| [.gitkeep](docs/.gitkeep) | Ensures the docs folder is tracked by Git even when empty | ✅ Complete |

---

## Database Schema

### Entity Relationship Diagram (ERD)

The database consists of **5 main tables** with relationships:
┌─────────────┐ ┌─────────────┐
│ Users │ │ Events │
├─────────────┤ ├─────────────┤
│ UserID (PK) │1───────N│ EventID(PK) │
│ Email │ │ OrganiserID │
│ Password │ │ EventName │
│ FullName │ │ Description │
│ Role │ │ EventDate │
│ PhoneNumber │ │ Location │
│ CreatedAt │ │ Status │
└─────────────┘ │ MaxPartici. │
│ └─────────────┘
│ │
│1 │1
│ │
N N
┌─────────────┐ ┌─────────────┐
│EventEnrolm. │ │ Categories │
├─────────────┤ ├─────────────┤
│Enrolment(PK)│N───────1│Category(PK) │
│ UserID (FK) │ │ EventID(FK) │
│ EventID(FK) │ │ CategoryName│
│CategoryID(FK│ │ Description │
│ EnrolDate │ │ EntryFee │
│ Status │ └─────────────┘
│ AmountPaid │
│ PaymentStat.│
└─────────────┘
│
│1
│
1
┌─────────────┐
│ Results │
├─────────────┤
│ResultID(PK) │
│Enrolment(FK)│
│ UserID(FK) │
│ EventID(FK) │
│CategoryID(FK│
│ FinishTime │
│ Position │
│ ResultStatus│
│ Notes │
│ CreatedAt │
└─────────────┘

text

### Tables Description

| Table | Description | Key Fields |
|-------|-------------|------------|
| **Users** | Stores all user accounts (Organisers & Participants) | UserID, Email, Role |
| **Events** | Contains all race events | EventID, OrganiserID, EventName |
| **Categories** | Event categories with entry fees | CategoryID, EventID, EntryFee |
| **EventEnrolments** | Tracks participant registrations | EnrolmentID, UserID, EventID, CategoryID |
| **Results** | Stores race results and finishing times | ResultID, EnrolmentID, FinishTime, Position |

### Sample Data
- **2 Organisers** - John Organiser, Jane Organiser
- **2 Participants** - Alex Participant, Taylor Participant
- **3 Events** - Marathon 2026, Trail Running Championship, Charity Fun Run
- **7 Categories** - Full Marathon, Half Marathon, Relay, Elite, Amateur, Adult, Youth
- **4 Enrolments** - Various participants in different events
- **3 Results** - Completed races with times and positions

---

## API Endpoints

### Complete API Endpoint Plan (21 Endpoints)

| Category | Method | Endpoint | Description | Role |
|----------|--------|----------|-------------|------|
| **Authentication** |
| | POST | /api/auth/register | Register new user | Public |
| | POST | /api/auth/login | Login and get JWT token | Public |
| **User Profile** |
| | GET | /api/users/profile | Get user profile | Any (Logged In) |
| | PUT | /api/users/profile | Update user profile | Any (Logged In) |
| **Events** |
| | GET | /api/events | List all events | Public |
| | POST | /api/events | Create new event | Organiser |
| | GET | /api/events/{id} | Get event details | Public |
| | PUT | /api/events/{id} | Update event | Organiser |
| | DELETE | /api/events/{id} | Delete event | Organiser |
| **Categories** |
| | POST | /api/events/{id}/categories | Add category | Organiser |
| | PUT | /api/events/{id}/categories/{cid} | Update category | Organiser |
| | DELETE | /api/events/{id}/categories/{cid} | Delete category | Organiser |
| | GET | /api/events/{id}/categories | Get all categories | Public |
| **Enrolments** |
| | POST | /api/events/{id}/enrol | Enrol in event | Participant |
| | GET | /api/users/enrolments | Get user enrolments | Participant |
| | PUT | /api/events/{id}/enrolments/{eid} | Update enrolment | Participant |
| | DELETE | /api/events/{id}/enrolments/{eid} | Cancel enrolment | Participant |
| **Results** |
| | POST | /api/events/{id}/results | Add results | Organiser |
| | GET | /api/events/{id}/results | Get event results | Public |
| | GET | /api/users/results | Get user results | Participant |

**Statistics:**
- **Total Endpoints**: 21
- **Public Endpoints**: 4
- **Authenticated Endpoints**: 17
- **Organiser Only**: 7
- **Participant Only**: 6

---

## CI/CD Status

### GitHub Actions Workflow

The repository uses GitHub Actions for automated validation with every push.

![Successful Build](docs/Screenshot%202026-09-04%20222639.png)

### What Gets Validated:
- ✅ `/docs` folder exists
- ✅ ERD file present (`Saction A ERD.png`)
- ✅ SQL script present (`wkrhzjvn.sql`)
- ✅ Endpoint plan present (`Endpoint-plan.md`)
- ✅ Minimum 20 commits requirement
- ✅ SQL file contains CREATE TABLE statements
- ✅ SQL file contains INSERT statements
- ✅ README.md exists in root

### Workflow Configuration

```yaml
name: Validate Documentation

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  validate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check docs folder
        run: |
          if [ -d "docs" ]; then
            echo "✅ docs folder exists"
          else
            echo "❌ docs folder missing"
            exit 1
          fi
      - name: Check required files
        run: |
          REQUIRED_FILES=("Saction A ERD.png" "wkrhzjvn.sql" "Endpoint-plan.md")
          for file in "${REQUIRED_FILES[@]}"; do
            if [ -f "docs/$file" ]; then
              echo "✅ docs/$file exists"
            else
              echo "❌ docs/$file is missing"
              exit 1
            fi
          done
