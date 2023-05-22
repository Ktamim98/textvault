# SecureNotes App
SecureNotes is an iOS app that allows you to store and protect your confidential notes using biometric authentication or a password. The app utilizes the LocalAuthentication framework to provide a secure and seamless authentication experience. It also leverages the SwiftKeychainWrapper library to securely store and retrieve sensitive information from the device's keychain.

## Overview
The SecureNotes app provides a simple and intuitive interface for managing your secret messages. It ensures that only authorized users can access the protected content by implementing biometric authentication (if available) or a password-based authentication mechanism. The app employs various features and techniques to enhance security and protect your confidential data.

### Key Features:

- Biometric authentication (Touch ID or Face ID) for seamless and secure access to secret messages.
- Password-based authentication as an alternative to biometric authentication.
- Secure storage of secret messages using the iOS keychain.
- Automatic locking and encryption of secret messages when the app is inactive or in the background.
- Adjustable keyboard handling to improve user experience.
### Technology Stack
The SecureNotes app is built using the following tools and technologies:

- Swift: The primary programming language for iOS app development.
- LocalAuthentication Framework: Enables biometric authentication and device owner verification.
- UIKit Framework: Provides a set of user interface components and tools for iOS app development.
- SwiftKeychainWrapper: A third-party library that simplifies working with the iOS keychain for secure data storage.

## Implementation Details
The ViewController class serves as the main controller for the app. It manages the user interface, authentication process, secret message storage, and app locking. Here are some key components and methods:

- viewDidLoad(): Initializes the app's user interface, sets up keyboard notifications, and configures the navigation bar.
- authenticateTapped(_:): Handles the authentication button tap. It first checks if biometric authentication is available and attempts device owner verification. If unavailable or unsuccessful, it prompts the user to enter a password.
- adjustForKeyboard(notification:): Adjusts the content inset of the secret message view when the keyboard appears or hides to ensure proper visibility and scrolling.
- unlockSecretMessage(): Displays the secret message view and loads the previously saved secret message from the keychain.
- saveSecretMessage(): Saves the secret message to the keychain when the app resigns active state.
- lockApp(): Locks the app by hiding the secret message view and disabling the navigation bar button.
- promptForPassword(): Presents an alert for the user to enter the password. It validates the password and unlocks the secret message view if successful.
- checkPassword(_:): Compares the entered password with the saved password in the keychain and returns the authentication result.
- savePassword(_:): Saves the password to the keychain.

## Credit
This project was made as a part of Hacking with Swift course by Paul Hudson.
