# Dio Practice Project

A Flutter practice project built with **Clean Architecture**, **GetX**, **Dio**, and **GetIt**.
This README explains how the entire app works — from scratch, like you've never coded before.

---

## Table of Contents

1. [What is this app?](#1-what-is-this-app)
2. [How does a Flutter app even work?](#2-how-does-a-flutter-app-even-work)
3. [What is Clean Architecture and WHY does it exist?](#3-what-is-clean-architecture-and-why-does-it-exist)
4. [The three layers explained simply](#4-the-three-layers-explained-simply)
5. [Sign Up flow — step by step](#5-sign-up-flow--step-by-step)
6. [What is Dio?](#6-what-is-dio)
7. [What is GetX?](#7-what-is-getx)
8. [What is GetIt (Dependency Injection)?](#8-what-is-getit-dependency-injection)
9. [What is GetStorage?](#9-what-is-getstorage)
10. [The complete picture](#10-the-complete-picture)
11. [Project folder structure](#11-project-folder-structure)
12. [API Reference](#12-api-reference)
13. [Quick concept summary](#13-quick-concept-summary)

---

## 1. What is this app?

Think of this app like a **shop assistant app** for an online store. Right now it can:

- Show you a home screen with a list of practice features
- Let you tap **"Sign Up"** to create an account
- Send your name, email, and password to a **server** running on this Mac
- Get back a "key" (called a **token**) that proves you're logged in

That's it for now. But the *way* it's built is what matters — it follows a pattern called **Clean Architecture**.

---

## 2. How does a Flutter app even work?

Imagine your phone screen is a **whiteboard**. Flutter is the person who draws on it.

Every screen you see is made of **widgets**. A widget is just a fancy word for *"a piece of the screen."*

- A button → widget
- A text field → widget
- The whole screen → widget
- Even empty space → widget

They are like **LEGO blocks** — you stack them together to build the UI.

```
Screen
└── Column
    ├── Text("Create Account")
    ├── TextField (email)
    ├── TextField (password)
    └── Button("Sign Up")
```

When something changes (like you type your name), Flutter **erases and redraws** only the part that changed. That's how it stays fast.

---

## 3. What is Clean Architecture and WHY does it exist?

Imagine you're building a house. You could dump all your furniture, pipes, wires, and walls in one pile — it would *technically* work, but fixing anything would be a nightmare.

**Clean architecture is like having separate rooms for separate things.**

```
┌─────────────────────────────────────────┐
│           PRESENTATION LAYER            │  ← What the user sees & touches
│     (Pages, Controllers, Widgets)       │
├─────────────────────────────────────────┤
│             DOMAIN LAYER                │  ← The business rules (the "brain")
│      (Entities, UseCases, Repos)        │
├─────────────────────────────────────────┤
│              DATA LAYER                 │  ← Where data actually comes from
│    (Models, DataSources, RepoImpls)     │
└─────────────────────────────────────────┘
         data flows downward only
         never upward
```

**The golden rule:** Each layer only talks to the layer directly below it. The UI never touches the internet directly. Ever.

**Why does this matter?**

If tomorrow you swap your server for a different one, you only change the **data layer** — the UI and business logic don't even know something changed. Each layer has exactly one job, and nothing else.

---

## 4. The three layers explained simply

### Layer 1 — Presentation (the "face")

This is everything the user sees and interacts with.

| File | Role |
|---|---|
| `sign_up_page.dart` | The actual screen with text fields and a button |
| `sign_up_controller.dart` | The brain behind the page — holds state, reacts to taps |
| `sign_up_binding.dart` | The factory that creates the controller when the screen opens |

> **Analogy:** Think of a restaurant.
> - The **page** is the table where you sit
> - The **controller** is the waiter who takes your order and brings your food
> - The waiter never cooks — they just relay orders to the kitchen

---

### Layer 2 — Domain (the "brain")

This layer has **no idea** whether data comes from the internet, a database, or thin air. It only knows *what* it needs, not *how* to get it.

| File | Role |
|---|---|
| `auth_response_entity.dart` | A pure Dart object. Describes what a "successful signup" looks like |
| `sign_up_repository.dart` | A **contract** (abstract class). Says: *"whoever implements me must provide a `signUp()` function"* |
| `sign_up_usecase.dart` | One specific action the app can perform: `execute(name, email, password)` |

> **Analogy:**
> - The **entity** is the dish description ("Pasta: has noodles, sauce, cheese")
> - The **repository contract** is the menu that promises "we will deliver pasta"
> - The **use case** is the order slip the waiter hands to the kitchen

---

### Layer 3 — Data (the "hands")

This layer does the actual work — making HTTP calls, parsing JSON, talking to databases.

| File | Role |
|---|---|
| `auth_response_model.dart` | Like an entity, but knows how to read JSON from the server |
| `sign_up_remote_datasource.dart` | The code that fires the actual HTTP request using Dio |
| `sign_up_repository_impl.dart` | Fulfills the contract from the domain layer |

> **Analogy:**
> - The **datasource** is the chef who gets raw ingredients (HTTP response)
> - The **model** is the recipe that turns raw ingredients into a dish
> - The **repository impl** is the final plate handed back to the waiter

---

## 5. Sign Up flow — step by step

Let's trace exactly what happens when you tap the **"Sign Up"** button:

```
USER TAPS BUTTON
      │
      ▼
[sign_up_page.dart]
  Calls: controller.signUp()
      │
      ▼
[sign_up_controller.dart]
  1. Reads text from all 4 fields (name, email, password, confirm password)
  2. Validates:
       - Are all fields filled?
       - Do both passwords match?
       - Is password at least 6 characters?
  3. Sets isLoading = true  →  button shows a spinner
  4. Calls: _signUpUseCase.execute(name, email, password)
      │
      ▼
[sign_up_usecase.dart]
  Just calls: _repository.signUp(name, email, password)
      │
      ▼
[sign_up_repository_impl.dart]
  Just calls: _remoteDataSource.signUp(name, email, password)
      │
      ▼
[sign_up_remote_datasource.dart]  ← THE INTERNET HAPPENS HERE
  1. Uses Dio to fire an HTTP POST request to:
       http://localhost:8080/api/v1/auth/register
  2. Sends this JSON in the request body:
       {
         "name": "John",
         "email": "john@example.com",
         "password": "secret123"
       }
      │
      │  (server receives it, hashes the password, saves to database)
      │
      ▼  server sends back:
       {
         "success": true,
         "data": {
           "access_token": "eyJhbGci...",
           "refresh_token": "eyJhbGci...",
           "user": {
             "id": "some-uuid",
             "email": "john@example.com",
             "name": "John",
             "role": "customer"
           }
         }
       }
  3. Parses with ApiResponse.fromJson() — checks "success": true
  4. Parses "data" with AuthResponseModel.fromJson()
  5. Returns an AuthResponseModel (which IS an AuthResponseEntity)
      │
      ▼  bubbles back up: datasource → repositoryImpl → usecase → controller
      │
[sign_up_controller.dart] receives AuthResponseEntity
  1. Saves access_token  to phone storage
  2. Saves refresh_token to phone storage
  3. Saves user name, email, id to phone storage
  4. Sets isLoading = false
  5. Navigates to the Home screen
```

### What if something goes wrong?

**Email already taken:**
```json
{ "success": false, "error": "email already registered" }
```
The datasource throws a `ServerException("email already registered")`.
The controller catches it and shows a red snackbar at the bottom.

**No internet / server is off:**
Dio throws a `DioException`.
The datasource catches it, throws a `ServerException("Sign up failed")`.
The controller shows a snackbar.

**Passwords don't match:**
The controller catches this *before* even calling Dio.
Shows a snackbar: *"Passwords do not match"*.

---

## 6. What is Dio?

Dio is a **Dart package** that handles talking to the internet. Think of it as a **courier service** for your app.

You give Dio:
- The **address** (URL): `http://localhost:8080/api/v1/auth/register`
- The **method**: `POST` — means "I'm sending data, please process it"
- The **package** (body): `{ name, email, password }`

Dio delivers it and brings back whatever the server says.

### HTTP methods — what do they mean?

| Method | Meaning | Real-world analogy |
|---|---|---|
| `GET` | Fetch data, don't change anything | Reading a menu |
| `POST` | Send new data to create something | Placing an order |
| `PUT` | Replace existing data completely | Returning a dish and ordering a new one |
| `PATCH` | Update part of existing data | Asking to add extra sauce |
| `DELETE` | Remove something | Cancelling your order |

### What is the `ApiInterceptor`?

An interceptor is like a **customs officer** that checks every package going out and coming in.

```
Your App
    │
    ▼
ApiInterceptor (checks outgoing)
    │  - If you have a saved token, adds:
    │    Authorization: Bearer eyJhbGci...
    │  - Logs: "REQUEST[POST] => /auth/register"
    ▼
           INTERNET
    ▼
ApiInterceptor (checks incoming)
    │  - Logs: "RESPONSE[201] => /auth/register"
    │  - On error: logs the error details
    ▼
Your App gets the response
```

You write the token-adding logic **once** — every Dio request automatically gets it.

### What is a token?

When you log in or sign up, the server gives you a special string called a **JWT token** (it looks like `eyJhbGci...`). It's like a **wristband at a concert** — you show it to prove you already paid to get in.

You send this token with every future request. The server checks it and knows who you are without you having to log in again every time.

---

## 7. What is GetX?

GetX is a package that handles three things in this app:

### (a) State Management — making the UI react to changes

```dart
final isLoading = false.obs;   // .obs means "watch this value"
```

`.obs` wraps the value in a special box. When you change it:

```dart
isLoading.value = true;
```

...every `Obx(() => ...)` widget that reads `isLoading.value` **automatically redraws itself**. You don't manually tell the UI to update — it just reacts.

```dart
// In sign_up_page.dart
Obx(() => ElevatedButton(
  onPressed: controller.isLoading.value ? null : controller.signUp,
  child: controller.isLoading.value
      ? CircularProgressIndicator()   // shows spinner when loading
      : Text('Sign Up'),              // shows text when not loading
))
```

### (b) Navigation — moving between screens

```dart
Get.toNamed(Routes.signUp);       // Go to sign up page
Get.back();                       // Go back to previous screen
Get.offAllNamed(Routes.home);     // Go to home and clear all history
```

### (c) GetView — automatic controller wiring

```dart
class SignUpPage extends GetView<SignUpController> {
```

By extending `GetView<SignUpController>`, the page automatically gets a `controller` property. You never manually find or create the controller — GetX does it for you.

---

## 8. What is GetIt (Dependency Injection)?

GetIt is like a **big storage cupboard** for objects that need to be shared across the app.

**The problem it solves:**

`SignUpController` needs a `SignUpUseCase`.
`SignUpUseCase` needs a `SignUpRepository`.
`SignUpRepository` needs a `SignUpRemoteDataSource`.
`SignUpRemoteDataSource` needs a `Dio` instance.

Without GetIt, you'd have to manually create and pass all of these everywhere. That gets messy fast.

**With GetIt:**

When the app starts, `diSetup()` fills the cupboard:

```dart
locator.registerSingleton<Dio>(DioClient.instance);

locator.registerSingleton<SignUpRemoteDataSource>(
  SignUpRemoteDataSourceImpl(locator<Dio>()),   // gets Dio from the cupboard
);

locator.registerSingleton<SignUpRepository>(
  SignUpRepositoryImpl(locator<SignUpRemoteDataSource>()),
);

locator.registerSingleton<SignUpUseCase>(
  SignUpUseCase(locator<SignUpRepository>()),
);
```

Later, `SignUpBinding` fetches from the cupboard to create the controller:

```dart
Get.lazyPut(() => SignUpController(locator<SignUpUseCase>()));
```

The controller just says: *"give me a SignUpUseCase"* — it doesn't know or care how it was made.

### registerSingleton vs lazyPut

| Method | When it's created | How many instances |
|---|---|---|
| `registerSingleton` | At app startup | Only one, forever |
| `lazyPut` | First time it's needed | One per screen lifecycle |

---

## 9. What is GetStorage?

GetStorage is **permanent memory** on the phone. Normal Dart variables disappear when the app closes. GetStorage saves things to a file so they survive app restarts.

```dart
// Saving (after successful signup)
await appData.write('access_token', result.accessToken);
await appData.write('user_name',    result.user.name);

// Reading (when app starts in loading_screen.dart)
final isLoggedIn = appData.read('access_token') != null;

// Checking (before writing a default value)
appData.writeIfNull('first', true);   // only writes if key doesn't exist yet
```

**Why is this important?**

When you open the app again tomorrow, `loading_screen.dart` checks:
- Is there a saved `access_token`? → Yes → skip login, go straight to Home
- No token? → Show the Home/SignUp screen

---

## 10. The complete picture

```
┌───────────────────────────────────────────────────────────────────┐
│                            PHONE                                  │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │                    FLUTTER UI (GetX)                       │   │
│  │                                                            │   │
│  │   SignUpPage ◄──Obx──► SignUpController                    │   │
│  │   (widgets)            (state + logic)                     │   │
│  └──────────────────────────┬─────────────────────────────────┘   │
│                             │ calls execute()                     │
│  ┌──────────────────────────▼─────────────────────────────────┐   │
│  │                    DOMAIN LAYER                             │   │
│  │                                                            │   │
│  │   SignUpUseCase ──► SignUpRepository (abstract contract)   │   │
│  └──────────────────────────┬─────────────────────────────────┘   │
│                             │ implemented by                      │
│  ┌──────────────────────────▼─────────────────────────────────┐   │
│  │                     DATA LAYER                              │   │
│  │                                                            │   │
│  │   SignUpRepositoryImpl ──► SignUpRemoteDataSource          │   │
│  │                                    │                       │   │
│  │                                   Dio + ApiInterceptor     │   │
│  └────────────────────────────────────┼────────────────────────┘   │
│                                       │                           │
│   ┌───────────────────────────┐       │ HTTP POST                 │
│   │  GetStorage (phone disk)  │       │                           │
│   │  access_token: "eyJ..."   │       │                           │
│   │  user_name: "John"        │       │                           │
│   └───────────────────────────┘       │                           │
└───────────────────────────────────────┼───────────────────────────┘
                                        │
                           ─────────────▼──────────────
                           POST /api/v1/auth/register
                           body: { name, email, password }
                           ─────────────────────────────
                                        │
                                        ▼
                          ┌─────────────────────────┐
                          │   Go Server (port 8080)  │
                          │                         │
                          │  1. Validate input       │
                          │  2. Hash password        │
                          │  3. Save to PostgreSQL   │
                          │  4. Generate JWT tokens  │
                          │  5. Return tokens + user │
                          └─────────────────────────┘
```

---

## 11. Project folder structure

```
lib/
├── core/                          # Shared infrastructure (used by all features)
│   ├── constants/
│   │   ├── api_constants.dart     # Base URL and endpoint paths
│   │   └── app_constants.dart     # Storage key strings
│   ├── di/
│   │   └── injection_container.dart  # GetIt setup — the "cupboard"
│   ├── errors/
│   │   ├── exceptions.dart        # ServerException, NetworkException, etc.
│   │   └── failures.dart          # Failure classes (for future use)
│   ├── network/
│   │   ├── api_interceptor.dart   # Adds auth token, logs requests
│   │   ├── api_response.dart      # Generic { success, data, error } wrapper
│   │   └── dio_client.dart        # Creates the Dio instance with config
│   ├── styles/
│   │   └── text_styles.dart       # All app text styles in one place
│   └── utils/
│       ├── helper_methods.dart    # Device ID, system UI, exit dialog
│       ├── logger_util.dart       # Pretty console logging
│       ├── post_login.dart        # Actions to run after login (future)
│       └── ui_helpers.dart        # Spacing widgets and padding constants
│
├── features/                      # One folder per feature
│   │
│   ├── counter/                   # Practice: counter with GetX
│   │   ├── domain/entities/counter_entity.dart
│   │   └── presentation/
│   │       ├── bindings/counter_binding.dart
│   │       ├── controllers/counter_controller.dart
│   │       └── pages/counter_page.dart
│   │
│   ├── home/                      # The main menu screen
│   │   ├── domain/entities/practice_card_entity.dart
│   │   └── presentation/
│   │       ├── bindings/home_binding.dart
│   │       ├── controllers/home_controller.dart
│   │       ├── pages/home_page.dart
│   │       └── widgets/practice_card_widget.dart
│   │
│   ├── sign_in/                   # Sign in (UI ready, API stub)
│   │   ├── data/
│   │   │   ├── datasources/auth_remote_datasource.dart
│   │   │   ├── models/user_model.dart
│   │   │   └── repositories/auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/user_entity.dart
│   │   │   ├── repositories/auth_repository.dart
│   │   │   └── usecases/sign_in_usecase.dart
│   │   └── presentation/
│   │       ├── bindings/sign_in_binding.dart
│   │       ├── controllers/sign_in_controller.dart
│   │       └── pages/sign_in_page.dart
│   │
│   ├── sign_up/                   # Sign up — FULLY IMPLEMENTED with real API
│   │   ├── data/
│   │   │   ├── datasources/sign_up_remote_datasource.dart  ← Dio lives here
│   │   │   ├── models/auth_response_model.dart             ← parses JSON
│   │   │   └── repositories/sign_up_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/auth_response_entity.dart
│   │   │   ├── repositories/sign_up_repository.dart        ← abstract contract
│   │   │   └── usecases/sign_up_usecase.dart
│   │   └── presentation/
│   │       ├── bindings/sign_up_binding.dart
│   │       ├── controllers/sign_up_controller.dart         ← validates + saves tokens
│   │       └── pages/sign_up_page.dart
│   │
│   └── welcome/                   # Static welcome screen
│       └── presentation/pages/welcome_page.dart
│
├── gen/                           # Auto-generated (don't edit manually)
│   ├── assets.gen.dart            # Type-safe asset paths
│   ├── colors.gen.dart            # Type-safe color constants
│   └── fonts.gen.dart             # Font family constants
│
├── localization/                  # English + Korean translations
│   ├── language_files/
│   └── presentation/
│
├── routes/
│   └── routes.dart                # All screen routes + transitions
│
├── shared/                        # Reusable across features
│   ├── constants/app_list.dart    # The list of items shown on the home screen
│   └── widgets/
│       ├── custom_button.dart
│       └── custom_elevated_button.dart
│
├── bindings/
│   └── controllers_binding.dart   # Initial app-level binding
├── loading_screen.dart            # Checks login state at startup
└── main.dart                      # App entry point
```

---

## 12. API Reference

The backend is a **Go server** running locally on port `8080`.

### Base URL

```
http://localhost:8080/api/v1
```

> **Android emulator users:** replace `localhost` with `10.0.2.2`

### Sign Up

```
POST /auth/register
```

**Request body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "secret123"
}
```

**Success response (201):**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "john@example.com",
      "name": "John Doe",
      "role": "customer",
      "created_at": "2026-05-12T10:00:00Z",
      "updated_at": "2026-05-12T10:00:00Z"
    }
  }
}
```

**Error response:**
```json
{
  "success": false,
  "error": "email already registered"
}
```

| Status | Meaning |
|---|---|
| `201` | Account created successfully |
| `400` | Missing fields or password too short |
| `409` | Email already registered |
| `500` | Server error |

### Validation rules (enforced client-side too)

- All fields (name, email, password) are required
- Passwords must match
- Password must be at least 6 characters

---

## 13. Quick concept summary

| Concept | What it is in plain English |
|---|---|
| **Widget** | A piece of the screen (button, text, image, empty space) |
| **Clean Architecture** | Separating code into layers so each part has exactly one job |
| **Entity** | A pure Dart object describing a concept — no JSON, no HTTP |
| **UseCase** | One action the app can do (sign up, sign in, fetch products) |
| **Repository (abstract)** | A contract/promise: "I will provide this function" |
| **Repository (impl)** | The code that actually fulfills that promise |
| **DataSource** | Code that talks to the internet or local database |
| **Model** | An entity that can also read/write JSON |
| **Dio** | The library that makes HTTP requests (like a courier service) |
| **ApiInterceptor** | A guard that checks every request/response (adds token, logs) |
| **JWT Token** | A string the server gives you to prove who you are |
| **GetX** | Handles reactive state, navigation, and controller wiring |
| **Obx** | A widget that auto-redraws when an `.obs` value changes |
| **GetView** | A base class that auto-provides your controller |
| **Binding** | A factory that creates a controller when a screen opens |
| **GetIt** | A cupboard that stores and provides shared objects |
| **Singleton** | One instance created once and reused forever |
| **GetStorage** | Permanent memory on the phone (survives app restarts) |
| **`POST`** | HTTP method meaning "create something new" |
| **`GET`** | HTTP method meaning "fetch something, change nothing" |
