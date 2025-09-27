//
//  User.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/5/25.
//
import SwiftUI
import Foundation
import Combine

class AppUser: ObservableObject {
    static var currentUser: AppUser = AppUser(name: "", email: "")
    static var hasUser: Bool {
        currentUser.name.isEmpty == false
    }
    
    public static func updateUser(user: User) {
        let nu = AppUser(name: user.name, email: user.email)
        
        currentUser = nu
    }
    
    @Published var name: String = ""
    @Published var email: String = ""
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
