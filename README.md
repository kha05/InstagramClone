# InstagramClone - Instagram Stories Feature

## 🏗 Architecture Overview

This project implements an Instagram-like Stories feature using modern iOS development practices. I've chosen a Clean Architecture approach with MVVM pattern to ensure the codebase remains maintainable, testable, and scalable as the application grows.

The project structure follows a clear separation of concerns:

```
InstagramClone/
├── Domain/           # Business Logic
│   ├── Models
│   ├── Protocols
│   └── UseCases
├── Data/            # Data Layer
│   ├── Repositories
│   └── DataSources
└── Presentation/    # UI Layer
    ├── ViewModels
    └── Views
```

### Key Technical Choices

I've made several deliberate architectural decisions to balance development speed with code quality:

1. **Clean Architecture**

   I implemented Clean Architecture to create a codebase that's both robust and flexible. This approach allows us to change implementation details without affecting business logic. For example, we could easily swap UserDefaults with CoreData without touching the UI layer.

2. **MVVM + SwiftUI**

   SwiftUI's declarative nature pairs perfectly with MVVM. The reactive updates through `@Published` properties ensure our UI stays in sync with the underlying data model, creating a smooth user experience with minimal boilerplate code.

3. **Dependency Injection**

   I chose constructor injection for its explicitness and testability. By making dependencies clear at initialization time, we avoid hidden dependencies and make the code easier to understand and test. Resolver helps manage this process while keeping the code clean.

4. **Repository Pattern**

   The repository pattern provides a clean abstraction over our data sources. This creates a single source of truth for data access and simplifies caching strategies. If we later need to add remote data fetching, the UI layer won't need to change.

5. **Use Cases**

   Instead of putting business logic in ViewModels, I've isolated it in focused Use Cases. Each Use Case does one thing well, making the code more maintainable and easier to test. This approach also makes our business rules explicit rather than buried in UI code.

### Data Flow & Persistence

Data flows unidirectionally through our architecture, making the application behavior predictable and easier to debug:

```mermaid
flowchart LR
    View --> ViewModel --> UseCase --> Repository --> DataSource
```

For persistence, I chose UserDefaults rather than CoreData. This decision was pragmatic - our data model is simple, with no complex relationships. UserDefaults provides a lightweight solution that meets our current needs without over-engineering.

For image handling, Kingfisher offers efficient caching and memory management with minimal setup. Its SwiftUI integration makes it a perfect fit for our application.

## 🧪 Testing Strategy

Our architecture makes testing straightforward. Each component can be tested in isolation with mock dependencies. Here's an example of how we test a Use Case:

```swift
func testLoadInitialStoriesSuccess() async throws {
    // Given
    let mockUsers = [
        User(id: 1, name: "Test", profilePictureUrl: "test-url")
    ]
    mockUserRepository.users = mockUsers

    // When
    let stories = try await sut.execute()

    // Then
    XCTAssertEqual(stories.count, 1)
    XCTAssertEqual(mockUserRepository.getUsersCallCount, 1)
    XCTAssertEqual(mockStoryContentRepository.getContentCallCount, 1)
}
```

This approach allows us to verify business logic without spinning up the entire application, resulting in fast, reliable tests.

## 📱 Results & Reflections

The resulting application delivers a clean, Instagram-like Stories experience with smooth animations and intuitive navigation. The architecture proved valuable during development, allowing me to:

- Make changes confidently without unexpected side effects
- Add new features by extending existing patterns
- Test components in isolation
- Maintain a clear mental model of the application

The separation of concerns paid off particularly when implementing the stories navigation - I could focus on the UI experience while the data management remained stable and predictable.

## Future Improvements

While the current implementation meets the requirements, there are several enhancements I would add given more time:

### UX Enhancements

I would improve the gesture system to make navigation feel more native. Adding swipe gestures between stories would make the experience more fluid, while vertical swipes could provide a quick dismissal option. Double-tapping to like would also make the interaction more intuitive for Instagram users.

### Technical Improvements

The current implementation could be enhanced with better offline support. Implementing a more sophisticated caching strategy would allow users to view previously loaded stories even without an internet connection.

Error handling could also be improved with more graceful fallbacks and user-friendly error messages. Additionally, breaking the application into modules would improve compilation times and enable better code sharing as the application grows.
