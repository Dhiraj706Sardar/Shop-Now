# E-Commerce Flutter App

A production-ready Flutter e-commerce application built with **Clean Architecture**, featuring:

- ✅ **Clean Architecture** (data, domain, presentation layers)
- ✅ **BLoC + Cubit** for state management
- ✅ **AutoRoute** for navigation with guards
- ✅ **Retrofit + Dio** for networking
- ✅ **Hive** for local storage
- ✅ **Freezed** for immutable models
- ✅ **Equatable** for value equality
- ✅ **Supabase** for authentication and backend
- ✅ **Get_it + Injectable** for dependency injection

## 📁 Project Structure

```
lib/
├── src/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   └── hive_constants.dart
│   │   ├── di/
│   │   │   ├── injection.dart
│   │   │   ├── hive_module.dart
│   │   │   ├── network_module.dart
│   │   │   └── supabase_module.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   └── dio_client.dart
│   │   └── usecases/
│   │       └── usecase.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       └── bloc/
│   │   ├── cart/
│   │   ├── orders/
│   │   ├── products/
│   │   └── wishlist/
│   ├── router/
│   │   ├── app_router.dart
│   │   └── guards/
│   └── app.dart
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Supabase account (for backend)

### Installation

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Configure Supabase:**
   
   Open `lib/src/core/di/supabase_module.dart` and replace:
   ```dart
   url: 'YOUR_SUPABASE_URL',
   anonKey: 'YOUR_SUPABASE_ANON_KEY',
   ```

3. **Run code generation:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

   Or watch for changes:
   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🔧 Code Generation

This project uses several code generators:

- **Freezed**: For immutable data classes
- **JSON Serializable**: For JSON serialization
- **Injectable**: For dependency injection
- **Auto Route**: For routing
- **Hive**: For type adapters
- **Retrofit**: For API client

Run code generation whenever you:
- Add/modify Freezed models
- Add/modify API endpoints
- Add/modify Hive models
- Add/modify routes
- Add/modify injectable classes

## 📦 Features

### 1. Authentication (Supabase)
- Email/password sign in
- Email/password sign up
- Sign out
- Session management
- Auth guard for protected routes

### 2. Products (Fake Store API)
- Fetch all products
- Fetch single product
- Fetch categories
- Fetch products by category

### 3. Cart (Hive - Offline First)
- Add to cart
- Remove from cart
- Update quantity
- Clear cart
- Persistent storage

### 4. Orders (Supabase)
- Create order from cart
- Fetch user orders
- Fetch single order
- Order status tracking

### 5. Wishlist (Hive)
- Add to wishlist
- Remove from wishlist
- Check if product is in wishlist
- Persistent storage

## 🗺️ Routes

- `/` - Splash Screen
- `/auth` - Authentication Page
- `/home` - Home Page (Protected)
- `/product/:id` - Product Details (Protected)
- `/cart` - Cart Page (Protected)
- `/checkout` - Checkout Page (Protected)
- `/orders` - Orders Page (Protected)
- `/profile` - Profile Page (Protected)

## 🏗️ Architecture

This project follows **Clean Architecture** principles:

### Data Layer
- **Models**: Freezed data classes with JSON serialization
- **Data Sources**: Remote (API) and Local (Hive) data sources
- **Repositories**: Implementation of domain repositories

### Domain Layer
- **Entities**: Business models (using data models)
- **Repositories**: Abstract repository interfaces
- **Use Cases**: Business logic

### Presentation Layer
- **BLoC/Cubit**: State management
- **Pages**: UI screens
- **Widgets**: Reusable UI components

## 📚 Key Packages

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `equatable` | Value equality |
| `freezed` | Immutable models |
| `dio` | HTTP client |
| `retrofit` | Type-safe API client |
| `auto_route` | Declarative routing |
| `get_it` | Service locator |
| `injectable` | Code generation for DI |
| `hive` | Local database |
| `supabase_flutter` | Backend as a service |
| `dartz` | Functional programming (Either) |

## 🔄 Data Flow Example

### Fetch Products:
1. UI triggers `ProductBloc` event
2. Bloc calls `GetProducts` use case
3. Use case calls `ProductRepository`
4. Repository calls `ProductRemoteDataSource`
5. Data source makes API call via `Retrofit`
6. Response flows back through layers
7. Bloc emits new state
8. UI rebuilds

### Add to Cart:
1. UI calls `CartCubit.addToCart()`
2. Cubit calls `CartRepository`
3. Repository calls `CartLocalDataSource`
4. Data source saves to `Hive`
5. Cubit emits updated state
6. UI rebuilds

## 🛠️ Development

### Adding a New Feature

1. Create feature folder structure:
   ```
   features/new_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── bloc/
       └── pages/
   ```

2. Implement data layer (models, data sources, repositories)
3. Implement domain layer (repository interface, use cases)
4. Implement presentation layer (BLoC/Cubit, pages)
5. Register in dependency injection
6. Run code generation

### Running Tests

```bash
flutter test
```

## 📝 TODO

- [ ] Implement UI for all pages
- [ ] Add search functionality
- [ ] Add filters and sorting
- [ ] Implement payment integration
- [ ] Add product reviews
- [ ] Add user profile management
- [ ] Add order tracking
- [ ] Implement push notifications
- [ ] Add analytics
- [ ] Add error tracking (Sentry)

## 🔐 Supabase Setup

### Database Tables

Create these tables in your Supabase project:

#### Orders Table
```sql
create table orders (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  items jsonb not null,
  total decimal not null,
  status text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table orders enable row level security;

-- Policies
create policy "Users can view own orders"
  on orders for select
  using (auth.uid() = user_id);

create policy "Users can create own orders"
  on orders for insert
  with check (auth.uid() = user_id);
```

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Contact

For questions or support, reach out to me:

- **GitHub**: [@Dhiraj706Sardar](https://github.com/Dhiraj706Sardar)
- **LinkedIn**: [Dhiraj Sardar](https://linkedin.com/in/dhiraj-sardar)
- **Email**: [dhiraj.sardar@example.com](mailto:sardardhiraj706@gmail.com)

Feel free to open an issue on this repository for bugs or feature requests.
