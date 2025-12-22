CS310 – MealMate (Step 3)

Project Overview

MealMate is a Flutter-based mobile application developed as part of the CS310 course.
The goal of Step 3 is to extend the Step 2 UI prototype by integrating a Firebase backend, state management, and real-time data persistence.

In Step 3, the application supports user authentication, cloud data storage, and real-time UI updates using Firebase and Provider.

⸻

Step 3 Features
	•	Firebase Authentication (Email & Password)
	•	Cloud Firestore database integration
	•	CRUD operations for recipes
	•	Real-time UI updates using StreamBuilder
	•	State management with Provider and ChangeNotifier
	•	Local persistence with SharedPreferences
	•	Basic security rules to protect user data

⸻

Technologies Used
	•	Flutter / Dart
	•	Firebase Authentication
	•	Cloud Firestore
	•	Provider (State Management)
	•	SharedPreferences

⸻

Team Members & Contribution Breakdown (Step 3)

Rayen Tabassi
	•	Firestore integration for recipes
	•	CRUD operations (Create, Read, Update, Delete)
	•	Real-time updates using StreamBuilder
	•	Service layer design (AuthService, DatabaseService)
	•	SharedPreferences implementation (remember email / settings)
	•	Firebase configuration and project setup
	•	Debugging, refactoring, and final integration
	•	GitHub branch management and cleanup

⸻

Ceyhun Etiz
  •	Firebase Authentication integration (sign up, login, logout)
	•	Provider setup for authentication state management
	•	Initial Flutter project structure
	•	Base UI implementation from Step 2
	•	Navigation structure between screens
	•	UI screens used as foundation for Step 3

⸻

Doruk Kocam
	•	UI screen implementations
	•	Layout adjustments and widget organization
	•	Support for recipe-related screens in Step 2
	•	Assisted with UI consistency across pages

⸻

Emir Akcasari
	•	UI components and early screen designs
	•	Initial recipe and ingredient screen implementations
	•	Helped define basic app flow in Step 2

⸻

Emir Ceylan
	•	Contributed to Step 2 UI in early stages
	•	Existing files were refactored and updated to work with the new Firebase-based implementation

⸻

Architecture Overview
	•	UI Layer: Flutter screens (presentation)
	•	State Management: Provider + ChangeNotifier
	•	Service Layer:
	•	AuthService → Firebase Authentication
	•	DatabaseService → Firestore operations
	•	Persistence:
	•	Cloud: Firestore
	•	Local: SharedPreferences

⸻

Firebase Structure
	•	Users Collection
	•	Stores user-related data
	•	Recipes Collection
	•	Fields include title, ingredients, createdBy, createdAt
	•	Access restricted so users can only modify their own recipes

⸻

Real-Time Data Handling
	•	Firestore listeners (.snapshots())
	•	UI updates automatically without manual refresh
	•	Implemented using StreamBuilder across relevant screens
