//
//  HomeView.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/5/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                HomePageView()
            }
        }
    }
}

struct HomePageView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("hello! u r logged in")
                
                Text("Username: " + AppUser.currentUser.email)
                Text("Name: " + AppUser.currentUser.name)
                
                NavigationLink(destination: BetterGenerationView().navigationBarBackButtonHidden(true)) {
                    Text("test???")
                }
                
                
                Button("Sign Out") {
                    Task {
                        do {
                            let msg = try await LoginManager.logout()
                            print("Logged out! ", msg)
                        } catch let error as AuthError {
                            print("error logging out??", error.localizedDescription)
                        }
                    }
                }.padding(.top, 50)
            }
        }
    }
}

struct MenuBar : View {
    var body : some View {
        HStack {
            Button() {
                
            } label : {
                Image(systemName: "house.fill")
                    .imageScale(.large)
            }.foregroundStyle(.black);
            
            Spacer()
            
            Button() {
                
            } label : {
                Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath")
                    .imageScale(.large)
            }.foregroundStyle(.black);
            
            Spacer()
            
            Button() {
                
            } label : {
                Image(systemName: "map.fill")
                    .imageScale(.large)
            }.foregroundStyle(.black);
            
            Spacer()
            
            Button() {
                
            } label : {
                Image(systemName: "person.fill") // slightly bigger
                    .imageScale(.large)
            }.foregroundStyle(.black);
        }.padding(.horizontal, 40).padding(.bottom, 10).padding(.top, 20).background(Color(red: 0.94, green: 0.94, blue: 0.94))
    }
}

struct TopBar : View {
    var body : some View {
        HStack {
            Text(Constants.name).font(.title).bold()
            
            Spacer()
            
            HStack(alignment: .center) {
                Text("Profile").font(.body)
                Circle().frame(width: 35, height: 35).foregroundStyle(.gray)
            }
        }.padding(.horizontal, 20)
    }
}

struct SuggestionPreview : View {
    var body : some View {
        VStack {
            Text("Suggestions")
                .font(.system(size: 20).weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
            
            HStack {
                Rectangle().frame(width: 100, height: 100)
                Spacer()
                Rectangle().frame(width: 100, height: 100)
                Spacer()
                Rectangle().frame(width: 100, height: 100)
            }.frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 20)
                .padding(.top, 5)
        }.padding(.top, 20)
    }
}

struct PlanPreview : View {
    var name : String;
    var date : Date;
    
    let dateText : String = "";
    
    
    var body : some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                    // check if today or tomorrow
                    if Calendar.current.isDateInToday(date) {
                        Text("Today at " + date.formatted(date: .omitted, time: .shortened))
                    } else if Calendar.current.isDateInTomorrow(date) {
                        Text("Tomorrow at " + date.formatted(date: .omitted, time: .shortened))
                    } else {
                        Text(date, style: .date)
                    }
                }
                
                Spacer()
                
                Button() {
                    
                } label: {
                    Text("Edit").padding(.vertical, 5).padding(.horizontal, 15)
                }.font(.system(size: 17).weight(.medium))
                    .foregroundStyle(.black)
                    .background(Color.white)
                    .cornerRadius(25)
                    
            }.padding(.vertical, 10)
            .padding(.horizontal, 15)
        }.background(.black)
            .cornerRadius(12)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .foregroundStyle(.white)
    }
}

struct UpcomingPlansPreview : View {
    var numOfPlans : Int = 0;
    var body : some View {
        VStack {
            Text("Upcoming Plans")
                .font(.system(size: 20).weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
            
            VStack {
                if numOfPlans == 0 {
                    HStack {
                        Text("No Upcoming Plans!").padding(.vertical, 10)
                        NavigationLink("Create one", destination: BetterGenerationView().navigationBarBackButtonHidden(true))
                    }
                } else {
                    
                }
                //PlanPreview(name: "Sample Plan", date: Date())
            }
        }.padding(.vertical, 10)
    }
}

struct ModernHomeView : View {
    
    var body : some View {
        NavigationView {
            VStack {
                TopBar()
                
                // plan your next adventure section
                ZStack {
                    Image("StockImage2").resizable().scaledToFill()
                    
                    // align to left
                    VStack {
                        Text("Plan your next adventure")
                            .font(.system(size: 28).weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 282, height: 86)
                        
                        NavigationLink("Get Started", destination: BetterGenerationView().navigationBarBackButtonHidden(true))
                            .font(.system(size: 17).weight(.medium))
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 50)
                            .background(Color.black)
                            .cornerRadius(35)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.frame(width: 403, height: 254)
                
                SuggestionPreview()
                
                UpcomingPlansPreview()
                
                Spacer()
                
                MenuBar()
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear() {
                // run async method
                Task {
                    try await LoginManager.refreshUser()
                }
            }
    }
}

#Preview {
    ModernHomeView()
}
