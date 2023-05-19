# groundvisual_flutter

Ground Visual (Flutter) is the cross platform frontend solution for iOS/Android/Web.
It allows the user to check the latest or the trend happening on the construction site,
look up the fleet information, search the document and update the account.

## Getting Started

Generate files from build_runner
```shell
flutter pub get; \
flutter pub run build_runner build --delete-conflicting-outputs
```

Gogole Map API key is senstiive information and should not be committed to the repository.
```shell
git update-index --skip-worktree android/keys.properties ios/Runner/Keys.swift web/.env
```

### Build Android App

1. Replace the Google Map API key in `keys.properties` in the `android` directory
```
google_maps_api_key=YOUR_API_KEY
```

2. Build and Install
```shell    
flutter build apk --release; \
flutter install
```

### Build iOS App

1. Replace the Google Map API key in `Keys.swift` in the `ios/Runner` directory
```swift
struct Keys {
    static let googleMapsApiKey = "YOUR_API_KEY"
}
```

2. Run the app
```shell
flutter run
```

### Build Web App

1. Replace the Google Map API key in `.env` in the `web` directory
```
GOOGLE_MAPS_API_KEY=YOUR_API_KEY
```

and then run `build.dart` to update the API key in the `index.html`
```shell
dart build.dart
```

2. Build and launch the web in release mode
```shell
flutter run -d chrome --release
```