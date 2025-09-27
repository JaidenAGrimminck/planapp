//
//  ContentView.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/4/25.
//

import SwiftUI

struct GetStartedView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Rectangle().frame(
                    height: 620,
                    alignment: .top
                )
                
                Spacer()
                
                VStack(alignment: .center, spacing: 26) {
                    Text("[] Planning made easy.")
                        .font(
                            .system(size: 36)
                            .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 259, height: 86, alignment: .top)
                    
                    NavigationLink(destination: QuizView().navigationBarBackButtonHidden(true)) {
                        Text("Get Started")
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: 342, height: 58, alignment: .center)
                            .background(Color.black)
                            .cornerRadius(25)
                    }
                    
                    HStack {
                        Text("Already have an account?").font(.system(size: 16))
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Sign In").font(.system(size: 16)).foregroundColor(.black).fontWeight(.heavy)
                        }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.top, 20)
                .padding(.bottom, 100)
                .frame(width: 422, alignment: .bottom)
            }
        }
    }
}

#Preview {
    GetStartedView()
}
