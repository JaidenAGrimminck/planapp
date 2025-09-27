//
//  ResultsLoadingView.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/5/25.
//

import SwiftUI
import UIKit

import Dispatch

struct ResultsLoadingView: View {
    
    @State private var pThrough = 0.0
    @State private var navigateToResults = false
    
    @Environment(\.dismiss) private var dismiss;
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button() {
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        
                        Spacer()
                        
                        Text(Constants.name)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .disabled(true)
                            .opacity(0)
                    }.padding([.leading, .trailing], 20)
                    
                    Spacer()
                    
                    VStack {
                        VStack {
                            Text("Loading...")
                            
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 200, height: 10)
                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                    .cornerRadius(25)
                                
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: pThrough * 200, height: 10)
                                    .background(.black)
                                    .cornerRadius(25)
                            }
                            .frame(width: 200, height: 10).padding(.bottom, 20)
                        }.padding(.bottom, 20)
                        
                        // rectangle image stuff
                        ZStack {
                            // left side rectangle
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 90, height: 90)
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.85, green: 0.85, blue: 0.85), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.05, y: 0),
                                        endPoint: UnitPoint(x: 1.09, y: 1.16)
                                    )
                                )
                                .cornerRadius(20)
                                .offset(x: -75)
                            
                            // right side rectangle
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 90, height: 90)
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.85, green: 0.85, blue: 0.85), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.05, y: 0),
                                        endPoint: UnitPoint(x: 1.09, y: 1.16)
                                    )
                                )
                                .cornerRadius(20)
                                .offset(x: 75)
                            
                            // center rectangle
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 150, height: 150)
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.85, green: 0.85, blue: 0.85), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.05, y: 0),
                                        endPoint: UnitPoint(x: 1.09, y: 1.16)
                                    )
                                )
                                .cornerRadius(20)
                            
                            
                            
                            
                        }.frame(width: 250, height: 150)
                        
                        
                    }
                    
                    Spacer()
                    
                    Button("Cancel") {
                        dismiss()
                    }.font(
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
                    
                }.padding(.top, 20).padding(.bottom, 10)
            }.onAppear {
                for i in 1...100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) / 10) {
                        pThrough = Double(i) / 100
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    navigateToResults = true
                }
            }.navigationDestination(isPresented: $navigateToResults) {
                ResultsView().navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    ResultsLoadingView()
}
