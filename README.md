# 📝 Katomaran Todo App

A **cross-platform Todo Task Manager** built for the Katomaran Hackathon 2025.  
This project includes a **Flutter mobile/web frontend** and a **Node.js + MongoDB backend**, featuring Google Login, task CRUD, and responsive UI.

---

## 🚀 Features

- 🔐 Google Sign-In authentication
- ✅ Create, Read, Update, Delete (CRUD) for tasks
- 🌓 Filter tasks (Completed, Active, Overdue)
- 🔄 Pull-to-refresh & Swipe-to-delete
- 📱 Responsive design (Mobile & Web support)
- ☁️ Connected to MongoDB Atlas
- 📦 Secure environment with `.env` excluded from repo

---

## 🛠️ Tech Stack

| Frontend        | Backend        | Database     | Auth             |
|----------------|----------------|--------------|------------------|
| Flutter (Dart) | Node.js (Express) | MongoDB Atlas | Google OAuth 2.0 |

---

## 📸 Screenshots

_Add your screenshots here:_

- Login Page
- Task List with Filters
- Add/Edit Task UI

---

## 📽️ Demo Video

_Add a link to your demo video (e.g., YouTube or Google Drive)._

---

## 🧑‍💻 Getting Started (For Reviewers)

### ✅ Backend

```bash
cd katomaran-todo-backend
npm install
# Create .env file with MONGO_URI and Google credentials
node server.js
