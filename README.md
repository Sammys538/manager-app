# Manager App

[![Flutter](https://img.shields.io/badge/Flutter-3.0-blue?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-2.18-blue?logo=dart)](https://dart.dev/)
[![SQL](https://img.shields.io/badge/SQL-MySQL-orange?logo=mysql)](https://www.mysql.com/)

## Overview
Manager App is a Flutter-based mobile application designed to help communities organize and manage their operations efficiently. The app allows users to add and view tasks, offerings, and other community entries through a simple and intuitive interface. The project demonstrates clean architecture principles and modular design, making it easy to extend and integrate with backend services or additional features in the future.

## Features
- User-friendly interface for managing community operations
- Add new tasks, offerings, and entries
- View and organize community-related information
- Clean, modular architecture for scalability
- Ready for future backend and notifications integration

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0)  
- Dart SDK (>=2.18)  
- Android Studio or VS Code with Flutter plugin  
- Connected device or emulator
- MySQL installed locally or accessible remotely
- Backend server running locally or accessible remotely (see Backend Setup below)

### Database Setup
1. Ensure MySQL is installed and running.
2. Create the database:
```sql
CREATE DATABASE manager_app;
```
3. Create a `.env` file in the `backend` folder and fill in with your SQL credentials:
```
DB_HOST=localhost
DB_USER=your_mysql_user
DB_PASSWORD=your_password
DB_NAME=manager_app
DB_PORT=3306
PORT=3000
JWT_SECRET=your_jwt_secret
```
4. Run the database schema to create tables
```bash
mysql -u your_mysql_user -p manager_app < backend/ManagementAppSQL.sql
```

### Backend Setup
Before running the app, make sure the backend is running. If you are using the included backend service:
1. Navigate to the backend folder:
   ```bash
   cd backend
2. Install Dependencies:
   ```bash
   npm install
3. Start the Backend Server:
   ```bash
   node server.js
4. Ensure the backend is accessible at the expected API endpoint (e.g., http://localhost:3000)

### Local Setup (Flutter)
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/manager_app.git
   cd manager_app

2. Install dependencies:
   ```bash
   flutter pub get

3. Run the app:
   ```bash
   flutter run

## Usage
- Start the backend server first (node server.js)
- Launch the Flutter app on your emulator or device
- Navigate through screens to add and view transactions or offerings
- All data operations (add/view) communicate with the backend server

## Project Structure
```
manager_app/
├── ManagementAppSQL.sql # Databse Schema 
├── backend/             # Node.js backend
│ ├── modules/           # Core backend modules
│ │ ├── Offerings.js
│ │ ├── Summary.js
│ │ ├── Transaction.js
│ │ └── User.js
│ ├── routes/            # API routes
│ │ ├── auth.js
│ │ ├── offerings.js
│ │ ├── summary.js
│ │ └── transaction.js
│ ├── utils/             # Utility functions
│ │ └── hash.js
│ ├── db.js              # Database connection
│ ├── server.js          # Main backend server
│ ├── package.json
│ └── package-lock.json
├── lib/                 # Flutter frontend source code
│ ├── models/            # Data models
│ │ └── summary.dart
│ ├── screens/           # UI screens
│ │ ├── add_transaction.dart
│ │ ├── home_screen.dart
│ │ ├── login.dart
│ │ ├── offerings_list.dart
│ │ ├── offerings_screen.dart
│ │ ├── sign_up.dart
│ │ └── transaction_list.dart
│ ├── services/         # API service calls to backend
│ │ └── api_service.dart
│ ├── widgets/          # Reusable widgets/components
│ │ └── line_chart_sample.dart
│ └── main.dart         # App entry point
├── pubspec.yaml        # Flutter dependencies and project config
├── README.md           # Project documentation
├── .gitignore          # Files and folders to ignore in Git
└── ...                 # Other config files  
