//
//  ResultsView.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/5/25.
//

import SwiftUI
import UIKit

struct ResultsView: View {
    @State private var title: String = "Visit the SF Moma"
    @State private var subtitle: String = "Explore world-class modern art together, discovering new favorites along the way."
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            //underlay
            Image("StockImages")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                
            // gradient
                .overlay(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0.7), location: 0.0),
                            .init(color: Color.clear,               location: 0.2),
                            .init(color: Color.clear,               location: 0.8),
                            .init(color: Color.black.opacity(0.7), location: 1.0),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            
            // overlay
            VStack(alignment: .center) {
                
                // top with the title & button
                VStack(alignment: .leading) {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 32, height: 32)
                            .background(Color(red: 0.901, green: 0.901, blue: 0.901))
                            .cornerRadius(10)
                    }.padding(.bottom, 10).padding(.leading, 5)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(
                                .system(size: 20)
                                .weight(.semibold)
                            )
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 72, maxHeight: 72, alignment: .topLeading)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 0)
                    .frame(width: 371, alignment: .topLeading)
                }.padding(.top, 5)
                
                Spacer()
                
                //bottom stack
                VStack {
                    HStack(spacing: 14) {
                        Button("Regenerate") {}
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(25)
                        
                        Button("Edit") {}
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(25)
                        
                        Button("Accept") {}
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(25)
                        
                    }
                    .padding(.horizontal, 17)
                    .padding(.vertical, 0)
                }
            }
        }
    }
}

#Preview {
    ResultsView()
}
