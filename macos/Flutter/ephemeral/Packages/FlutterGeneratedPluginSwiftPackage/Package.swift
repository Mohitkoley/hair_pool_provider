// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "connectivity_plus", path: "/Users/mohit/.pub-cache/hosted/pub.dev/connectivity_plus-6.1.2/darwin/connectivity_plus"),
        .package(name: "file_selector_macos", path: "/Users/mohit/.pub-cache/hosted/pub.dev/file_selector_macos-0.9.4+2/macos/file_selector_macos"),
        .package(name: "firebase_auth", path: "/Users/mohit/.pub-cache/hosted/pub.dev/firebase_auth-5.4.1/macos/firebase_auth"),
        .package(name: "firebase_core", path: "/Users/mohit/.pub-cache/hosted/pub.dev/firebase_core-3.10.1/macos/firebase_core"),
        .package(name: "firebase_crashlytics", path: "/Users/mohit/.pub-cache/hosted/pub.dev/firebase_crashlytics-4.3.1/macos/firebase_crashlytics"),
        .package(name: "firebase_messaging", path: "/Users/mohit/.pub-cache/hosted/pub.dev/firebase_messaging-15.2.1/macos/firebase_messaging"),
        .package(name: "package_info_plus", path: "/Users/mohit/.pub-cache/hosted/pub.dev/package_info_plus-8.1.3/macos/package_info_plus"),
        .package(name: "path_provider_foundation", path: "/Users/mohit/.pub-cache/hosted/pub.dev/path_provider_foundation-2.4.1/darwin/path_provider_foundation"),
        .package(name: "shared_preferences_foundation", path: "/Users/mohit/.pub-cache/hosted/pub.dev/shared_preferences_foundation-2.5.4/darwin/shared_preferences_foundation"),
        .package(name: "sqflite_darwin", path: "/Users/mohit/.pub-cache/hosted/pub.dev/sqflite_darwin-2.4.1+1/darwin/sqflite_darwin"),
        .package(name: "url_launcher_macos", path: "/Users/mohit/.pub-cache/hosted/pub.dev/url_launcher_macos-3.2.2/macos/url_launcher_macos"),
        .package(name: "video_player_avfoundation", path: "/Users/mohit/.pub-cache/hosted/pub.dev/video_player_avfoundation-2.6.7/darwin/video_player_avfoundation")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "file-selector-macos", package: "file_selector_macos"),
                .product(name: "firebase-auth", package: "firebase_auth"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-crashlytics", package: "firebase_crashlytics"),
                .product(name: "firebase-messaging", package: "firebase_messaging"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "url-launcher-macos", package: "url_launcher_macos"),
                .product(name: "video-player-avfoundation", package: "video_player_avfoundation")
            ]
        )
    ]
)
