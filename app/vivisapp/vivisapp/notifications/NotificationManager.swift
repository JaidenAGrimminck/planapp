//
//  NotificationManager.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/6/25.
//

import Foundation
import UserNotifications
import SwiftUI

final class NotificationManager: ObservableObject {
    /// Call this to show the system “Allow Notifications” prompt
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error:", error)
                return
            }
            if granted {
                print("Notifications permission granted")
                // If you want **remote** push notifications, register with APNs:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notifications permission denied")
            }
        }
    }
}
