# NAS

NAS is an iOS application that displays the latest news articles and stock information.

## Features

*   View a list of stock prices.
*   View a list of the latest news articles.
*   Pull to refresh the news and stock data.

## Architecture

The project follows the principles of Clean Architecture and MVVM (Model-View-ViewModel).

*   **Domain Layer:** Contains the business logic of the application, including entities, use cases, and repository interfaces.
*   **Data Layer:** Responsible for providing data to the application, including implementations of the repository interfaces defined in the domain layer. It handles data from both local (CSV) and remote (network) sources.
*   **Presentation Layer:** Contains the UI of the application, including view controllers, view models, and storyboards. It is responsible for presenting data to the user and handling user interactions.

## Technologies

*   **Swift:** The programming language used for the application.
*   **UIKit:** The framework used for building the user interface.
*   **RxSwift:** A library for reactive programming.
*   **RxCocoa:** A library that provides Cocoa-specific bindings for RxSwift.
*   **Alamofire:** A library for HTTP networking.
*   **Factory:** A Container-Based Dependency Injection framework.
*   **Kingfisher:** A library for downloading and caching images from the web.
*   **XCTest:** The framework used for unit and UI testing.