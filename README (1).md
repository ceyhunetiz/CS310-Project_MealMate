# MealMate

> A mobile app that brings students and cooking together on a budget!

## About

MealMate is a comprehensive Flutter-based mobile application specifically designed for students who struggle with food budgeting and meal planning. The app addresses the common challenges students face: limited cooking knowledge, tight budgets, and difficulty managing groceries efficiently.

### The Problem

Students often face several challenges when it comes to food:
- Limited budget for groceries and meals
- Lack of cooking experience and recipe knowledge
- Waste of ingredients due to poor planning
- Difficulty finding affordable, healthy meal options
- Time constraints for meal preparation

### The Solution

MealMate solves these problems by providing an all-in-one platform that:
- Suggests recipes based on ingredients you already have
- Calculates meal costs and keeps you within budget
- Integrates with local grocery stores for easy shopping
- Helps plan weekly meals to minimize waste
- Builds a personalized cookbook of your favorite recipes

### Key Features

- **Smart Recipe Matching**
  - Enter your available ingredients
  - Get instant recipe suggestions that match what you have
  - Discover creative ways to use leftover ingredients

- **Budget-Friendly Shopping**
  - Integration with online grocery stores (e.g., Migros)
  - Real-time price tracking for ingredients
  - Automatic calculation of total meal costs
  - Suggestions for cheaper ingredient alternatives

- **Intelligent Meal Planning**
  - Set your weekly spending limit
  - Get personalized meal plans that fit your budget
  - Calendar view for planning meals ahead
  - Nutritional information for balanced eating

- **Recipe Management**
  - Save favorite recipes to your personal cookbook
  - Upload and share your own recipes with the community
  - Rate and review recipes
  - Filter recipes by cuisine, difficulty, and cooking time

- **Smart Shopping Cart**
  - Track ingredients and costs in real-time
  - Organize items by store sections
  - View shopping history and spending patterns
  - One-tap reordering of frequently bought items

- **User Profiles & History**
  - Personalized cookbook with all saved recipes
  - Track your cooking journey
  - View past meals and shopping history
  - Save dietary preferences and restrictions

## Tech Stack

### Frontend
- **Framework:** Flutter 3.35.7
- **Language:** Dart 3.9.2
- **UI Components:** Material Design 3
- **Navigation:** Flutter Navigator 2.0

### Backend & Services
- **Authentication:** Firebase Authentication
  - Email/password authentication
  - User session management
  - Secure authentication flow
- **Database:** Cloud Firestore
  - Real-time data synchronization
  - NoSQL document-based storage
  - Offline data persistence
- **Storage:** Firebase Cloud Storage (for recipe images)

### State Management
- **Primary:** Provider with ChangeNotifier
  - Authentication state management
  - App-wide data state
  - Reactive UI updates
- **Local Storage:** SharedPreferences
  - User preferences (theme, settings)
  - Cache management

### Development Tools
- **IDE:** VS Code / Android Studio
- **Version Control:** Git & GitHub
- **Testing:** Flutter Test Framework

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── mainmenu.dart                      # Main menu navigation
├── signUp.dart                        # User registration
├── ingredients_page.dart              # Ingredients & recipes view
├── find_recipe_method_screen.dart     # Recipe search
├── meal_mode_screen.dart              # Meal planning
├── saved_recipes_screen.dart          # Saved recipes
├── shopping_history_screen.dart       # Purchase history
├── emirc_recipe_info_screen.dart      # Recipe details
├── emirc_shopping_cart_screen.dart    # Shopping cart
├── my_uploads_screen.dart             # User-uploaded recipes
└── profile_cookbook_screen.dart       # User profile & cookbook
```

## Getting Started

### Prerequisites

- **Flutter SDK** 3.35.7 or higher
- **Dart** 3.9.2 or higher
- **IDE:** Android Studio or VS Code with Flutter/Dart extensions
- **Firebase Account** (for backend services)
- **Git** for version control
- **Android SDK** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/ceyhunetiz/CS310-Project_MealMate.git
cd CS310-Project_MealMate
```

2. **Install Flutter dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**

   a. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)

   b. Enable the following services:
      - Firebase Authentication (Email/Password)
      - Cloud Firestore
      - Cloud Storage

   c. Download configuration files:
      - For Android: `google-services.json` → place in `android/app/`
      - For iOS: `GoogleService-Info.plist` → place in `ios/Runner/`

   d. Update Firestore Security Rules (see below)

4. **Run the app**
```bash
# Check for issues
flutter doctor

# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release
```

### Firestore Security Rules

Add these rules to your Firebase Console under Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Recipes can be read by anyone, but only modified by creator
    match /recipes/{recipeId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null &&
                               request.auth.uid == resource.data.createdBy;
    }

    // Shopping carts are private to users
    match /shoppingCarts/{cartId} {
      allow read, write: if request.auth != null &&
                            request.auth.uid == resource.data.userId;
    }
  }
}
```

## Architecture

MealMate follows a clean architecture pattern with clear separation of concerns:

### Layers

1. **Presentation Layer** (UI/Screens)
   - All `*_screen.dart` files
   - Handles user interaction and display
   - Consumes data from providers

2. **State Management Layer** (Providers)
   - Provider classes with ChangeNotifier
   - Manages app state and business logic
   - Notifies UI of state changes

3. **Data Layer** (Services/Repositories)
   - Firebase service classes
   - API communication
   - Data transformation and caching

4. **Model Layer**
   - Data models/entities
   - JSON serialization/deserialization

### Key Design Patterns

- **Provider Pattern:** For state management and dependency injection
- **Repository Pattern:** For data access abstraction
- **Singleton Pattern:** For service instances (Firebase, etc.)
- **Factory Pattern:** For creating model instances from JSON

## Features Breakdown

### Current Features (Step 2)
- User interface for all major screens
- Navigation between different app sections
- Static recipe display
- Shopping cart UI
- Profile and cookbook UI

### In Progress (Step 3)
- Firebase Authentication integration
- Cloud Firestore database setup
- Provider state management
- Real-time data synchronization
- CRUD operations for recipes and shopping lists
- User preference persistence

### Planned Features (Future)
- Recipe recommendation algorithm
- Grocery store API integration
- Nutrition tracking
- Social features (share recipes, follow users)
- Push notifications for meal reminders
- Barcode scanning for ingredients

## Development Progress

### Step 1: Project Proposal (Completed)
- Project concept and requirements definition
- Team formation and task distribution
- Initial planning and documentation

### Step 2: UI/UX Design (Completed)
- Wireframes and mockups in Figma
- Implementation of all major screens
- Navigation flow setup
- Material Design theming

### Step 3: Firebase Backend & State Management (In Progress)
**Deadline:** December 21, 2025

Current tasks:
- [ ] Firebase project setup and configuration
- [ ] User authentication (signup, login, logout)
- [ ] Firestore data model design
- [ ] Provider state management implementation
- [ ] CRUD operations for recipes
- [ ] Real-time UI updates
- [ ] SharedPreferences for user settings
- [ ] Security rules implementation
- [ ] Testing and bug fixes
- [ ] Demo video preparation

## Team

| Name                      | Student ID |
|---------------------------|:----------:|
| Teoman Ceyhun Etiz        | 33560      |
| Rayen Tabassi             | 33581      |
| Doruk Kocaman             | 34103      |
| Emir Ceylan               | 34110      |
| Mustafa Emir Akcasari     | 33606      |

## Contributing

This is a university course project. Team members can contribute by:

1. Creating a feature branch
```bash
git checkout -b feature/your-feature-name
```

2. Making changes and committing
```bash
git add .
git commit -m "Description of changes"
```

3. Pushing to GitHub
```bash
git push origin feature/your-feature-name
```

4. Creating a Pull Request for review

### Code Style Guidelines

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use proper indentation (2 spaces)

### Commit Message Format

```
[Type] Brief description

Detailed explanation if needed
```

Types: `[Feature]`, `[Fix]`, `[Refactor]`, `[Docs]`, `[Style]`, `[Test]`

Example:
```
[Feature] Add Firebase authentication

- Implemented email/password login
- Added error handling for invalid credentials
- Created AuthProvider for state management
```

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/auth_test.dart
```

### Test Structure

```
test/
├── unit/           # Unit tests for models and services
├── widget/         # Widget tests for UI components
└── integration/    # Integration tests for user flows
```

## Troubleshooting

### Common Issues

**Firebase not connecting**
- Verify `google-services.json` / `GoogleService-Info.plist` are in correct locations
- Check Firebase project configuration
- Ensure all Firebase services are enabled

**Build failures**
- Run `flutter clean && flutter pub get`
- Update Flutter SDK: `flutter upgrade`
- Check `flutter doctor` for missing dependencies

**Hot reload not working**
- Try hot restart: Press `Shift + R` in terminal
- Restart the app completely if hot restart fails

**State not updating**
- Ensure `notifyListeners()` is called in Provider
- Check if widget is wrapped with `Consumer` or uses `Provider.of()`

## Screenshots

_Coming soon - will be added with Step 3 completion_

## Demo Video

_Will be uploaded upon Step 3 completion (December 21, 2025)_

## Course Information

**CS310 - Mobile Application Development**
Sabanci University, Fall 2025

**Instructor:** TBD
**Project Type:** Group Project (5 members)

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design for UI guidelines
- Our course instructor and TAs for guidance

## License

This project is developed as part of CS310 coursework at Sabanci University.
All rights reserved by the development team.

---

**Last Updated:** January 2026
**Version:** 0.3.0 (Step 3 in progress)

For questions or issues, please contact any team member or create an issue on GitHub.
