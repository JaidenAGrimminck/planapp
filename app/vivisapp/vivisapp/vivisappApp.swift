//
//  vivisappApp.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/4/25.
//

import SwiftUI

@main
struct vivisappApp: App {
    @State private var loading: Bool = true
    @State private var loggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if loading {
                    LoadingView()
                } else if loggedIn {
                    HomeView()
                } else {
                    GetStartedView()
                }
            }
            .task {
                await checkLoginStatus()
            }
        }
    }
    
    @MainActor
    private func checkLoginStatus() async {
        print("Checking if user is logged in…")

        if !LoginManager.hasSessionCookie() {
            print("No session cookie, skipping login check.")
            loading = false
            return
        }

        do {
            let user = try await LoginManager.fetchCurrentUser()
            if !user.email.isEmpty {
                loggedIn = true
                print("User is logged in! Welcome back, \(user.name).")
            }
        } catch {
            print("User is not logged in: \(error).")
        }

        loading = false
    }
}
