//
//  LoginView.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/4/25.
//

import SwiftUI
import Foundation


struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var errorResponse: String = ""
    
    @State private var awaitingLoginReq: Bool = false
    
    @FocusState private var isUsernameFocused: Bool
    
    @FocusState private var isPasswordFocused: Bool
    
    @State private var loginSuccessful: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center, spacing: 21) {
                    Text("Log In").font(.system(size: 20)).bold()
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        
                        if errorResponse.isEmpty == false {
                            Text(errorResponse)
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                                .padding(.bottom, 10)
                        }
                        
                        VStack {
                            Text("Username")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(width: 370, height: 21, alignment: .topLeading)
                            
                            HStack(alignment: .center, spacing: 0) {
                                TextField("Enter username", text: $username)
                                    .focused($isUsernameFocused)
                                    .onSubmit {
                                        
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .textContentType(.username)
                                    .disabled(awaitingLoginReq)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 0)
                            .frame(width: 367, height: 36, alignment: .leading)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
                            )
                        }
                        
                        .padding(.bottom, 16)
                        
                        VStack {
                            Text("Password")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(width: 370, height: 21, alignment: .topLeading)
                            
                            
                            HStack(alignment: .center, spacing: 0) {
                                SecureField("Enter password", text: $password)
                                    .focused($isPasswordFocused)
                                    .onSubmit {
                                        
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .privacySensitive(true)
                                    .textContentType(.password)
                                    .disabled(username.isEmpty || awaitingLoginReq)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 0)
                            .frame(width: 367, height: 36, alignment: .leading)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
                            )
                        }
                    }
                    
                    Spacer()
                    
                    Button("Submit") {
                        Task {
                            print("Logging in...")
                            
                            awaitingLoginReq = true
                            
                            do {
                                let msg = try await LoginManager.login(email: username, password: password)
                                
                                print(msg)
                            } catch let authError as AuthError {
#if DEBUG
                                print("Login failed,", authError.localizedDescription)
#endif
                                
                                errorResponse = "Error: " + (authError.readableDescription ?? "An error occurred")
                            }
                            
                            awaitingLoginReq = false
                        }
                    }.font(
                        .system(size: 17)
                        .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 342, height: 58, alignment: .center)
                    .background(Color.black)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 0)
                .padding(.top, 15.5)
                .padding(.bottom, 92.5)
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }.navigationDestination(isPresented: $loginSuccessful) {
            HomeView().navigationBarBackButtonHidden(true)
        }
    }
}

struct SignupView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    
    @State private var errorResponse: String = ""
    
    @State private var awaitingSignupReq: Bool = false
    
    @State private var signupSuccessful: Bool = false
    
    @FocusState private var isUsernameFocused: Bool
    
    @FocusState private var isPasswordFocused: Bool
    
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center, spacing: 21) {
                    Text("Sign Up").font(.system(size: 20)).bold()
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        if errorResponse.isEmpty == false {
                            Text(errorResponse)
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                                .padding(.bottom, 10)
                        }
                        
                        VStack {
                            Text("Name")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(width: 370, height: 21, alignment: .topLeading)
                            
                            
                            HStack(alignment: .center, spacing: 0) {
                                TextField("Enter your name", text: $name)
                                    .focused($isNameFocused)
                                    .onSubmit {
                                        
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .privacySensitive(true)
                                    .textContentType(.namePrefix)
                                    .disabled(awaitingSignupReq)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 0)
                            .frame(width: 367, height: 36, alignment: .leading)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
                            )
                        }
                        
                        .padding(.bottom, 16)
                        
                        VStack {
                            Text("Email")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(width: 370, height: 21, alignment: .topLeading)
                            
                            HStack(alignment: .center, spacing: 0) {
                                TextField("Enter your email", text: $username)
                                    .focused($isUsernameFocused)
                                    .onSubmit {
                                        
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .textContentType(.emailAddress)
                                    .disabled(awaitingSignupReq)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 0)
                            .frame(width: 367, height: 36, alignment: .leading)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
                            )
                        }
                        
                        .padding(.bottom, 16)
                        
                        VStack {
                            Text("Password")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(width: 370, height: 21, alignment: .topLeading)
                            
                            
                            HStack(alignment: .center, spacing: 0) {
                                SecureField("Enter password", text: $password)
                                    .focused($isPasswordFocused)
                                    .onSubmit {
                                        
                                    }
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .privacySensitive(true)
                                    .textContentType(.newPassword)
                                    .disabled(awaitingSignupReq)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 0)
                            .frame(width: 367, height: 36, alignment: .leading)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
                            )
                        }
                    }
                    
                    Spacer()
                    
                    Button("Submit") {
                        Task {
                            print("Signing up...")
                            
                            awaitingSignupReq = true
                            
                            do {
                                let msg = try await LoginManager.signup(name: name, email: username, password: password)
                                
#if DEBUG
                                print(msg)
#endif
                                
                                signupSuccessful = true
                            } catch let authError as AuthError {
#if DEBUG
                                print("Login failed,", authError.localizedDescription)
#endif
                                
                                errorResponse = "Error: " + (authError.readableDescription ?? "An error occurred")
                            }
                            
                            awaitingSignupReq = false
                        }
                    }.font(
                        .system(size: 17)
                        .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 342, height: 58, alignment: .center)
                    .background(Color.black)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 0)
                .padding(.top, 15.5)
                .padding(.bottom, 92.5)
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }.navigationDestination(isPresented: $signupSuccessful) {
            HomeView().navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    SignupView()
}
