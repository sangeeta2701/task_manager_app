# Task Manager App

A Flutter-based Task Management mobile application built as part of a Flutter Developer technical assessment. The app allows users to create, view, update, and delete tasks with search, filter, and sort capabilities, integrated with the DummyJSON Todos API.

---

## Features

- **Splash Screen** – Branded entry screen with auto-navigation to the dashboard.
- **Dashboard (Home Screen)**
  - Personalized user header
  - Real-time search bar with focus management
  - "Today's Focus" banner
  - Live statistics: Total, Pending, Done, Active (single-row compact pills)
  - Filter and Sort bottom sheets
  - Task list with color-coded status indicators
  - Bottom navigation with centered Floating Action Button
- **Create Task Screen**
  - Form with Title, Description, Priority, Category, Status, Due Date, Assigned To, and Assigned By
  - Native date picker
  - Input validation with SnackBar feedback
- **Task Detail Screen**
  - Priority badge, title, and description
  - Info card (Assigned By/To, Due Date, Category)
  - Dynamic status update dropdown with smart assignment logic
  - Delete task with confirmation dialog
- **Search** – Filter tasks by title in real time with keyboard-aware focus handling.
- **Filter** – Filter tasks by status.
- **Sort** – Sort tasks by Priority, Due Date, or Status.
- **Delete** – Remove tasks with a confirmation popup.
- **API Integration** – Fetches initial tasks from [DummyJSON Todos API](https://dummyjson.com/todos).
- **States** – Loading, error, and empty states handled across all screens, with a friendly error UI and a retry action for network failures.

---

## Tech Stack

| Category | Technology |
| :--- | :--- |
| Framework | Flutter (3.x) |
| Language | Dart (3.x) |
| State Management | Provider (^6.1.1) |
| Networking | HTTP (^1.1.0) |
| Date Formatting | intl (^0.18.1) |
| Typography | google_fonts (^6.1.0) |

---

## Architecture

The project follows a **Feature-First Architecture** with clear separation between data, business logic, and presentation layers.

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── utils/
│   │   ├── responsive.dart
│   │   └── route_observer.dart
│   └── widgets/
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   └── home/
│       ├── data/
│       │   ├── models/
│       │   │   └── task_model.dart
│       │   └── services/
│       │       └── api_service.dart
│       ├── provider/
│       │   └── task_provider.dart
│       ├── screens/
│       │   ├── add_task_screen.dart
│       │   ├── home_screen.dart
│       │   └── task_detail_screen.dart
│       └── widgets/
│           ├── build_dropdown.dart
│           ├── build_header.dart
│           ├── build_status_grid.dart
│           ├── build_status_pill.dart
│           ├── build_text_field.dart
│           ├── build_todays_focus.dart
│           ├── search_bar.dart
│           ├── show_filter_bottom_sheet.dart
│           ├── show_sort_bottom_sheet.dart
│           └── task_card.dart
└── main.dart
```

### Layer Responsibilities

| Layer | Responsibility |
| :--- | :--- |
| Data | Task model, JSON parsing, API service |
| Business Logic | TaskProvider (state, filters, sorting, CRUD) |
| Presentation | Screens and reusable widgets |
| Core | Shared colors, typography, responsive utilities, route observer |

---

## State Management

Provider (`ChangeNotifier`) is used for state management.

### TaskProvider API

| Method | Purpose |
| :--- | :--- |
| `loadTasks()` | Fetch tasks from API |
| `addTask(Task)` | Add a new task |
| `deleteTask(int id)` | Remove a task |
| `updateTaskStatus(int id, String status)` | Update status and reassign |
| `searchTasks(String query)` | Filter by title |
| `setFilterStatus(String status)` | Filter by status |
| `setSortOption(SortOption)` | Sort by priority, due date, or status |

### Smart Assignment Logic

When a task status is updated:

- `Discussion Required` → reassigned to **Manager**
- `Shared for Testing` → reassigned to **QA Team**
- `Completed` → unassigned

---

## API Integration

**Endpoint:** `GET https://dummyjson.com/todos?limit=30`

- All API calls are encapsulated in `ApiService`.
- Initial data is fetched via `TaskProvider.loadTasks()`.
- Since DummyJSON is read-only for POST/PUT/DELETE, the app uses **optimistic local state updates** for create, update, and delete operations.

### Error Handling

The `ApiService` uses a typed `ApiException` to distinguish between failure modes and provide user-friendly messages:

| Scenario | User Message |
| :--- | :--- |
| 404 | "The task service is currently unavailable. Please try again later." |
| 500 | "Something went wrong on our end. Please try again in a moment." |
| 401 / 403 | "You don't have permission to access this resource." |
| No internet (`SocketException`) | "No internet connection. Please check your network and try again." |
| Timeout (>15s) | "The request took too long. Please check your connection and retry." |
| Malformed JSON | "Received invalid data from the server. Please try again." |
| Unknown error | "Something unexpected happened. Please try again." |

The Home screen renders a friendly error card with an icon, the specific error message, and a **Retry** button.

---

## UI/UX Design

- **Color Palette:** Teal-based theme with gradient headers.
- **Typography:** Poppins (via `google_fonts`).
- **Components:** Rounded corners, soft shadows, color-coded badges.
- **Responsive:** Layout adapts to small, medium, and tablet screens via a custom `Responsive` utility.
- **Keyboard-Aware:** The search bar uses a global `RouteObserver` to automatically dismiss focus and keyboard when returning to the Home screen from any pushed route.
- **Screens:** Splash, Home, Add Task, Task Detail.

| Token | Hex |
| :--- | :--- |
| Primary | `#2A9D8F` |
| Primary Dark | `#264653` |
| Background | `#F4F7F6` |
| Pending | `#E76F51` |
| In Progress | `#F4A261` |
| Completed | `#2A9D8F` |
| Discussion | `#E63946` |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.x
- Android Studio / VS Code
- Emulator or physical device

### Installation

```bash
git clone https://github.com/sangeeta2701/task_manager_app
cd task_manager_app
flutter pub get
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

---

## Known Limitations

- Data is not persisted locally (DummyJSON is read-only).
- No authentication (mock user).
- Only status can be updated from the detail screen; full task editing is not implemented.
- No offline support.
- API requests time out after 15 seconds; the user is prompted to retry.

---

## Future Enhancements

- Local persistence using Hive or Isar
- Full task editing screen
- Push notifications for due dates
- Dark mode toggle
- Unit and widget tests
- CI/CD pipeline


*Built as part of a Flutter Developer technical assessment.*