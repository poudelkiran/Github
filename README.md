# GitHub Users and Repositories Project

This project is built using Swift and leverages the GitHub API to list github users and their repositories. It employs modern design patterns and frameworks including MVVM (Model-View-ViewModel), SwiftUI, Combine, and supports pagination.

## Features

- **MVVM Architecture**: Ensures a clean separation of concerns, making the codebase more manageable and testable.
- **SwiftUI**: Utilizes SwiftUI for declarative UI development, ensuring a reactive and swift interface.
- **Combine**: Handles asynchronous operations and data binding.
- **Pagination**: Implements efficient data fetching with pagination support.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

### Screenshots

#### Main Screen

![Main Screen](Github/Resources/Assets.xcassets/Home.imageset/Home.png)

#### User Detail

![User Detail](Github/Resources/Assets.xcassets/Detail.imageset/Detail.png)

## Architecture

### MVVM (Model-View-ViewModel)

- **Model**: Represents the data structures of the GitHub API.
- **View**: SwiftUI views that render the UI.
- **ViewModel**: Manages the state and logic for each view, interacting with the Model and updating the View.

### SwiftUI

- Declarative UI components.
- Reactive interface that updates automatically based on the state managed by the ViewModel.

### Combine

- Publishers and Subscribers for handling asynchronous data streams.
- Data binding between ViewModel and View.

### Pagination

- Efficient data fetching by loading more data as the user scrolls.
- Ensures a smooth user experience even with large datasets.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes. Make sure to follow the code style and add appropriate tests for any new functionality.

## Contact

For any questions or feedback, please open an issue on GitHub or contact the project maintainers.

---
