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
### Build Android App

1. Replace the Google Map API key in `keys.properties` (create one in the `android` directory)
```
google_maps_api_key=YOUR_API_KEY
```

2. Build and Install
```shell    
flutter build apk --release; \
flutter install
```

### Build iOS App

1. Replace the Google Map API key in `Keys.swift` (create one in the `ios/Runner` directory)
```swift
struct Keys {
    static let googleMapsApiKey = "YOUR_API_KEY"
}
```

2. Add the Keys.swift file to the Runner target

In Xcode, navigate to the Runner project in the Project Navigator.
Right-click on the Runner folder and select "Add Files to 'Runner'..."
Locate and select the Keys.swift file from your project directory and click "Add".

3. Run the app
```shell
flutter run
```

### Build Web App

1. Replace the Google Map API key in `.env` in the `web` directory
```shell
GOOGLE_MAPS_API_KEY=YOUR_API_KEY
```

and then run 
```shell
dart build.dart
```

2. Build and launch the web in release mode
```shell
flutter run -d chrome --release
```