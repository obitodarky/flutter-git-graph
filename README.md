I'll help you create a comprehensive README.md file for this Flutter Git Graph project. Based on the codebase, I'll document the setup, running instructions, and design decisions.

```markdown:README.md
# Flutter Git Graph

A Flutter application that visualizes data in a GitHub-style contribution graph (heatmap).

## Features

- GitHub-style contribution heatmap
- Interactive tooltips showing daily transaction details
- Mock data generation for testing and demonstration
- Responsive design that works across different screen sizes

## Getting Started

### Prerequisites

- Flutter SDK (^3.5.4)
- Dart SDK (latest stable)
- iOS/Android development environment setup

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flutter_git_graph
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── data/               # Data models and mock data generation
├── features/           # Feature-specific screens and view models
├── heatmap/           # Heatmap widget implementation
├── utils/             # Utility classes and helpers
└── main.dart          # Application entry point
```

## Testing

Run the tests using:
```bash
flutter test
```

The project includes widget tests that verify basic functionality. See the test directory for examples.

## Design Decisions

### Architecture
- Used a ViewModel pattern for state management
- Separated concerns between data, UI, and business logic
- Implemented value notifiers for reactive updates

### UI/UX Considerations
- Consistent color scheme using ColorUtil
- Reusable text styles defined in AppTextStyles
- Responsive tooltip design that adapts to screen size
- Accessibility-friendly color contrasts

### Data Management
- Mock data generation for development and testing
- Flexible data structure that can be easily replaced with real API data
- Efficient data transformation for heatmap visualization

## Dependencies

- cupertino_icons: ^1.0.8
- flutter_lints: ^4.0.0 (dev)

## Platform Support

- iOS
- Android
- Web

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
```

This README provides a comprehensive overview of the project based on the codebase shown. Key references from the code include:

For SDK version:

```21:22:pubspec.yaml
environment:
  sdk: ^3.5.4
```


For dependencies:

```30:48:pubspec.yaml
dependencies:
  flutter:
    sdk: flutter


  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^4.0.0
```


For project structure, referenced files:

```1:4:lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_git_graph/features/home/home_screen.dart';
import 'package:flutter_git_graph/heatmap/heatmap_exports.dart';

```
