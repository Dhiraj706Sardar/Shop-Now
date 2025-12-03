# Flutter E-Commerce App Development Guide
## A Complete Step-by-Step Tutorial with Source Code

**Author:** Dhiraj Sardar  
**Project:** Shop-Now E-Commerce Application  
**Architecture:** Clean Architecture with BLoC Pattern  
**Version:** 1.0.0

---

## Table of Contents

1. [Introduction](#chapter-1-introduction)
2. [Prerequisites & Setup](#chapter-2-prerequisites--setup)
3. [Project Architecture](#chapter-3-project-architecture)
4. [Core Components](#chapter-4-core-components)
5. [Feature: Authentication](#chapter-5-feature-authentication)
6. [Feature: Products](#chapter-6-feature-products)
7. [Feature: Shopping Cart](#chapter-7-feature-shopping-cart)
8. [Feature: Orders](#chapter-8-feature-orders)
9. [Feature: Wishlist](#chapter-9-feature-wishlist)
10. [Routing & Navigation](#chapter-10-routing--navigation)
11. [Testing & Deployment](#chapter-11-testing--deployment)
12. [Conclusion](#chapter-12-conclusion)

---

## Chapter 1: Introduction

### What You'll Build

In this comprehensive guide, you'll learn how to build a production-ready e-commerce mobile application using Flutter. This isn't just a simple tutorial - you'll create a fully-featured shopping app with:

- **User Authentication** (Sign up, Sign in, Email verification)
- **Product Browsing** (Categories, Search, Filters)
- **Shopping Cart** (Add, Remove, Update quantities)
- **Order Management** (Place orders, View history)
- **Wishlist** (Save favorite products)
- **User Profile** (Manage personal information)

### Why This Architecture?

This project follows **Clean Architecture** principles, which means:

- ✅ **Separation of Concerns**: Each layer has a specific responsibility
- ✅ **Testability**: Easy to write unit and integration tests
- ✅ **Maintainability**: Changes in one layer don't affect others
- ✅ **Scalability**: Easy to add new features

### Technology Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **BLoC/Cubit** | State management |
| **Supabase** | Backend & Authentication |
| **Hive** | Local database (offline-first) |
| **AutoRoute** | Type-safe navigation |
| **Get_it + Injectable** | Dependency injection |
| **Retrofit + Dio** | API networking |
| **Freezed** | Immutable data models |

---

## Chapter 2: Prerequisites & Setup

### What You Need

Before starting, ensure you have:

1. **Flutter SDK** (version 3.0.0 or higher)
2. **Dart SDK** (version 3.0.0 or higher)
3. **Android Studio** or **VS Code** with Flutter extensions
4. **Git** for version control
5. **Supabase Account** (free tier is sufficient)

### Step 1: Install Flutter

```bash
# Verify Flutter installation
flutter doctor

# Expected output should show:
# ✓ Flutter (Channel stable, 3.x.x)
# ✓ Android toolchain
# ✓ VS Code or Android Studio
```

### Step 2: Create New Project

```bash
# Clone the repository or create new project
flutter create ecommerce_app
cd ecommerce_app
```

### Step 3: Configure Dependencies

Create or update `pubspec.yaml`:

```yaml
name: ecommerce_app
description: A Flutter e-commerce app with Clean Architecture
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  hydrated_bloc: ^9.1.2
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # Networking
  dio: ^5.4.0
  retrofit: ^4.9.1
  pretty_dio_logger: ^1.3.1
  
  # Routing
  auto_route: ^7.8.4
  
  # Dependency Injection
  get_it: ^7.6.4
  injectable: ^2.3.2
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.1
  
  # Supabase
  supabase_flutter: ^2.0.0
  
  # Utilities
  intl: ^0.18.1
  dartz: ^0.10.1
  
  # UI & Animations
  shimmer: ^3.0.0
  cached_network_image: ^3.3.1
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  
  # Code Generation
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  retrofit_generator: ^7.0.8
  hive_generator: ^2.0.1
  injectable_generator: ^2.4.1
  auto_route_generator: ^7.3.2
```

### Step 4: Install Dependencies

```bash
flutter pub get
```

### Step 5: Setup Supabase

1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Copy your project URL and anon key
4. Save these for later configuration

---

## Chapter 3: Project Architecture

### Clean Architecture Overview

Our app is organized into three main layers:

```
lib/
├── src/
│   ├── core/              # Shared utilities
│   ├── features/          # Feature modules
│   └── router/            # Navigation
└── main.dart              # App entry point
```

### The Three Layers

#### 1. **Data Layer** (Outermost)
- Handles data from external sources (API, Database)
- Contains Models, Data Sources, and Repository Implementations

#### 2. **Domain Layer** (Middle)
- Contains business logic
- Defines Repository Interfaces and Use Cases
- Independent of external frameworks

#### 3. **Presentation Layer** (Innermost)
- UI components (Pages, Widgets)
- State management (BLoC/Cubit)
- User interactions

### Feature Structure

Each feature follows this structure:

```
features/feature_name/
├── data/
│   ├── datasources/       # API & local data sources
│   ├── models/            # Data models with JSON serialization
│   └── repositories/      # Repository implementations
├── domain/
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic
└── presentation/
    ├── bloc/              # State management
    ├── pages/             # UI screens
    └── widgets/           # Reusable components
```

### Data Flow Example

Let's understand how data flows when fetching products:

```
[UI] → [BLoC] → [UseCase] → [Repository] → [DataSource] → [API]
                                                              ↓
[UI] ← [BLoC] ← [UseCase] ← [Repository] ← [DataSource] ← [Response]
```

1. **User Action**: User opens products page
2. **BLoC Event**: `LoadProducts` event is dispatched
3. **Use Case**: `GetProducts` use case is called
4. **Repository**: Calls data source to fetch data
5. **Data Source**: Makes API call using Retrofit
6. **Response**: Data flows back through layers
7. **State Update**: BLoC emits new state
8. **UI Rebuild**: Flutter rebuilds affected widgets

---

## Chapter 4: Core Components

### 4.1 Dependency Injection

Dependency Injection (DI) helps manage object creation and dependencies.

**File:** `lib/src/core/di/injection.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
```

**How it works:**
- `GetIt` is a service locator
- `Injectable` generates registration code
- All dependencies are registered automatically

**Usage Example:**

```dart
// Register a class
@injectable
class ProductRepository {
  // ...
}

// Retrieve instance
final repo = getIt<ProductRepository>();
```

### 4.2 Error Handling

**File:** `lib/src/core/errors/failures.dart`

```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
```

**Why use Failures?**
- Type-safe error handling
- Easy to distinguish error types
- Works well with functional programming (Either type)

### 4.3 Use Case Pattern

**File:** `lib/src/core/usecases/usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
```

**Benefits:**
- Single Responsibility: Each use case does one thing
- Testable: Easy to mock and test
- Reusable: Can be used across different features

---

## Chapter 5: Feature: Authentication

### 5.1 Overview

The authentication feature handles:
- User sign up with email/password
- User sign in
- Email verification
- Session management
- Sign out

### 5.2 Domain Layer

#### Repository Interface

**File:** `lib/src/features/auth/domain/repositories/auth_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, void>> signOut();
  
  Future<Either<Failure, UserModel?>> getCurrentUser();
  
  Stream<UserModel?> listenToAuthChanges();
}
```

#### Use Case Example: Sign In

**File:** `lib/src/features/auth/domain/usecases/sign_in_with_email.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

@injectable
class SignInWithEmail implements UseCase<UserModel, SignInParams> {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(SignInParams params) async {
    return await repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
```

### 5.3 Data Layer

#### User Model

**File:** `lib/src/features/auth/data/models/user_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    DateTime? dateOfBirth,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

**Freezed Benefits:**
- Immutable data classes
- Auto-generated `copyWith`, `==`, `hashCode`
- JSON serialization
- Union types support

---

## Chapter 6: Feature: Products

### 6.1 Overview

The products feature handles:
- Fetching all products from API
- Loading product details
- Searching products
- Filtering by category
- Sorting by price

### 6.2 Product Model

```dart
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required RatingModel rating,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
```

### 6.3 API Client (Retrofit)

```dart
@RestApi(baseUrl: 'https://fakestoreapi.com')
abstract class ProductApiClient {
  factory ProductApiClient(Dio dio, {String baseUrl}) = _ProductApiClient;

  @GET('/products')
  Future<List<ProductModel>> getProducts();

  @GET('/products/{id}')
  Future<ProductModel> getProduct(@Path('id') int id);

  @GET('/products/categories')
  Future<List<String>> getCategories();
}
```

---

## Chapter 7: Feature: Shopping Cart

### 7.1 Overview

The cart feature uses **Hive** for local storage, making it offline-first:
- Add products to cart
- Remove products
- Update quantities
- Calculate total price
- Persist cart data locally

### 7.2 Cart Model (Hive)

```dart
@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String image;

  @HiveField(4)
  int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}
```

---

## Chapter 8: Feature: Orders

### 8.1 Overview

Orders are stored in Supabase database:
- Create orders from cart
- Fetch user's order history
- Track order status

### 8.2 Database Setup

Create this table in Supabase:

```sql
create table orders (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  items jsonb not null,
  total decimal not null,
  status text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security
alter table orders enable row level security;

-- Users can view own orders
create policy "Users can view own orders"
  on orders for select
  using (auth.uid() = user_id);

-- Users can create own orders
create policy "Users can create own orders"
  on orders for insert
  with check (auth.uid() = user_id);
```

---

## Chapter 9: Feature: Wishlist

### 9.1 Overview

Wishlist uses Hive for local storage:
- Add products to wishlist
- Remove products
- Check if product is wishlisted

---

## Chapter 10: Routing & Navigation

### 10.1 AutoRoute Setup

```dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(
          page: HomeRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: ProductDetailsRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: CartRoute.page,
          guards: [authGuard],
        ),
      ];
}
```

---

## Chapter 11: Testing & Deployment

### 11.1 Running Code Generation

Before running the app, generate required code:

```bash
# Generate all code
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

This generates:
- Freezed models (`.freezed.dart`)
- JSON serialization (`.g.dart`)
- Dependency injection (`injection.config.dart`)
- Routes (`app_router.gr.dart`)
- Hive adapters

### 11.2 Running the App

```bash
# Run on connected device
flutter run

# Run in release mode
flutter run --release
```

### 11.3 Building for Production

#### Android APK

```bash
flutter build apk --release
```

#### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

---

## Chapter 12: Conclusion

### What You've Learned

Congratulations! You've built a complete e-commerce application with:

✅ **Clean Architecture** - Separation of concerns across layers  
✅ **BLoC Pattern** - Predictable state management  
✅ **Dependency Injection** - Loosely coupled components  
✅ **Type-Safe Navigation** - AutoRoute with guards  
✅ **Offline-First** - Hive for local storage  
✅ **Backend Integration** - Supabase for auth and database  
✅ **API Integration** - Retrofit for type-safe networking  

### Next Steps

To enhance this app further, consider:

1. **Payment Integration** - Stripe, PayPal, or Razorpay
2. **Push Notifications** - Firebase Cloud Messaging
3. **Analytics** - Firebase Analytics
4. **Error Tracking** - Sentry
5. **Advanced Features**:
   - Product reviews and ratings
   - User profile with avatar upload
   - Order tracking with status updates
   - Advanced search with filters
   - Multi-language support

### Resources

- **Flutter Documentation**: [flutter.dev](https://flutter.dev)
- **BLoC Library**: [bloclibrary.dev](https://bloclibrary.dev)
- **Supabase Docs**: [supabase.com/docs](https://supabase.com/docs)
- **GitHub Repository**: [github.com/Dhiraj706Sardar/ecom](https://github.com/Dhiraj706Sardar/ecom)

### Contact & Support

**Author:** Dhiraj Sardar  
**Email:** sardardhiraj706@gmail.com  
**GitHub:** [@Dhiraj706Sardar](https://github.com/Dhiraj706Sardar)

---

**Thank you for following this guide! Happy coding! 🚀**
