# ned_finder

`ned_finder` is a cross-platform Lost & Found Management System created for **NED University of Engineering & Technology (NEDUET)**. It allows students, faculty, and staff to easily **report lost items, submit found items, claim belongings, and communicate securely**. The system replaces manual searching with a smart, centralized, and user-friendly digital platform.

---

## Overview

This project is a monorepo that contains:

- **`ned_finder_app/`** – A Flutter-based mobile & desktop app used by end users.
- **`ned_finder_api/`** – A Python FastAPI backend managing authentication, items, images, and database logic.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend API Setup](#backend-api-setup)
  - [Frontend App Setup](#frontend-app-setup)
- [Configuration](#configuration)
- [License](#license)

---

## Features

### ✔ User Features
- Post **Lost Items** with image, description, and location.
- Post **Found Items** for others to verify.
- Submit claims with **proof and contact details**.
- Browse all approved lost/found items.
- Edit or delete previously posted items.

### ✔ Admin Features
- Approve or reject item submissions.
- Reject items with a stated reason.
- Manage pending, approved, and rejected lists.

### ✔ Technical Features
- FastAPI backend.
- Secure image uploads.
- Fully responsive Flutter UI.
- MySQL-backed persistent storage.

---

## Tech Stack

- **Frontend:** Flutter  
- **Backend:** Python (FastAPI)  
- **Database:** MySQL (via SQLAlchemy ORM)  
- **Supported Platforms:** Android, Windows, Linux  

---

## Project Structure

```
ned_finder/
├── ned_finder_api/        # Python FastAPI backend
│   ├── app/
│   │   ├── routes/
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── services/
│   │   ├── database.py
│   │   └── main.py
│   ├── venv/
│   └── ...
│
├── ned_finder_app/        # Flutter frontend application
│   ├── android/
│   ├── lib/
│   ├── windows/
│   ├── linux/
│   └── ...
│
└── README.md
```

---

## Getting Started

### Prerequisites

Install the following:

- Flutter SDK (latest)
- Python 3.8+
- pip
- MySQL Server 8.0+
- MySQL Workbench or CLI
- Any IDE (VS Code, Android Studio, PyCharm)

---

## Backend API Setup

1. Navigate to the backend folder:

```sh
cd ned_finder_api
cd SE_API
```

2. Create and activate a virtual environment:

**Windows:**
```sh
python -m venv venv
.env\Scripts\ctivate
```

**Linux/macOS:**
```sh
python3 -m venv venv
source venv/bin/activate
```

3. Install dependencies:

```sh
pip install -r requirements.txt
```
4. create database(only one time):

```sh
python database.py
```

5. Run the API server:

```sh
uvicorn main:app --reload
```

The server runs at:

```
http://127.0.0.1:8000
```

---

## Frontend App Setup

1. Navigate to the Flutter project:

```sh
cd ned_finder_app
```

2. Install dependencies:

```sh
flutter pub get
```

3. Run the application:

```sh
flutter run
```

---

## Configuration

### Backend Environment Variables

Create a `.env` file inside `ned_finder_api/`:

```
DATABASE_URL="mysql+pymysql://username:password@localhost:3306/ned_finder"
SECRET_KEY="your_secret_key"
ALGORITHM="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES=1440
```

### Frontend API Base URL

Update:

```
lib/utils/http/http_client.dart
```

Example:

```dart
static const String _baseUrl = "http://192.168.0.103:8000";
```

---

## License

This project currently has **no license**.  
You may add MIT, Apache 2.0, or GPL depending on requirements.
