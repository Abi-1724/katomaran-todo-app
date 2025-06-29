# Katomaran Todo App

A **cross-platform Todo Task Manager** built for the Katomaran Hackathon 2025.  
This project includes a **Flutter mobile/web frontend** and a **Node.js + MongoDB backend**, featuring Google Login, task CRUD, and responsive UI.
## Features

- Google Sign-In authentication
- Create, Read, Update, Delete (CRUD) for tasks
- Filter tasks (Completed, Active, Overdue)
- Pull-to-refresh & Swipe-to-delete
- Responsive design (Mobile & Web support)
- Connected to MongoDB Atlas
- Secure environment with `.env` excluded from repo
## Tech Stack

| Frontend        | Backend        | Database     | Auth             |
|----------------|----------------|--------------|------------------|
| Flutter (Dart) | Node.js (Express) | MongoDB Atlas | Google OAuth 2.0 |

## Screenshots

![Screenshot (331)](https://github.com/user-attachments/assets/291e36b2-b667-47bd-8e34-686e49e967cc)
![Screenshot (332)](https://github.com/user-attachments/assets/a4a5f070-5e02-4188-b17c-7965a07a3ac4)
![Screenshot (333)](https://github.com/user-attachments/assets/d616d952-1469-49d6-92f1-41efd5213729)


- Login Page
- Task List with Filters
- Add/Edit Task UI

---

## 📽Demo Video


https://github.com/user-attachments/assets/ae750e53-b9bf-46cf-9233-5c20e5291172





### Backend

cd katomaran-todo-backend
npm install
# Create .env file with MONGO_URI and Google credentials
node server.js

## Frontend (Flutter Web or Mobile)
cd katomaran_todo_app
flutter pub get
flutter run -d chrome 

## Environment Variables (.env)
MONGO_URI=your_mongodb_uri
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret

## Folder Structure
katomaran-todo-backend/
│
├── controllers/
├── models/
├── routes/
├── .env              # Not tracked by Git
├── server.js
│
katomaran_todo_app/
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── widgets/



Author
Abinaya P
Katomaran Hackathon 2025 Submission
GitHub: Abi-1724
