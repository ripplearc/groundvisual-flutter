import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

// TODO: Create a new file named Keys.swift in the ios/Runner directory of your Flutter project.
//  Add your own Google Maps API key to the file Keys.swift
//  static let googleMapsApiKey = "YOUR_API_KEY"
//  Apply for API key: https://developers.google.com/maps/documentation/embed/get-api-key#create-api-keys
    GMSServices.provideAPIKey(Keys.googleMapsApiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
