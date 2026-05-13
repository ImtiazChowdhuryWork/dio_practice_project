# Clean Architecture in Flutter — A Deep Explanation

> This is a Flutter practice project. But more importantly, it is a **thinking exercise** about how to write code that stays clean, even as the app grows.

---

## Table of Contents

1. [The Core Idea — One Sentence](#1-the-core-idea--one-sentence)
2. [What is Clean Architecture?](#2-what-is-clean-architecture)
3. [Why does Clean Architecture exist?](#3-why-does-clean-architecture-exist)
4. [The Three Layers — What each one is responsible for](#4-the-three-layers--what-each-one-is-responsible-for)
5. [What is an Entity?](#5-what-is-an-entity)
6. [What is a Repository?](#6-what-is-a-repository)
7. [What is a UseCase?](#7-what-is-a-usecase)
8. [What is a Model?](#8-what-is-a-model)
9. [What is a DataSource?](#9-what-is-a-datasource)
10. [What is a Controller?](#10-what-is-a-controller)
11. [What is Dependency Injection?](#11-what-is-dependency-injection)
12. [The Full Sign Up Flow — seeing it all together](#12-the-full-sign-up-flow--seeing-it-all-together)
13. [What is Dio?](#13-what-is-dio)
14. [What is GetX?](#14-what-is-getx)
15. [Project Folder Structure](#15-project-folder-structure)
16. [Quick Concept Summary](#16-quick-concept-summary)

---

## 1. The Core Idea — One Sentence

> **The part of your code that talks to the server should never directly talk to the part that draws the screen.**

That's it. Everything else in clean architecture is just a consequence of this one idea.

---

## 2. What is Clean Architecture?

**What:** Clean Architecture is a way of organizing your code into **separate layers**, where each layer has **one job** and never mixes with the others.

Think of it like a **hospital**.

- The **receptionist** talks to the patient. She does not perform surgery.
- The **doctor** decides the diagnosis. He does not clean the wards.
- The **nurse** gives the medicine. She does not handle billing.
- The **accountant** handles billing. He does not treat patients.

Each person has a role. They communicate through defined channels. If the billing system changes, the doctor does not need to change how he treats patients.

Your app works the same way:

```
┌────────────────────────────────────────────┐
│         PRESENTATION LAYER                 │
│   (What the user sees and touches)         │
│   Pages, Controllers, Widgets              │
├────────────────────────────────────────────┤
│         DOMAIN LAYER                       │
│   (The brain — the business rules)         │
│   Entities, UseCases, Repository contracts │
├────────────────────────────────────────────┤
│         DATA LAYER                         │
│   (The hands — does the actual work)       │
│   DataSources, Models, Repository impls    │
└────────────────────────────────────────────┘
```

Each layer only communicates with the layer **directly below** it. The UI talks to Domain. Domain talks to Data. The UI never talks to Data directly. **Never.**

---

## 3. Why does Clean Architecture exist?

**Why:** Because without structure, code becomes a tangled mess. And tangled code is dangerous.

Imagine you write your whole app without layers. The button tap directly calls Dio, directly parses JSON, directly updates the UI. It "works." But then:

- You want to replace Dio with a different HTTP library. Now you have to touch 15 screens.
- You want to write tests. But the UI and the network are glued together, so you can't test one without the other.
- A new developer joins the team. They open the file and see: network call, UI logic, JSON parsing, navigation — all in one function. They have no idea where to start.

**The philosophical reason:**

Everything in nature that lasts a long time is **separated into layers** with clear boundaries.

- Your phone has: hardware → operating system → apps. Each layer knows its own job.
- A book has: chapters → paragraphs → sentences. Breaking one sentence does not destroy the chapter.
- Your body has: organs → tissues → cells. Your kidneys do not do the work of your lungs.

Code is no different. **Separation of concerns is not a trend. It is how complex things survive.**

---

## 4. The Three Layers — What each one is responsible for

### Layer 1: Presentation (The Face)

**What it does:** Shows data to the user. Reacts to user taps. Shows loading spinners. Navigates between screens.

**What it does NOT do:** Talk to the internet. Parse JSON. Write to disk.

Files in this project:
- `sign_up_page.dart` — the actual screen
- `sign_up_controller.dart` — the logic behind the screen
- `sign_up_binding.dart` — creates the controller when the screen opens

### Layer 2: Domain (The Brain)

**What it does:** Defines the rules of the app. What a "user" looks like. What "sign up" means. What data is needed.

**What it does NOT do:** Know where the data comes from. Know anything about HTTP or JSON.

This layer is **pure Dart**. No Flutter. No Dio. No HTTP. Just plain Dart classes and functions.

Files in this project:
- `auth_response_entity.dart` — what a successful signup result looks like
- `sign_up_repository.dart` — a contract: "whoever implements me must be able to sign up"
- `sign_up_usecase.dart` — the action of signing up

### Layer 3: Data (The Hands)

**What it does:** Does the actual dirty work. Makes HTTP calls. Reads/writes to local storage. Parses JSON into objects.

**What it does NOT do:** Know anything about the UI. Know anything about navigation.

Files in this project:
- `sign_up_remote_datasource.dart` — fires the HTTP request using Dio
- `auth_response_model.dart` — parses the JSON response into a Dart object
- `sign_up_repository_impl.dart` — fulfills the contract defined in Domain

---

## 5. What is an Entity?

**What:** An entity is a **pure Dart object** that describes a concept in your app. Nothing more.

**Why:** The domain layer needs to describe what things look like without being tied to how they are fetched or stored. An entity is the "idea" of a thing, independent of any technology.

**Example from this project:**

```dart
// lib/features/sign_up/domain/entities/auth_response_entity.dart

class SignedUpUser {
  final String id;
  final String email;
  final String name;
  final String role;
}

class AuthResponseEntity {
  final String accessToken;
  final String refreshToken;
  final SignedUpUser user;
}
```

Notice what is missing:
- No `fromJson()` method → it doesn't know about JSON
- No `import 'package:dio/dio.dart'` → it doesn't know about HTTP
- No Flutter widgets → it doesn't know about the UI

It is **just a description**. Like a job description: "A user has an id, email, name, and role." It says nothing about where you hire them.

---

## 6. What is a Repository?

**What:** A repository is a **contract** — a promise that says "I can do this, but I'm not telling you how."

**Why:** The domain layer needs to get data. But it should not care whether that data comes from the internet, a database, or a hardcoded list. The repository hides that detail behind a simple interface.

Think of it like ordering food at a restaurant. You tell the waiter: "I want pasta." You do not go into the kitchen to cook it yourself. The waiter is the contract. The kitchen is the implementation.

**The contract (in Domain):**

```dart
// lib/features/sign_up/domain/repositories/sign_up_repository.dart

abstract class SignUpRepository {
  Future<AuthResponseEntity> signUp({
    required String name,
    required String email,
    required String password,
  });
}
```

This says: "Whoever implements me MUST provide a `signUp()` function." It makes a **promise** without making a commitment about *how* it works.

**The fulfillment (in Data):**

```dart
// lib/features/sign_up/data/repositories/sign_up_repository_impl.dart

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpRemoteDataSource _remoteDataSource;

  SignUpRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResponseEntity> signUp({...}) {
    return _remoteDataSource.signUp(name: name, email: email, password: password);
  }
}
```

This fulfills the promise. Now if tomorrow you add offline caching, or switch from Dio to http, you only change the implementation — not the contract.

---

## 7. What is a UseCase?

**What:** A UseCase is **one specific action** your app can perform. Nothing more, nothing less.

**Why:** A controller can get complicated. If you put all your business logic in the controller, it becomes a god object that does everything. A UseCase gives each action a home — one file, one job.

Think of it like a **button in a factory**: one button starts the conveyor belt. Another button turns on the lights. Each button does exactly one thing. You can press any button independently.

**Example from this project:**

```dart
// lib/features/sign_up/domain/usecases/sign_up_usecase.dart

class SignUpUseCase {
  final SignUpRepository _repository;

  SignUpUseCase(this._repository);

  Future<AuthResponseEntity> execute({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.signUp(name: name, email: email, password: password);
  }
}
```

It has one job: take credentials, ask the repository to sign up, return the result.

**The philosophical point:** A UseCase is where the domain layer expresses its intent. It says: "The app CAN sign up." Not how. Not where the data goes. Just: this is a thing the app knows how to do.

---

## 8. What is a Model?

**What:** A Model is an **Entity that can also read JSON**.

**Why:** The domain layer must stay pure. It cannot know about JSON. But the data layer needs to turn server responses into Dart objects. The Model is the bridge.

Think of it like a **translator**. The server speaks JSON. Your app speaks Dart. The model translates between them.

The key design point: **the Model extends the Entity**. So once it is created, the rest of the app treats it like an Entity — it never needs to know a Model exists.

```dart
// lib/features/sign_up/data/models/auth_response_model.dart

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      user: SignedUpUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
```

`AuthResponseModel` IS an `AuthResponseEntity` (it extends it). So the controller receives it as an `AuthResponseEntity` and never knows or cares that it was once JSON from a server.

---

## 9. What is a DataSource?

**What:** A DataSource is the code that **actually touches the outside world** — the internet, local storage, or a file.

**Why:** You want to contain the "danger zone" in one place. Making HTTP requests can fail. Servers can be down. JSON can be malformed. By isolating all of that in the DataSource, the rest of your code stays clean and predictable.

Think of it like a **dock worker at a port**. Ships come in with cargo from all over the world. The dock worker handles the messy, unpredictable part — unloading, inspecting, sometimes refusing goods. The factory inside only receives clean, checked items.

```dart
// lib/features/sign_up/data/datasources/sign_up_remote_datasource.dart

class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  final Dio _dio;

  @override
  Future<AuthResponseModel> signUp({...}) async {
    try {
      final response = await _dio.post(
        ApiConstants.signUp,
        data: {'name': name, 'email': email, 'password': password},
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.success) {
        throw ServerException(message: apiResponse.error ?? 'Sign up failed');
      }

      return AuthResponseModel.fromJson(apiResponse.data);

    } on DioException catch (e) {
      throw ServerException(message: 'Sign up failed');
    }
  }
}
```

The DataSource:
- Talks to the internet (using Dio)
- Parses the raw response
- Throws a typed exception if something goes wrong
- Returns a clean Model if it succeeds

Everything above the DataSource never deals with raw JSON or DioExceptions.

---

## 10. What is a Controller?

**What:** A Controller is the **middleman between the UI and the domain**. It holds state (like "is loading"), handles user actions, and updates the screen.

**Why:** You do not want logic in your widgets. If you put logic in widgets, you cannot test it, you cannot reuse it, and you cannot reason about it clearly. The controller is where *"what should happen when the user taps this button"* lives.

**Example from this project:**

```dart
// lib/features/sign_up/presentation/controllers/sign_up_controller.dart

class SignUpController extends GetxController {
  final SignUpUseCase _signUpUseCase;  // given to it — doesn't create it

  final isLoading = false.obs;  // reactive state

  Future<void> signUp() async {
    // 1. Validate the inputs
    if (name.isEmpty || email.isEmpty || password.isEmpty) { ... return; }
    if (password != confirmPassword) { ... return; }
    if (password.length < 6) { ... return; }

    // 2. Call the use case
    isLoading.value = true;
    final result = await _signUpUseCase.execute(name, email, password);

    // 3. Save the result and navigate
    await appData.write(kKeyAccessToken, result.accessToken);
    Get.offAllNamed(Routes.home);

    isLoading.value = false;
  }
}
```

Notice the controller does **not** create the UseCase. It does not know how the UseCase works. It just says: "I need a UseCase. Give me one." That is dependency injection — explained next.

---

## 11. What is Dependency Injection?

**What:** Dependency Injection means: instead of a class creating the things it needs, **someone else creates them and passes them in**.

**Why — the philosophical reason:**

If a class creates its own dependencies, it is responsible for knowing *how* to build them. This creates hidden coupling. The class becomes hard to test and hard to change.

Real-life analogy: Imagine a chef who also has to grow his own vegetables, raise his own animals, mill his own flour, and build his own kitchen equipment — before he can cook. That is absurd. A chef should cook. Someone else handles supply.

Without DI (bad):
```dart
class SignUpController {
  // Creates everything itself — knows too much
  final _useCase = SignUpUseCase(
    SignUpRepositoryImpl(
      SignUpRemoteDataSourceImpl(Dio())
    )
  );
}
```

With DI (clean):
```dart
class SignUpController {
  final SignUpUseCase _signUpUseCase;

  // Receives it. Doesn't know how it was built.
  SignUpController(this._signUpUseCase);
}
```

**GetIt is the "cupboard" that holds everything pre-built:**

```dart
// lib/core/di/injection_container.dart

locator.registerSingleton<Dio>(DioClient.instance);

locator.registerSingleton<SignUpRemoteDataSource>(
  SignUpRemoteDataSourceImpl(locator<Dio>()),
);

locator.registerSingleton<SignUpRepository>(
  SignUpRepositoryImpl(locator<SignUpRemoteDataSource>()),
);

locator.registerSingleton<SignUpUseCase>(
  SignUpUseCase(locator<SignUpRepository>()),
);
```

This runs once at startup. Now anything in the app can ask GetIt: "Give me a `SignUpUseCase`" — and GetIt hands it back, fully built, without anyone needing to know the recipe.

---

## 12. The Full Sign Up Flow — seeing it all together

When you tap "Sign Up", here is the exact path through the layers:

```
USER TAPS THE BUTTON
        │
        ▼
[PRESENTATION] sign_up_page.dart
  → calls controller.signUp()
        │
        ▼
[PRESENTATION] sign_up_controller.dart
  → validates fields (name, email, password length, password match)
  → sets isLoading = true (spinner appears on button)
  → calls _signUpUseCase.execute(name, email, password)
        │
        ▼
[DOMAIN] sign_up_usecase.dart
  → calls _repository.signUp(name, email, password)
        │
        ▼
[DATA] sign_up_repository_impl.dart
  → calls _remoteDataSource.signUp(name, email, password)
        │
        ▼
[DATA] sign_up_remote_datasource.dart   ← INTERNET HAPPENS HERE
  → Dio fires HTTP POST to http://localhost:8080/api/v1/auth/register
  → Body: { "name": "John", "email": "john@example.com", "password": "abc123" }
        │
        ▼  Server responds:
  {
    "success": true,
    "data": {
      "access_token": "eyJhbGci...",
      "refresh_token": "eyJhbGci...",
      "user": { "id": "...", "name": "John", "email": "...", "role": "customer" }
    }
  }
        │
  → Parses into AuthResponseModel (which IS an AuthResponseEntity)
  → Returns it up the chain
        │
        ▼  bubbles back up through each layer
        │
[PRESENTATION] sign_up_controller.dart receives AuthResponseEntity
  → Saves tokens to phone storage (GetStorage)
  → Sets isLoading = false
  → Navigates to Home screen
```

### What if something goes wrong?

The error is thrown at the DataSource (the closest to the internet) and caught at the Controller (the closest to the user).

```
DataSource throws ServerException("email already registered")
    ↑
Repository does not catch it, just passes it up
    ↑
UseCase does not catch it, just passes it up
    ↑
Controller catches it:
  Get.snackbar('Error', 'email already registered')
```

Each layer in the middle does **not** handle the error. It does not need to. Its job is only to pass the request down and the response up.

---

## 13. What is Dio?

**What:** Dio is a Dart package that handles HTTP requests — talking to the internet.

Think of Dio as a **postal service**. You give it: an address (URL), a method (POST/GET), and a package (request body). It delivers it and brings back whatever the server replies.

### The ApiInterceptor — a customs officer

Every request and response passes through `ApiInterceptor`. It runs automatically, for every single request, without you needing to call it.

```
Your App
    │
    ▼
ApiInterceptor (outgoing)
    │  → Adds: "Authorization: Bearer eyJhbGci..." (your login token)
    │  → Logs:  REQUEST[POST] => /auth/register
    ▼
       INTERNET
    ▼
ApiInterceptor (incoming)
    │  → Logs:  RESPONSE[201] => /auth/register
    ▼
Your DataSource receives the response
```

You write the auth-header logic **once**. Every request gets it. This is the interceptor pattern.

### HTTP Methods — what they mean

| Method | Meaning | Analogy |
|--------|---------|---------|
| `GET` | Fetch data, change nothing | Reading a notice board |
| `POST` | Send data, create something new | Submitting a form |
| `PUT` | Replace existing data completely | Overwriting a document |
| `PATCH` | Update part of existing data | Correcting one line in a document |
| `DELETE` | Remove something | Shredding a document |

### What is a JWT Token?

After you sign up or sign in, the server gives you a string called a **JWT token** (it looks like `eyJhbGci...`).

Think of it like a **concert wristband**. You prove you paid once, get the wristband, and use it to re-enter without paying again. You send this token with every future request. The server checks it and knows who you are.

---

## 14. What is GetX?

GetX handles three things in this project:

### (a) Reactive State — the UI watches values and redraws itself

```dart
final isLoading = false.obs;  // .obs means "watch this"
```

When you change it:

```dart
isLoading.value = true;
```

Every `Obx(() => ...)` widget that reads this value **automatically redraws**. You never call `setState()`. You never manually trigger a rebuild.

```dart
// In sign_up_page.dart
Obx(() => ElevatedButton(
  onPressed: controller.isLoading.value ? null : controller.signUp,
  child: controller.isLoading.value
      ? CircularProgressIndicator()
      : Text('Sign Up'),
))
```

### (b) Navigation

```dart
Get.toNamed(Routes.signUp);       // Go to a screen
Get.back();                       // Go back
Get.offAllNamed(Routes.home);     // Go to home and clear history
```

### (c) GetView — automatic controller access

```dart
class SignUpPage extends GetView<SignUpController> {
  // `controller` is automatically available — no manual lookup
}
```

---

## 15. Project Folder Structure

```
lib/
├── core/                               # Shared across all features
│   ├── constants/
│   │   ├── api_constants.dart          # Base URL and API endpoints
│   │   └── app_constants.dart          # Storage key strings
│   ├── di/
│   │   └── injection_container.dart   # GetIt setup — the "cupboard"
│   ├── errors/
│   │   ├── exceptions.dart            # ServerException, NetworkException
│   │   └── failures.dart              # Failure types (future use)
│   ├── network/
│   │   ├── api_interceptor.dart       # Adds auth token, logs requests
│   │   ├── api_response.dart          # Generic { success, data, error } wrapper
│   │   └── dio_client.dart            # Configures the Dio instance
│   ├── styles/
│   │   └── text_styles.dart           # All text styles in one place
│   └── utils/
│       ├── helper_methods.dart
│       ├── logger_util.dart
│       ├── post_login.dart
│       └── ui_helpers.dart
│
├── features/                          # One folder per feature
│   │
│   ├── sign_up/                       # Fully implemented with real API
│   │   ├── data/
│   │   │   ├── datasources/sign_up_remote_datasource.dart   ← HTTP happens here
│   │   │   ├── models/auth_response_model.dart              ← parses JSON
│   │   │   └── repositories/sign_up_repository_impl.dart   ← fulfills contract
│   │   ├── domain/
│   │   │   ├── entities/auth_response_entity.dart           ← pure Dart object
│   │   │   ├── repositories/sign_up_repository.dart         ← abstract contract
│   │   │   └── usecases/sign_up_usecase.dart                ← one action
│   │   └── presentation/
│   │       ├── bindings/sign_up_binding.dart                ← creates controller
│   │       ├── controllers/sign_up_controller.dart          ← state + logic
│   │       └── pages/sign_up_page.dart                      ← the screen
│   │
│   ├── sign_in/                       # Same structure as sign_up
│   ├── home/                          # Home screen with practice cards
│   ├── counter/                       # GetX counter example
│   └── welcome/                       # Static welcome screen
│
├── routes/
│   └── routes.dart                    # All named routes
│
├── shared/
│   ├── constants/app_list.dart
│   └── widgets/                       # Reusable widgets
│
├── bindings/controllers_binding.dart
├── loading_screen.dart                # Checks login state at startup
└── main.dart
```

---

## 16. Quick Concept Summary

| Concept | Plain English |
|---------|---------------|
| **Clean Architecture** | Separate your code into layers — each layer has one job and never mixes with others |
| **Entity** | A pure Dart object. Describes a concept (User, Order). No JSON, no HTTP |
| **Repository (abstract)** | A contract. A promise: "I will provide this function." Doesn't say how |
| **Repository (impl)** | The code that fulfills the contract. Lives in the Data layer |
| **UseCase** | One action the app can perform. One file, one job |
| **Model** | An Entity that can also read JSON. Extends the Entity |
| **DataSource** | The code that actually touches the internet or local storage |
| **Controller** | Holds UI state, handles user actions, calls the UseCase |
| **Binding** | Creates the controller when a screen opens |
| **GetIt** | A global cupboard that stores pre-built objects (dependency injection) |
| **Singleton** | One instance, created once, reused everywhere |
| **Dio** | The library that makes HTTP requests |
| **ApiInterceptor** | Runs on every request/response — adds auth headers, logs |
| **JWT Token** | A string the server gives you to prove who you are |
| **GetX** | Handles reactive state, navigation, and controller wiring |
| **`.obs`** | Makes a value "watchable" — UI auto-redraws when it changes |
| **`Obx`** | A widget that auto-redraws when an `.obs` value changes |
| **GetStorage** | Permanent memory on the phone — survives app restarts |
| **`POST`** | HTTP: "create something new" |
| **`GET`** | HTTP: "fetch something, change nothing" |
