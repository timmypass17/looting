//
//  AppDelegate.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import FirebaseMessaging
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { auth, user in
            // Triggered when added and user logs in or out
            if let user {
                print("[AppDelegate] User: \(user.displayName)")
            } else {
                print("[AppDelegate] User is not logged in")
            }
        }
        
        // To receive registration tokens via method messaging:didReceiveRegistrationToken:
        //  - call after FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self

        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                print("Error requesting notifcations: \(error)")
            }
        }

        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handles the URL that your application receives at the end of the authentication process
        return GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

extension AppDelegate: MessagingDelegate {
    // The FCM SDK retrieves a new or existing token during initial app launch and whenever the token is updated or invalidated.
    //  - To send a message to a specific device, you need to know that device's registration token
    // The registration token may change when:
    //  - The app is restored on a new device
    //  - The user uninstalls/reinstall the app
    //  - The user clears app data.
    // In all cases, the FCM SDK calls messaging:didReceiveRegistrationToken: with a valid token.
    // Ideal time to
    //  - If the registration token is new, send it to your application server.
    // - Subscribe the registration token to topics. This is required only for new subscriptions or for situations where the user has re-installed the app.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )

        // If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
//        let tokenStored = Settings.shared.deviceToken
//        if tokenStored.isEmpty || tokenStored != fcmToken {
            Task {
                await sendTokenToServer(fcmToken)
            }
//        }
    }
    
    private func sendTokenToServer(_ token: String) async {
        guard let user = Auth.auth().currentUser else { return }
            
        // Add token and timestamp to Firestore for this user
        let deviceToken = [
            "token": token,
            "timestamp": FirebaseFirestore.Timestamp(), // indicate wheter user is active
        ] as [String : Any]
        
        // Get user ID from Firebase Auth or your own server
        
        do {
            let db = Firestore.firestore()
            try await db.collection("fcmTokens")
                .document(user.uid)
                .setData(deviceToken)
            Settings.shared.deviceToken = token
        } catch {
            print("Error sending token to firestore: \(error)")
        }
    }
}


// Normal messaging to multiple devices
// -
// Send message to topics
// - users subscribe to a topic (e.g. "elden ring"). "Elden Ring is on sale for %29.99 (-50%)!"
// - maybe i could let users set notifications for specific games
