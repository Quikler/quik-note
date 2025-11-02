# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

quik_note is a cross-platform Flutter application for managing notes and todos with SQLite persistence. The app supports Android, iOS, Linux, macOS and Windows.

## Development Commands

### Running the Application
```bash
make fl  # Run on Linux
```

### Building
```bash
flutter build <platform>  # android, ios, linux, macos, windows, web
```

### Testing
```bash
flutter test
```

### Dependencies
```bash
flutter pub get        # Install dependencies
flutter pub upgrade    # Upgrade dependencies
```

### Code Quality
```bash
flutter analyze        # Run static analysis
```

## Architecture

### State Management
The app uses **Provider** for state management with global providers initialized in `lib/main.dart`:
- `NotesListModel` - Manages notes list, search, starred notes, and selection state
- `TodosListModel` - Manages todos list and their hierarchical structure (parent-child relationship)
- `AppBarModel` - Controls app bar mode (initial vs select mode)
- `CurrentPageModel` - Manages current page state (notes vs todos)

All providers are available globally across the app widget tree.

### Database Layer
SQLite database via `sqflite` (mobile) and `sqflite_common_ffi` (desktop):
- Single database file: `notes.db` containing both `notes` and `todos` tables
- Database initialization in `lib/data/db.dart:getNotesDb()`
- CRUD operations separated by entity:
  - `lib/data/db_note.dart` - Note operations
  - `lib/data/db_todo.dart` - Todo operations (supports batch operations)

Database schema:
- `notes` table: id, title, content, starred (boolean), creationTime, lastEditedTime
- `todos` table: id, title, parentId (for subtasks), checked (boolean), completed (boolean)

### Data Models
- `lib/models/note.dart` - Note model with copyWith pattern
- `lib/models/todo.dart` - Todo model with parent-child relationship support
- Both models use `toMap()` for database serialization
- Helper extension in `lib/utils/helpers.dart` for bool/int conversions (SQLite stores booleans as integers)

### Navigation Pattern
The app uses a navigation bar to switch between Notes and Todos pages:
- `CurrentPageModel` handles page switching via `PagesEnum` (notes, todos)
- Each page has a corresponding form page for create/edit operations
- Forms are accessed via FloatingActionButton which navigates to the current page's `formPageToNavigate`

### Page Structure
- `lib/pages/` - Form pages for CRUD operations
- `lib/widgets/` - Reusable UI components (lists, cards, app bar, bottom bar)
- `lib/forms/` - Form implementations for creating/editing notes and todos
- `lib/wrappers/` - Layout wrappers for consistent styling (MainWrapper, margins, responsive text)

### Selection Mode
The app has a selection mode for bulk operations:
- `AppBarModel.mode` toggles between `initial` and `select` modes
- When in select mode, back button exits selection instead of navigating back (see `lib/main.dart:76-84`)
- Selected items tracked in `NotesListModel.selectedNotes` and `TodosListModel.selectedTodos`

### ViewModels
- `lib/viewmodels/` - Contains view-specific logic for todos (checkbox text field management)

## Platform-Specific Notes

### Desktop Platforms (Linux, macOS, Windows)
- Requires FFI initialization for SQLite in `main()` before running the app
- Uses `sqflite_common_ffi` instead of standard `sqflite`

### Mobile Platforms (Android, iOS)
- Uses standard `sqflite` package
- Native splash screen configured in `pubspec.yaml` with color `#916fcc`

## Key Dependencies
- `provider` ^6.1.5 - State management
- `sqflite` ^2.4.2 - SQLite for mobile
- `sqflite_common_ffi` - SQLite for desktop
- `flutter_staggered_grid_view` ^0.7.0 - Grid layout for notes
- `intl` ^0.20.2 - Date/time formatting
- `flutter_svg` ^2.2.0 - SVG rendering

## GitHub Integration
The repo has Claude Code GitHub Actions configured (`.github/workflows/claude.yml`) that triggers when:
- Issues/PRs are opened with `@claude` mention
- Comments on issues/PRs contain `@claude`
- Reviews are submitted with `@claude`
