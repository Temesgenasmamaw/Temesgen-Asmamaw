# Safaricom M-Pesa Mobile Wallet

A high-performance, pixel-precise **Safaricom M-Pesa** mobile banking application built with **Flutter**, featuring **Clean Architecture**, reactive state management with **BLoC**, dependency injection with **GetIt & Injectable**, and rich visual aesthetics leveraging the **IconSax** icon suite.

---

## Table of Contents
1. [Application Overview](#application-overview)
2. [Architecture Used & Why](#architecture-used--why)
3. [Packages Used & Why](#packages-used--why)
4. [Important Technical Decisions & Why](#important-technical-decisions--why)
5. [AI Tools Used & How They Were Used](#ai-tools-used--how-they-were-used)
6. [How to Run the Application](#how-to-run-the-application)
7. [API Contract & Dynamic Error Handling](#api-contract--dynamic-error-handling)

---

## Application Overview

The application faithfully recreates the Safaricom M-Pesa mobile experience across core user journeys:

- **White Splash Screen**: Solid white background (`AppColors.white`) with a branded Safaricom Red gradient badge, white wallet icon, bold `M-PESA` brand title, and `by Safaricom` subtitle.
- **Authentication & Login**:
  - **Header Section**: Red diagonal-patterned banner with convex rounded bottom corners (`bottomLeft: Radius.circular(36)`, `bottomRight: Radius.circular(36)`), language selector dropdown (`English / Amharic`), and a floating white rounded profile card stacked directly on top of the red image.
  - **Profile Information**: Displays the circular avatar (soft blush fill `#FDECEC`, thin red border `#E28787`, red person icon) alongside user details (`Welcome back`, `John Kamau`, `+254 7** *** 678`) in a single horizontal row.
  - **4-Digit PIN Input**: Custom PIN entry featuring an animated blinking red `|` cursor on active empty boxes, red bullet indicators (`●`) on entry, and red error borders when validation fails.
  - **Inline Error State**: Renders a centered red inline message (`Incorrect PIN. Please try again.`) positioned between the PIN boxes and keypad.
  - **International Numeric Keypad**: Telephone letter layout (`1`, `2 ABC`, `3 DEF`, `4 GHI`, `5 JKL`, `6 MNO`, `7 PQRS`, `8 TUV`, `9 WXYZ`, `0 +`, backspace).
  - **Intentional Submission**: Enters 4 digits to enable the primary black `Continue` button with an in-flight loading spinner.
  - **Footer Links**: `Forgot PIN` modal trigger, `Contact Us`, and `Terms`.
- **Dashboard**:
  - **Top Bar**: User initials avatar badge (`AB`), localized greeting (`Selam, Abebe Bekele`), and notification bell.
  - **Enlarged Balance Card**: Safaricom Red gradient card with masked `Main Balance` (`****`) by default, top-right black `+ Add Money` pill button with white text and icon, horizontal divider, and 3 columns (`Main Balance`, `Entire Balance`, and eye visibility toggle).
  - **3×3 Services Grid with IconSax**: Generously spaced grid with curated "not real red" rose-crimson icons (`AppColors.softRed` `#D63B48` on `#FFF1F2` blush container):
    - **Row 1**: Merchant Payment (`Iconsax.shop`), Bill Payment (`Iconsax.receipt_2`), Credit & Saving (`Iconsax.empty_wallet`).
    - **Row 2**: Transfer Money (`Iconsax.money_send`), Airtime / Package (`Iconsax.mobile`), More Services (`Iconsax.category`).
    - **Row 3 (Expandable)**: Bank Transfer, Cash Out, Exchange Rate.
  - **Recent Transactions Section**: Filterable transaction items with status badges, debit/credit color indicators, and a `See all →` trigger.
  - **Floating QR Scanner FAB**: Floating red `Iconsax.scan_barcode` action button with clean viewport and no bottom navigation bar.

---

## Architecture Used & Why

The project strictly follows **Clean Architecture** organized with a **Feature-First** structure:

```
lib/
├── core/                               # Cross-cutting foundational modules
│   ├── config/                         # Environment config & baseUrl (EnvConfig)
│   ├── constants/                      # AppColors, AppSizes, AppTextStyles
│   ├── di/                             # Dependency Injection (GetIt & Injectable)
│   ├── errors/                         # AppException hierarchy & ErrorHandler
│   ├── networks/                       # HttpService (Dio wrapper with interceptors)
│   ├── routes/                         # Declarative routing with GoRouter
│   ├── utils/                          # Toast & UI utilities
│   └── widgets/                        # First-class reusable component library
│       ├── custom_button.dart          # Variant button with loading indicators
│       ├── custom_input.dart           # Form field with prefix/suffix/password toggle
│       ├── custom_card.dart            # Styled card surface with elevation
│       ├── custom_service_tile.dart    # Grid action item with soft badges
│       ├── balance_card.dart           # Interactive masked financial balance card
│       └── pin_input_field.dart        # 4-digit PIN input & international keypad
│
└── features/
    ├── auth/                           # Authentication feature module
    │   ├── data/
    │   │   ├── datasources/            # AuthRemoteDataSourceImpl
    │   │   ├── models/                 # UserModel, LoginRequestModel, LoginResponseModel
    │   │   └── repositories/           # AuthRepositoryImpl
    │   ├── domain/
    │   │   └── repositories/           # Abstract AuthRepository contract
    │   └── presentation/
    │       ├── bloc/                   # AuthBloc, AuthEvent, AuthState
    │       ├── pages/                  # LoginPage
    │       └── widgets/                # AuthHeaderSection, AuthFooterLinks
    │
    ├── dashboard/                      # Dashboard feature module
    │   ├── data/
    │   │   ├── datasources/            # DashboardRemoteDataSourceImpl
    │   │   ├── models/                 # TransactionModel
    │   │   └── repositories/           # DashboardRepositoryImpl
    │   ├── domain/
    │   │   └── repositories/           # Abstract DashboardRepository contract
    │   └── presentation/
    │       ├── bloc/                   # DashboardBloc, DashboardEvent, DashboardState
    │       ├── pages/                  # DashboardPage
    │       └── widgets/                # DashboardTopBar, ServicesGrid, RecentTransactionsSection, QrScannerFab
    │
    └── splash/                         # Splash screen module
        └── presentation/
            └── pages/                  # SplashPage
```

### Why Clean Architecture?

1. **Separation of Concerns**: Presentation (`bloc/`, `pages/`, `widgets/`) knows nothing about Dio, HTTP, or serialization. The domain layer contains purely business contracts.
2. **High Testability**: Every dependency depends on abstractions (`AuthRepository`, `AuthRemoteDataSource`), allowing effortless mocking with `mocktail` or `mockito` in unit and widget tests.
3. **Maintainability & Scalability**: Presentation pages are lean coordinators (< 150 lines) delegating UI building to focused, isolated, reusable widgets.
4. **Single Source of Truth**: UI state changes are strictly unidirectional through BLoC events and states.

---

## Packages Used & Why

| Package | Version | Why It Was Chosen |
|:---|:---:|:---|
| **`flutter_bloc`** | `^9.1.1` | Predictable, event-driven state management with explicit separation between UI and business logic. |
| **`iconsax`** | `^0.0.8` | Modern outline/linear icon suite matching Safaricom design language across all dashboard and navigation items. |
| **`dio`** | `^5.11.1` | Powerful HTTP client providing connection/send/receive timeouts, request/response interceptors, and error handling. |
| **`get_it`** & **`injectable`** | `^9.2.1` / `^2.5.0` | High-speed, compile-time safe service locator and dependency injection container. |
| **`go_router`** | `^14.8.1` | Declarative routing with URL support, transition management, and route redirects. |
| **`json_annotation`** & **`json_serializable`** | `^4.9.0` / `^6.9.4` | Automated, type-safe JSON serialization/deserialization preventing manual runtime parsing errors. |
| **`google_fonts`** | `^6.2.1` | Typography using Google Fonts for clean, modern aesthetic. |
| **`shimmer`** | `^3.0.0` | Skeleton loading effects for financial balances and transaction cards. |
| **`intl`** | `^0.20.2` | Date/time and currency formatting (`ETB 1,250.50`). |
| **`flutter_test`** | SDK | Comprehensive unit and widget testing framework. |

---

## Important Technical Decisions & Why

1. **Typed Request Payload & Response Architecture**:
   - `AuthRemoteDataSource.login` receives strongly typed `LoginRequestModel payload` (`{ "pin": "1111" }`) and returns `Future<LoginResponseModel>`.
   - `LoginResponseModel.fromDynamic` encapsulates safe parsing of `Map` or `String` JSON without repetitive boilerplate in data sources.
2. **Centralized `HttpService` & Dynamic Error Extraction**:
   - All network calls pass through `HttpService` (`lib/core/networks/http_service.dart`) with request/response/error logging interceptors.
   - `ErrorHandler` dynamically extracts both `message` and `error.details` from the server response (e.g. `"User not found: No user was found with the provided phone number."`) rather than showing generic fallback strings.
3. **Dependency Injection with `GetIt` & Annotations**:
   - All services and data sources are annotated with `@Singleton()`, `@LazySingleton(as: ...)`, and `@injectable`.
   - Centralized registration in `injection.dart` makes dependencies easy to mock and swap during testing.
4. **Reusable Component Library (`lib/core/widgets/`)**:
   - Extracted modular widgets (`CustomButton`, `CustomInput`, `CustomServiceTile`, `CustomCard`, `BalanceCard`, `FourDigitPinInput`) to guarantee reusability, consistency, and zero duplicated styling.
5. **Custom Animated PIN Input with Red Blinking `|` Cursor**:
   - Custom `FourDigitPinInput` displays an active blinking red cursor (`|`) on empty active boxes, red filled dots (`●`), clean borders (no hollow placeholders), and red error borders on invalid attempts.
6. **Stacked Profile Card over Red Patterned Header**:
   - Stacks the profile card (Avatar + Details in one row) directly on top of the red diagonal-patterned image with convex rounded bottom corners (`36px`), creating a layered visual hierarchy.
7. **Curated "Red But Not Real Red" Palette**:
   - Applied a refined rose-crimson (`AppColors.softRed` `#D63B48`) on a delicate blush container (`AppColors.softRedSurface` `#FFF1F2`) to avoid visual fatigue and maintain brand elegance.
8. **Intentional Form Submission**:
   - PIN entry does not auto-submit abruptly; entering 4 digits enables the primary `Continue` button, which displays an in-flight loading spinner during API communication.
9. **Minimalist Viewport (Bottom Navigation Removed)**:
   - Eliminated the bottom navigation bar to give maximum screen real estate to balances and transactions, pairing with a red `QrScannerFab`.

---

## AI Tools Used & How They Were Used

During the development of this application, **Google DeepMind Antigravity** AI assistant was used for pair-programming and engineering acceleration:

1. **Architecture Planning & Clean Layering**:
   - Established Clean Architecture directories (`core`, `features/auth`, `features/dashboard`, `features/splash`).
   - Defined strict contracts (`AuthRepository`, `AuthRemoteDataSource`, `DashboardRepository`) and BLoC state schemas.
2. **API Contract Generation & Error Handling**:
   - Analyzed the Mockfly M-Pesa Login API specification to produce typed `LoginRequestModel`, `LoginResponseModel`, and `UserModel`.
   - Diagnosed 404 response payload formats to parse dynamic server error messages.
3. **UI/UX Refactoring & Pixel-Precision**:
   - Rebuilt the login header into a stacked layout with convex rounded bottom corners based on user reference screenshots.
   - Designed the custom animated 4-digit PIN input with blinking red cursor and international numeric keypad.
   - Refined the 3×3 services grid with IconSax icons, generous spacing, and custom soft red palettes.
4. **Static Analysis & Automated Testing**:
   - Executed continuous static verification using `flutter analyze` ensuring **0 errors and 0 warnings**.
   - Created automated widget tests in `test/widget_test.dart` verifying splash screen navigation, login profile rendering, and PIN interaction.

---

## How to Run the Application

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.10.1`)
- Dart SDK (`>= 3.10.1`)
- Android Studio / VS Code with Flutter extensions
- Android Emulator, iOS Simulator, or connected physical device

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

5. **Run Automated Tests**:
   ```bash
   flutter test
   ```

6. **Launch the Application**:
   ```bash
   flutter run
   ```

### Test Credentials
- **Successful Login**: Enter PIN `1111` → Authenticates via Mockfly API and navigates to the Dashboard with user profile and balance (`ETB 1,250.50`).
- **Error Handling**: Enter any other 4 digits (e.g. `2222`) → Displays inline error message (`Incorrect PIN. Please try again.`) and red error border on PIN boxes.

---

## API Contract & Dynamic Error Handling

- **Endpoint**: `POST https://api.mockfly.dev/mocks/5064738f-5131-4b0a-8909-ca1634e26c27/login`
- **Request Headers**: `Content-Type: application/json`, `Accept: application/json`
- **Request Body**:
  ```json
  {
    "pin": "1111"
  }
  ```
- **Successful Response (HTTP 200 OK)**:
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
- **Error Response (HTTP 404 Not Found)**:
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
