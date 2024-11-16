# Flutter Git Graph

A Flutter application that visualizes data in a GitHub-style contribution graph (heatmap).

## Features

- GitHub-style contribution heatmap
- Interactive tooltips showing daily transaction details
- Mock data generation for testing and demonstration
- Responsive design that works across different screen sizes

# Development Environment
- **OS and version**: macOS Sequoia Version 15.1
- **IDE**: Android Studio Koala
- **Flutter SDK**: 3.24.4

## Supported Platforms
- Android
- iOS

## Installation
To set up the project, follow these steps:

1. **Install FVM (Flutter Version Management)**: 
The following steps for installation are with FVM. You can also avoid using FVM as long as you have Flutter SDK version 3.24.4 installed
Follow the official installation guide: [FVM Installation Guide](https://fvm.app/docs/getting_started/installation).


2. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo/your-project.git
   cd your-project
   ```
3. **Install the specified Flutter SDK version**:
   ```bash
   fvm install 3.24.4
   fvm use 3.24.4
   fvm flutter doctor -v
   ```

4. **Run the project**:
   ```bash
   fvm flutter pub get
   fvm flutter run
   ```

## Using the App
Once the app is launched, the home screen will display a heatmap visualization based on the fetched data. Users can interact with the heatmap to view transaction details through tooltips. The app will show a loading spinner while data is being fetched, providing a smooth user experience.

### User Interaction
- **Heatmap Interaction**: Users can tap on the heatmap cells to view detailed transaction information in a tooltip.
- **Data Refresh**: A floating action button allows users to refresh the data, triggering a new fetch and updating the heatmap accordingly.


## File Structure and Architecure
The file structure is organized as follows:

```
lib/
├── app_state/
│   ├── app_state_provider.dart
├── data/
│   ├── data_classes.dart
│   ├── data_export.dart
│   ├── mock_data.dart
├── features/
│   └── home/
│       ├── home_screen.dart
│       ├── home_vm.dart
├── heatmap/
│   ├── ui/
│   │   ├── widgets/
│   │   │   ├── custom_graph.dart
│   │   │   ├── heatmap_options.dart
│   │   │   ├── heatmap.dart
│   │   ├── view_model.dart
│   ├── heatmap_exports.dart
├── utils/
│   ├── color/
│   ├── text_style_util.dart
│   ├── app_constants.dart
│   ├── utils_export.dart
└── main.dart
```

### main.dart
This is the main entry point of the app. It initializes the application and calls `HomeScreen`.

### lib/features
All features are organized within the `/features` directory. Since we only have one feature(heatmap widget). there is no need to strictly breakdown each feature into data,provider,controller,repository, etc layers.

#### data
This layer contains data models and any data-fetching logic. For example, the `DayData` model and methods to transform data for the heatmap visualization. If there are network calls, they should be handled here, ideally through a repository pattern that abstracts the data source.

#### provider
The provider layer contains the business logic that updates the UI layer. For instance, the `HomeScreenViewModel` manages the loading state and data fetching for the home screen. It uses `ValueNotifier` to notify the UI of changes, ensuring that the UI reacts to data updates seamlessly.

#### ui
The UI layer contains the screens and widgets for each feature. For example, the `HomeScreen` displays the heatmap and handles user interactions. The UI should be broken down into smaller, reusable widgets for better readability and maintainability.

### utils
The `utils` directory contains utility functions and classes that can be reused across the application. This includes helper functions for formatting, data manipulation, and other common tasks.

### color_utils
The `color_utils` file defines color constants and utility functions for managing colors throughout the app. This ensures a consistent color scheme and makes it easy to update colors in one place.

### app_constants
The `app_constants` file contains constant values used throughout the application, such as API endpoints, default values, and configuration settings. This helps avoid magic numbers and strings in the code, making it more maintainable.


## Improvements and Possible Changes

1. **Error Handling**: 
   - Implement comprehensive error handling and assertions for data, UI, etc. This includes handling index out of range errors, null values, and edge cases. The code should be tested for all types of data to ensure robustness.

2. **Mock Data**: 
   - Enhance the mock data to include more realistic scenarios for testing. This will help identify potential loopholes and ensure the app can handle various data structures without requiring significant UI changes.

3. **Better Documentation**: 
   - Improve documentation beyond the `README.md`. Each widget and class should have clear comments and explanations to facilitate understanding and maintenance.

4. **Code Quality**: 
   - Refactor the code to improve readability and efficiency. Breaking down larger widgets into smaller, more manageable components will enhance maintainability and clarity of business logic.

5. **Better Tooltip Implementation**: 
   - Address the tooltip overflow issue when viewing transactions at the end of the heatmap. Implement better logic to ensure tooltips do not overflow and maintain a good UI/UX experience.
