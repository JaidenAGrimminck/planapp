//
//  LoginManager.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/5/25.
//

import Foundation
import SwiftUI

public struct User: Decodable {
    let id: Int
    let email: String
    let name: String
}

public struct LoginResponse: Decodable {
    let message: String
}

public struct SignupResponse: Decodable {
    let message: String
}

public struct SignoutResponse: Decodable {
    let message: String
}

public enum AuthError: LocalizedError {
    case invalidCredentials(String)
    case serverError(String)
    case unexpectedResponse
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials(let msg): return msg
        case .serverError(let msg):       return msg
        case .unexpectedResponse:         return "Unexpected server response."
        }
    }
    
    public var readableDescription: String? {
        switch self {
        case .invalidCredentials(_): return "Invalid username or password"
        case .serverError(_): return "Something went wrong"
        case .unexpectedResponse: return "Something went wrong"
        }
    }
}


public class LoginManager {
    
    static public func login(email: String, password: String) async throws -> String {
        
        guard let url = URL(string: Constants.api_url + "users/login") else {
            throw AuthError.serverError("Invalid login URL.")
        }
                
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["email": email, "pwd": password]
        req.httpBody = try JSONEncoder().encode(payload)
    
        req.timeoutInterval = 5000
        
#if DEBUG
        print("Send request...")
#endif
        
        let (data, response) = try await URLSession.shared.data(for: req)
                
        //debug
#if DEBUG
        print("Login response: \(String(data: data, encoding: .utf8) ?? "(unreadable)")")
#endif
        
        print("a")
        
        guard let http = response as? HTTPURLResponse else {
            throw AuthError.unexpectedResponse
        }
        
        let decoder = JSONDecoder()
        if http.statusCode == 200 || http.statusCode == 201 {
            let result = try decoder.decode(LoginResponse.self, from: data)
            
            return result.message
        } else if http.statusCode == 401 || http.statusCode == 400 || http.statusCode == 409 {
            let errDict = try decoder.decode([String:String].self, from: data)
            throw AuthError.invalidCredentials(errDict["error"] ?? "Authentication failed.")
        } else {
            let errText = String(data: data, encoding: .utf8) ?? "No details"
            throw AuthError.serverError("Server error (\(http.statusCode)): \(errText)")
        }
        
    }
    
    public static func hasSessionCookie() -> Bool {
        guard let url = URL(string: Constants.api_url) else {
            return false
        }
        
        let cookies = HTTPCookieStorage.shared.cookies(for: url) ?? []
        return cookies.contains { $0.name == "sessionId" }
    }
    
    public static func refreshUser() async throws {
        let _ = try await fetchCurrentUser()
    }


    public static func fetchCurrentUser() async throws -> User {
        guard let url = URL(string: Constants.api_url + "users/me") else {
            throw AuthError.serverError("Bad URL")
        }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse else {
            throw AuthError.unexpectedResponse
        }

        let decoder = JSONDecoder()
        if http.statusCode == 200 {
            let nu: User = try decoder.decode(User.self, from: data)
            
            AppUser.updateUser(user: nu)
            
            return nu
        } else {
            // clear cookies
            let _ = HTTPCookie.self
            let cookieJar = HTTPCookieStorage.shared

            for cookie in cookieJar.cookies! {
                cookieJar.deleteCookie(cookie)
            }
            
            print("Cleared cookies due to invalid log in credentials / session.")
            
            throw AuthError.invalidCredentials("Please log in")
        }
    }
    
    static public func signup(name: String, email: String, password: String) async throws -> String {
        guard let url = URL(string: Constants.api_url + "users/signup") else {
            throw AuthError.serverError("Invalid signup URL.")
        }
                
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["email": email, "pwd": password, "name": name]
        req.httpBody = try JSONEncoder().encode(payload)
    
        req.timeoutInterval = 5000
        
#if DEBUG
        print("Sending request...")
#endif
        
        let (data, response) = try await URLSession.shared.data(for: req)
                
        //debug
#if DEBUG
        print("Signup response: \(String(data: data, encoding: .utf8) ?? "(unreadable)")")
#endif
                
        guard let http = response as? HTTPURLResponse else {
            throw AuthError.unexpectedResponse
        }
        
        let decoder = JSONDecoder()
        if http.statusCode == 200 || http.statusCode == 201 {
            let result = try decoder.decode(SignupResponse.self, from: data)
            
            return result.message
        } else if http.statusCode == 401 || http.statusCode == 400 || http.statusCode == 409 {
            let errDict = try decoder.decode([String:String].self, from: data)
            throw AuthError.invalidCredentials(errDict["error"] ?? "Authentication failed.")
        } else {
            let errText = String(data: data, encoding: .utf8) ?? "No details"
            throw AuthError.serverError("Server error (\(http.statusCode)): \(errText)")
        }
         
    }
    
    public static func logout() async throws -> String {
        guard let url = URL(string: Constants.api_url + "users/logout") else {
            throw AuthError.serverError("Invalid signup URL.")
        }
                
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        req.timeoutInterval = 5000
        
        let (data, response) = try await URLSession.shared.data(for: req)

        #if DEBUG
print("User has logged out!")
        #endif
        
        guard let http = response as? HTTPURLResponse else {
            throw AuthError.unexpectedResponse
        }
        
        let decoder = JSONDecoder()
        if http.statusCode == 200 || http.statusCode == 201 {
            let result = try decoder.decode(SignoutResponse.self, from: data)
            
            return result.message
        } else if http.statusCode == 401 || http.statusCode == 400 || http.statusCode == 409 {
            let errDict = try decoder.decode([String:String].self, from: data)
            throw AuthError.invalidCredentials(errDict["error"] ?? "Authentication failed.")
        } else {
            let errText = String(data: data, encoding: .utf8) ?? "No details"
            throw AuthError.serverError("Server error (\(http.statusCode)): \(errText)")
        }
    }
    
}
