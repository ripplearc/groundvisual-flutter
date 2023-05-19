import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

//  TODO: Add your own Google Maps API key to the file ios/Runner/Keys.swift
//  static let googleMapsApiKey = "YOUR_API_KEY"
//  Apply for API key: https://developers.google.com/maps/documentation/embed/get-api-key#create-api-keys
//  Make sure to enable the iOS SDK API for you API key
    GMSServices.provideAPIKey(Keys.googleMapsApiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
