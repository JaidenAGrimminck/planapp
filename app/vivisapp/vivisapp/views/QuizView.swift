//
//  QuizView.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/4/25.
//

import SwiftUI

class QuestionData: ObservableObject {
    @Published var birthDate: Date = Date()
    @Published var usage: Int = 0b0000
}

struct Question1: View {
    @State var qd: QuestionData
    
    var body: some View {
        VStack {
            DatePicker("", selection: $qd.birthDate, displayedComponents: .date).datePickerStyle(GraphicalDatePickerStyle())
        }
    }
}

struct Question2: View {
    @State var qd: QuestionData
    
    @State var b1: Bool = false
    @State var b2: Bool = false
    @State var b3: Bool = false
    @State var b4: Bool = false
    
    var body: some View {
        VStack {
            Button("Date Planning") {
                if !b1 {
                    qd.usage |= 0b0001
                } else {
                    qd.usage &= 0b1110
                }
                
                b1 = !b1
            }
            .frame(width: 342, height: 72)
            .foregroundColor(b1 ? .white : .black)
            .background(b1 ? .black : Color(red: 0.94, green: 0.94, blue: 0.94))
            .cornerRadius(25)
            .font(
                .system(size: 24)
                .weight(.bold)
            )
            
            Button("Personal Use") {
                if !b2 {
                    qd.usage |= 0b0010
                } else {
                    qd.usage &= 0b1101
                }
                
                b2 = !b2
            }
            .frame(width: 342, height: 72)
            .foregroundColor(b2 ? .white : .black)
            .background(b2 ? .black : Color(red: 0.94, green: 0.94, blue: 0.94))
            .cornerRadius(25)
            .font(
                .system(size: 24)
                .weight(.bold)
            )
            
            Button("Social Use") {
                if !b3 {
                    qd.usage |= 0b0100
                } else {
                    qd.usage &= 0b1011
                }
                
                b3 = !b3
            }.frame(width: 342, height: 72)
                .foregroundColor(b3 ? .white : .black)
                .background(b3 ? .black : Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(25)
                .font(
                    .system(size: 24)
                    .weight(.bold)
                )
            
            Button("Vacation Panning") {
                if !b4 {
                    qd.usage |= 0b1000
                } else {
                    qd.usage &= 0b0111
                }
                
                b4 = !b4
            }.frame(width: 342, height: 72)
                .foregroundColor(b4 ? .white : .black)
                .background(b4 ? .black : Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(25)
                .font(
                    .system(size: 24)
                    .weight(.bold)
                )
        }
    }
}

struct Question3: View {
    @State var qd: QuestionData
    
    var sources: [String] = [
        "ur mom",
        "ur dad",
        "67",
        "mango",
        "mustard",
        "reel"
    ]
    
    @State var activeButton: Int? = -1
    
    var body: some View {
        VStack {
            ForEach(Array(sources.enumerated()), id: \.1) { (i, source) in
                Button(source) {
                    if activeButton != i {
                        activeButton = i
                    } else {
                        activeButton = -1
                    }
                }
                .frame(width: 342, height: 72)
                .foregroundColor(activeButton == i ? .white : .black)
                .background(activeButton == i ? .black : Color(red: 0.94, green: 0.94, blue: 0.94))
                .cornerRadius(25)
                .font(
                    .system(size: 24)
                    .weight(.bold)
                )
            }
            
        }
    }
}

struct Question4: View {
    @StateObject private var lm = LocationManager()
    
    var body: some View {
        VStack {
            Rectangle().frame(width: 343, height: 423)
                .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
        }.onAppear {
            lm.requestPermission()
            print("requested location permission")
        }
    }
}

struct Question5: View {
    @StateObject private var nm = NotificationManager()
    
    var body: some View {
        VStack {
            Text("PLEAOISJFOI WE WANT SOME NOTIFFFFS AHAHAH")
        }.onAppear {
            nm.requestPermission()
            print("Requested notifs permission")
        }
    }
}


struct QuizView: View {
    @State private var onQ = 0

    @Environment(\.dismiss) private var dismiss
    
    @State private var birthDate: Date = Date()
    
    // list of views for questions
    var qd: QuestionData = QuestionData()
    
    var body: some View {
        var questions: [(first: String, second: AnyView)] = [
            (first: "When were you born?", second: AnyView(Question1(qd: qd))),
            (first: "What's your main goal in using [us]?", second: AnyView(Question2(qd: qd))),
            (first: "How did you hear about [us]?", second: AnyView(Question3(qd: qd))),
            (first: "To give you the best experience, we’d like access to your location.", second: AnyView(Question4())),
            (first: "Enable notifications so we can keep you updated.", second: AnyView(Question5())),
        ]
        
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                
                Button() {
                    if onQ > 0 {
                        onQ -= 1
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 32, height: 32)
                        .background(Color(red: 0.901, green: 0.901, blue: 0.901))
                        .cornerRadius(10)
                }
                .padding(.bottom, 15)
                
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 350, height: 5)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    
                        .cornerRadius(25)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: Double(onQ) / Double(questions.count) * 350, height: 5)
                        .background(.black)
                        .cornerRadius(25)
                }
                .frame(width: 370, height: 5).padding(.bottom, 10)
                
                Text(questions[onQ].first)
                    .font(
                        .system(size: 30)
                        .weight(.bold)
                    )
                    .foregroundColor(.black)
                    .frame(width: 350, height: onQ < 3 ? 90 : 90 + 30, alignment:.top)
                    .lineLimit(nil)
            }.frame(alignment: .top)
            
            Spacer()
            
            VStack() {
                questions[onQ].second
            }
            
            Spacer()
            
            ZStack {
                if (onQ < questions.count - 1) {
                    // insert button
                    Button("Continue") {
                        onQ += 1
                        
                        if onQ >= questions.count {
                            onQ = questions.count
                        }
                    }
                    .font(
                        .system(size: 17)
                        .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .foregroundColor(.clear)
                    .frame(width: 342, height: 58)
                    .background(.black)
                    .cornerRadius(25)
                } else {
                    NavigationLink(destination: SignupView()) {
                        Text("Continue")
                            .font(
                                .system(size: 17)
                                .weight(.medium)
                            )
                            .foregroundColor(.white)
                            .foregroundColor(.clear)
                            .frame(width: 342, height: 58)
                            .background(.black)
                            .cornerRadius(25)
                    };
                }
            }.frame(alignment: .bottom);
        }
        .padding(.horizontal, 26)
        .padding(.top, 0)
        .padding(.bottom, 20)
        .frame(width: 422, height: 747, alignment: .top)
            
    }
}

#Preview {
    QuizView()
}
