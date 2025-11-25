# 📱 HabitSync – Habit Tracking App

A **Flutter-based habit tracking application** with a **Spring Boot + MongoDB backend**.  
The app allows users to create habits, track streaks, view statistics, and receive smart reminders.  
The backend handles authentication, habit storage, analytics, and secure APIs.

---

## 🎯 Features Implemented

- User authentication with **JWT**
- Create a new habit
- View all habits
- Edit habits
- Delete habits
- Mark habit completion
- Track daily streak
- Weekly habit progress
- View habit statistics
- User profile API
- Smart scheduled reminders

**Bonus Features:**  
- Motivational quotes  
- Instant test notification  

 ## 📝 Instructions

### 1️⃣ TO run server from frontend Setup
 - Navigate to the frontend folder:
 - cd frontend
 - flutter pub get
 - flutter run
## Update the backend host in frontend/lib/helpers/constants.dart:
 - const String host = "YOUR_LOCAL_IP"; // e.g., 192.168.1.10 or 127.0.0.1(To get your local ip run ipconfig in your terminal or command prompt.)
 - const int port = 8080;
 - String baseUrl = "http://$host:$port";

## 🖼 Screenshots

| Splash Screen | Login Screen | Singup Screen |
|--------------|-----------|--------------|
| ![Splash](frontend/assets/screenshots/splash.png) | ![Login](frontend/assets/screenshots/login.png) | ![Singup](frontend/assets/screenshots/singup.png) |

| Home Screen | Add Habit | Statics Screen | Profile Screen |
|--------------|-----------|--------------|
| ![Home](frontend/assets/screenshots/home.png) | ![Habits](frontend/assets/screenshots/add.png) | ![Statics](frontend/assets/screenshots/stats.png) | ![profile](frontend/assets/screenshots/profile.png) |



---

## 🛠 Prerequisites

- Java Springboot (for backend)  
- Flutter SDK (for frontend)  
- MongoDB (local or cloud)  
- Device or emulator for Flutter app  

---

## 🔹 Backend Setup

```bash
cd Backend
mvn clean install
mvn spring-boot:run



