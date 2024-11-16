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

