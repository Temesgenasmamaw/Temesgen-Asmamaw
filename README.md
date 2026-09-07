# Safaricom M-Pesa Mobile Wallet

A high-performance, pixel-precise **Safaricom M-Pesa** mobile banking application built with **Flutter** following **Clean Architecture** principles, reactive state management using **BLoC**, and rich visual aesthetics with the **IconSax** icon suite.

---

## Table of Contents
1. [Application Overview](#application-overview)
2. [API Contract & Error Handling](#api-contract--error-handling)
3. [Architecture Used & Why](#architecture-used--why)
4. [Packages Used & Why](#packages-used--why)
5. [Important Technical Decisions](#important-technical-decisions)
6. [AI Tools Used & Workflow](#ai-tools-used--workflow)
7. [How to Run the Application](#how-to-run-the-application)

---

## Application Overview

The application faithfully recreates the Safaricom M-Pesa mobile experience across key user journeys:

- **Animated Splash Screen**: 2.5s timed animated branded splash with smooth fade and elastic scale transitions.
- **Authentication & Login**:
  - **Header**: Vibrant Safaricom Red gradient background with subtle diagonal stripe overlay, internationalization language selector (English / Amharic), M-PESA wallet badge logo, and centered user profile information.
  - **4-Digit PIN Input**: Custom PIN entry with active red blinking `|` cursor on the active empty box, clean border styling (no hollow circle placeholders), and red bullet indicators (`●`) on entry.
  - **International Numeric Keypad**: Telephone letter layout (`1`, `2 ABC`, `3 DEF`, `4 GHI`, `5 JKL`, `6 MNO`, `7 PQRS`, `8 TUV`, `9 WXYZ`, `0 +`, backspace).
  - **Footer Links**: Red `Forgot PIN` trigger with modal action, `Contact Us`, and `Terms`.
- **Dashboard**:
  - **Top Bar**: Initials avatar container (`AB`), localized greeting (`Selam, Abebe Bekele`), notification bell, and 3-dots popup options menu (`Settings`, `Help & Support`, `Log Out`).
  - **Redesigned Balance Card**: Safaricom Red card layout featuring masked `Main Balance` (`****`) by default, prominent top-right black `+ Add Money` pill button with white text and icon, horizontal divider, and 3 horizontally aligned columns (`Main Balance`, `Entire Balance`, and eye visibility toggle).
  - **Services Grid with IconSax**: Generously spaced 3×3 service grid with soft red icons ("not real red" rose-crimson `#D63B48` on `#FFF1F2` blush container):
    - **Row 1**: Merchant Payment (`Iconsax.shop`), Bill Payment (`Iconsax.receipt_2`), Credit & Saving (`Iconsax.empty_wallet`).
    - **Row 2**: Transfer Money (`Iconsax.money_send`), Airtime / Package (`Iconsax.mobile`), More Services (`Iconsax.category`).
    - **Interactive Expansion**: Tapping `More Services` smoothly expands Row 3 (`Bank Transfer`, `Cash Out`, `Exchange Rate`).
  - **Recent Transactions Section**: Filterable transaction list with status-tinted IconSax badges (`ATM Cash Withdrawal`, `Bank Transfer`, `Buy Airtime`, `Utility Payment`), debit/credit color indicators, and a `See all →` trigger.
  - **Minimalist Clean Layout**: Bottom navigation removed completely for maximal content visibility, replaced by a floating red QR Scanner button (`Iconsax.scan_barcode`).

---

## API Contract & Error Handling

All HTTP requests route through the centralized `HttpService` (`lib/core/networks/http_service.dart`) utilizing Dio interceptors.

### Endpoint
- **URL**: `https://api.mockfly.dev/mocks/5064738f-5131-4b0a-8909-ca1634e26c27/login`
- **Method**: `POST`
- **Headers**: `Content-Type: application/json`, `Accept: application/json`
- **Request Body**:
  ```json
  {
    "pin": "1111"
  }
  ```

### Successful Response (HTTP 200 OK)
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "USR-10001",
      "name": "John Doe",
      "phoneNumber": "251911234567",
      "email": "john.doe@example.com",
      "balance": 1250.5,
      "currency": "ETB"
    },
    "token": "mock_access_token_123456",
    "expiresIn": 3600
  }
}
```

### Error Response (HTTP 404 Not Found)
```json
{
  "success": false,
  "message": "User not found",
  "error": {
    "code": "USER_NOT_FOUND",
    "details": "No user was found with the provided phone number."
  }
}
```

### Dynamic Error Handling
Rather than falling back to hardcoded or static error strings, the app dynamically extracts both `message` and `error.details` from the server response:
```dart
final msg = loginResponse.message;
final details = loginResponse.error?.details;
final displayMessage = (msg.isNotEmpty && details != null && details.isNotEmpty)
    ? '$msg: $details'
    : (msg.isNotEmpty ? msg : (details ?? 'Authentication failed.'));
```
The exact server message (`User not found: No user was found with the provided phone number.`) is rendered in the inline red error banner and presented via toast notifications.

### Typed Request Payload & Response Models
- **Request Payload**: Handled by `LoginRequestModel` (`lib/features/auth/data/models/login_request_model.dart`), serializing `{ "pin": "..." }`.
- **Response Model**: Handled by `LoginResponseModel` (`lib/features/auth/data/models/login_response_model.dart`), modeling `success`, `message`, `data` (with `user`, `token`, `expiresIn`), and `error` (with `code`, `details`).
- **Clean Contracts**: Both `AuthRemoteDataSource` and `AuthRepository` send `LoginRequestModel payload` and return `Future<LoginResponseModel>`.

---

## Architecture Used & Why

The project strictly implements **Clean Architecture** with separation of concerns:

```
lib/
├── core/                       # Cross-cutting foundational modules
│   ├── config/                 # Environment variables & endpoints (EnvConfig)
│   ├── constants/              # AppColors (Safaricom Red/Dark Red), AppSizes, AppTextStyles
│   ├── di/                     # Dependency injection (GetIt & Injectable)
│   ├── errors/                 # Domain AppException hierarchy & centralized ErrorHandler
│   ├── networks/               # HttpService wrapping Dio with logging & token interceptors
│   ├── routes/                 # Declarative routing with GoRouter
│   ├── utils/                  # Toast & notification utilities
│   └── widgets/                # Core reusable widgets (AppButton, BalanceCard, PinInputField)
│
└── features/
    ├── auth/                   # Authentication feature module
    │   ├── data/
    │   │   ├── datasources/    # AuthRemoteDataSourceImpl (HttpService API caller)
    │   │   ├── models/         # UserModel, LoginRequestModel, LoginResponseModel
    │   │   └── repositories/   # AuthRepositoryImpl
    │   ├── domain/
    │   │   └── repositories/   # Abstract AuthRepository contract
    │   └── presentation/
    │       ├── bloc/           # AuthBloc, AuthEvent, AuthState
    │       ├── pages/          # LoginPage (Pure coordinator < 170 lines)
    │       └── widgets/        # AuthHeaderSection, AuthFooterLinks
    │
    ├── dashboard/              # Dashboard feature module
    │   ├── presentation/
    │   │   ├── bloc/           # DashboardBloc, DashboardEvent, DashboardState
    │   │   ├── pages/          # DashboardPage (Pure coordinator < 120 lines)
    │   │   └── widgets/        # DashboardTopBar, ServicesGrid, RecentTransactionsSection, DashboardBottomNav
    │
    └── splash/                 # Splash screen module
        └── presentation/
            └── pages/          # SplashPage (Timer & animation controller)
```

### Why Clean Architecture?
1. **Separation of Concerns**: Presentation (`bloc/`, `pages/`, `widgets/`) is completely decoupled from API communication and data models.
2. **Testability**: Every layer depends on abstractions (`AuthRepository`, `AuthRemoteDataSource`), allowing effortless mocking with mocktail/mockito.
3. **Maintainability**: Presentation pages are lean coordinators (< 150 lines), delegating UI building to focused, isolated widgets.
4. **Single Source of Truth**: Data flow is strictly unidirectional via BLoC events and states.

---

## Packages Used & Why

| Package | Version | Why It Was Chosen |
|:---|:---:|:---|
| **`flutter_bloc`** | `^9.1.1` | Predictable, event-driven state management with clean separation of UI and business logic. |
| **`iconsax`** | `^0.0.8` | High-quality, modern, outline/linear icon set specifically requested for all dashboard service actions and navigation items. |
| **`dio`** | `^5.11.1` | Robust HTTP client supporting connection/send/receive timeouts, request/response interceptors, and error handling. |
| **`get_it`** & **`injectable`** | `^9.2.1` / `^2.5.0` | Compile-time safe service locator and dependency injection container. |
| **`go_router`** | `^14.8.1` | Declarative routing with URL support, route redirects, and deep linking capabilities. |
| **`json_annotation`** & **`json_serializable`** | `^4.9.0` / `^6.9.4` | Automated, type-safe JSON serialization/deserialization preventing runtime casting issues. |
| **`google_fonts`** | `^6.2.1` | Typography using standard Google Fonts for modern design. |
| **`shimmer`** | `^3.0.0` | Skeleton loading effects for financial balance and transaction items. |
| **`intl`** | `^0.20.2` | Currency, number, and date/time formatting. |

---

## Important Technical Decisions

1. **Direct `HttpService` Encapsulation**:
   - All network calls are encapsulated in `HttpService` (`get`, `post`, `put`, `delete`). Repositories and datasources never interact with raw Dio instances, ensuring uniform headers, timeouts, and logging.
2. **Dynamic API Error Extraction**:
   - Both `AuthRemoteDataSourceImpl` and `ErrorHandler` handle String or Map response payloads, decoding JSON safely and formatting the exact API message (`message: details`) so users receive clear server feedback instead of static text.
3. **PIN Input with Blinking Red Cursor `|`**:
   - Replaced default TextField hints with a custom animated blinking cursor (`FadeTransition` with `AnimationController`) on the active empty PIN box.
   - Removed hollow placeholder circles for a clean, professional aesthetic.
   - Styled entered characters (`●`) and active box borders in Safaricom Red.
4. **Height-Optimized Services Grid**:
   - Rather than an inflexible GridView that takes excessive vertical height on mobile viewports, the grid uses compact Rows with 38×38 icon tiles.
   - Default 2-row layout (`Merchant Payment`, `Bill Payment`, `Credit & Saving`, `Transfer Money`, `Airtime / Package`, `More Services`) leaves Recent Transactions fully visible on screen.
   - Tapping `More Services` smoothly expands the 3rd row with an `AnimatedSize` transition.
5. **Interactive Masked Balance Card**:
   - Balance amounts are masked (`****`) by default as specified in banking security guidelines.
   - Tapping the `Iconsax.eye` icon dynamically toggles masking with a smooth `AnimatedSwitcher` transition.
6. **Safaricom Red Brand Theme**:
   - Standardized primary colors and card gradients to official Safaricom Red (`#E31937` to `#B3141B`) with matching shadow glows.
7. **Reusable Widget System (`lib/core/widgets/`)**:
   - Created first-class reusable UI components with strong encapsulation and customizable parameters:
     - `CustomButton`: Variant support (`primary`, `black`, `outline`, `secondary`), loading spinners, custom icons, and width/padding overrides.
     - `CustomInput`: Clean text field with label support, password toggle visibility, prefix/suffix icons, and custom validation.
     - `CustomServiceTile`: Modular service action item with flexible sizing, soft backgrounds, and touch ripple effects.
     - `CustomCard`: Consistent elevations, custom corner radii, borders, and shadows across all dashboard cards.
8. **Intentional Form Submission (PIN Entry)**:
   - Rather than auto-submitting immediately when 4 digits are entered, the user retains control to review their PIN. Entering 4 digits enables the `Continue` button, which shows an in-flight loading spinner during the API call.
9. **Curated "Red But Not Real Red" Palette**:
   - Replaced harsh saturated neon reds on dashboard service icons with a refined, soft rose-crimson (`#D63B48`) on a gentle blush container (`#FFF1F2`).
10. **Decluttered Dashboard Navigation**:
   - Removed the bottom navigation bar to provide an unobstructed view of financial transactions and balance details, while retaining instant access to QR scanning through a prominent red `QrScannerFab`.

---

## AI Tools Used & Workflow

During the development of this application, AI tooling (Google DeepMind Antigravity) was used pair-programming with the developer:

1. **Architecture Planning & Refactoring**:
   - Structured the project strictly into Clean Architecture folders (`bloc`, `pages`, `widgets`).
   - Refactored monolithic pages into single-responsibility, reusable widgets.
2. **API Contract Alignment**:
   - Extracted live Mockfly API response formats and generated matching `LoginResponseModel`, `LoginRequestModel`, and `UserModel` classes.
   - Diagnosed 404 response parsing to display dynamic server error details.
3. **UI & Aesthetic Precision**:
   - Refined the 3×3 and 2×3 services grid layout, icon scaling, and vertical spacing to solve viewport layout constraints.
   - Integrated the `iconsax` icon library across all dashboard and navigation elements.
4. **Static Analysis & Code Quality**:
   - Verified that every change compiled cleanly with **0 errors and 0 warnings** using `flutter analyze`.

---

## How to Run the Application

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.10.1`)
- Dart SDK (`>= 3.10.1`)
- Android Studio / VS Code with Flutter extensions
- Android Emulator or physical device

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-name/mobile_wallet.git
   cd mobile_wallet
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Code (Serialization & Dependency Injection)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run Static Analysis (Verify 0 issues)**:
   ```bash
   flutter analyze
   ```

5. **Launch the Application**:
   ```bash
   flutter run
   ```

### Test Credentials
- **Correct PIN**: `1111` (Authenticates against Mockfly and opens Dashboard with user John Doe, 1250.50 ETB).
- **Incorrect PIN**: Any other 4 digits, e.g. `2222` (Triggers HTTP 404 and displays dynamic API error: `"User not found: No user was found with the provided phone number."`).
