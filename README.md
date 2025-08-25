# ShadyAlert

A SwiftUI package that restores the deprecated `alert(item:)` modifier functionality while avoiding deprecation warnings. ShadyAlert provides a clean, type-safe way to display alerts with custom actions and automatic state management.

## Features

- ✅ Replaces the deprecated `alert(item:)` modifier
- ✅ Type-safe alert actions with protocol-based design
- ✅ Built-in error alert convenience initializer
- ✅ Support for custom alert types (error, info, action alerts)
- ✅ Automatic alert dismissal and state management
- ✅ SwiftUI-native button roles (destructive, cancel, etc.)

## Installation

### Swift Package Manager

Add ShadyAlert to your project through Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/johnshade-himself/ShadyAlert`
3. Select the version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/johnshade-himself/ShadyAlert", from: "1.0.1")
]
```

## Basic Usage

### Simple Error Alert

```swift
import SwiftUI
import ShadyAlert

struct ContentView: View {
    @State private var alertData: ShadyAlert?
    
    var body: some View {
        VStack {
            Button("Show Error") {
                let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Something went wrong!"])
                alertData = ShadyAlert.withError(error)
            }
        }
        .shadyAlert(item: $alertData)
    }
}
```

### Info Alert

```swift
Button("Show Info") {
    alertData = ShadyAlert(
        type: .info,
        title: "Information",
        message: "This is an informational message."
    )
}
```

## Custom Actions

For alerts with custom actions, create an enum that conforms to `ShadyAlertActionProtocol`:

```swift
enum MyAlertAction: ShadyAlertActionProtocol, CaseIterable {
    case cancel
    case delete
    case save
    
    var id: UUID { UUID() }
    
    var title: String {
        switch self {
        case .cancel: return "Cancel"
        case .delete: return "Delete"
        case .save: return "Save"
        }
    }
    
    var role: ButtonRole? {
        switch self {
        case .cancel: return .cancel
        case .delete: return .destructive
        case .save: return nil
        }
    }
}
```

### Using Custom Actions

```swift
struct ContentView: View {
    @State private var alertData: ShadyAlert?
    
    var body: some View {
        VStack {
            Button("Show Action Alert") {
                alertData = ShadyAlert(
                    type: .actionAlert,
                    title: "Confirm Action",
                    message: "Are you sure you want to proceed?",
                    actions: [MyAlertAction.cancel, MyAlertAction.delete, MyAlertAction.save]
                )
            }
        }
        .shadyAlert(item: $alertData, onAction: handleAlertAction)
    }
    
    func handleAlertAction(_ action: any ShadyAlertActionProtocol) {
        if let myAction = action as? MyAlertAction {
            switch myAction {
            case .cancel:
                print("User cancelled")
            case .delete:
                print("Deleting item...")
            case .save:
                print("Saving item...")
            }
        }
    }
}
```

## ViewModel Integration

ShadyAlert works perfectly with MVVM architecture:

```swift
class MyViewModel: ObservableObject {
    @Published var alertData: ShadyAlert?
    
    func showError(_ error: Error) {
        alertData = ShadyAlert.withError(error, title: "Operation Failed")
    }
    
    func handleAlertAction(_ action: any ShadyAlertActionProtocol) {
        guard let myAction = action as? MyAlertAction else { return }
        
        switch myAction {
        case .delete:
            performDeletion()
        case .save:
            performSave()
        case .cancel:
            break
        }
    }
    
    private func performDeletion() {
        // Your deletion logic
    }
    
    private func performSave() {
        // Your save logic
    }
}

struct ContentView: View {
    @StateObject private var viewModel = MyViewModel()
    
    var body: some View {
        // Your UI here
        .shadyAlert(item: $viewModel.alertData, onAction: viewModel.handleAlertAction)
    }
}
```

## API Reference

### ShadyAlert

The main alert data structure:

```swift
public struct ShadyAlert: Identifiable {
    public let id: UUID
    public let type: AlertType
    public let customTitle: String?
    public let message: String?
    public let actions: [any ShadyAlertActionProtocol]
    
    // Convenience initializer for errors
    public static func withError(_ error: any Error, title: String? = nil) -> ShadyAlert
}
```

### AlertType

```swift
public enum AlertType {
    case error    // Default title: "Error"
    case info     // Default title: "Info"  
    case actionAlert // No default title
}
```

### ShadyAlertActionProtocol

Protocol that your custom action enums must conform to:

```swift
public protocol ShadyAlertActionProtocol: Identifiable, Hashable, CaseIterable {
    var id: UUID { get }
    var title: String { get }
    var role: ButtonRole? { get }
}
```

### View Extension

```swift
extension View {
    public func shadyAlert(
        item: Binding<ShadyAlert?>,
        onAction: ((any ShadyAlertActionProtocol) -> Void)? = nil
    ) -> some View
}
```

## Why ShadyAlert?

Apple deprecated the `alert(item:)` modifier in iOS 15, but many developers still need item-based alert presentation for cleaner state management. ShadyAlert brings back this functionality with modern SwiftUI patterns while avoiding deprecation warnings.

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- Swift 5.5+

## License

Apache 2.0 license - see LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
