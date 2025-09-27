//
//  GenerationView.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/6/25.
//

import SwiftUI
import MapKit

enum TransportMethods {
    case WALKING, BIKING, DRIVING;
    
    static var allCases : [TransportMethods] {
        [.WALKING, .BIKING, .DRIVING]
    }
}

enum Intensity {
    case LOW, MODERATE, HIGH;
}

enum Budget {
    case ZERO, LOW, MODERATE, HIGH, VERYHIGH;
}

struct GenerationView: View {
    @State var preferences: String = ""
    @State var dateTime: Date = Date()
    
    @State var navigateToGeneration = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack() {
                    
                    VStack {
                        Button() {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }.padding(.bottom, 20)
                    }.frame(width: UIScreen.main.bounds.width - 40, alignment: .leading)
                    
                    
                    
                    VStack {
                        
                        // preferences
                        VStack(alignment: .leading) {
                            Text("Tell us about you!")
                                .font(
                                    .system(size: 22)
                                    .weight(.semibold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                            Text("Interests, preferences, likes, dislikes—anything that helps us get to know you better.")
                                .font(Font.custom("SF Pro", size: 15))
                                .foregroundColor(.black)
                                .frame(width: 370, height: 36, alignment: .topLeading)
                            
                            HStack(alignment: .top, spacing: 0) {
                                TextField("Enter", text: $preferences)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 0)
                            .frame(width: 367, height: 63, alignment: .leading)
                            .cornerRadius(10)
                            .overlay(
                              RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
                            )
                        }
                        
                        // name
                        VStack(alignment: .leading) {
                            Text("Name")
                                .font(
                                    .system(size: 22)
                                    .weight(.semibold)
                                )
                                .foregroundColor(.black)
                            
                            HStack(alignment: .center, spacing: 0) {
                                TextField("Enter", text: $preferences)
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
                        }.padding(.top, 10)
                        
                        // Location
                        VStack(alignment: .leading) {
                            Text("Location")
                                .font(
                                    .system(size: 22)
                                    .weight(.semibold)
                                )
                                .foregroundColor(.black)
                            
                            HStack(alignment: .center, spacing: 0) {
                                TextField("Enter", text: $preferences)
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
                        }.padding(.top, 10)
                        
                        // Time
                        VStack(alignment: .leading) {
                            Text("Date & Time")
                                .font(
                                    .system(size: 22)
                                    .weight(.semibold)
                                )
                                .foregroundColor(.black)
                            
                            HStack() {
                                DatePicker("", selection: $dateTime)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 0)
                            .frame(width: 367, height: 36, alignment: .topLeading)
                            .cornerRadius(10)
                        }.padding(.top, 10)
                        
                        // Location
                        VStack(alignment: .leading) {
                            Text("Budget")
                                .font(
                                    .system(size: 22)
                                    .weight(.semibold)
                                )
                                .foregroundColor(.black)
                            
                            HStack(alignment: .center, spacing: 0) {
                                TextField("Enter", text: $preferences)
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
                        }.padding(.top, 10)
                        
                    }
                    
                    Spacer()
                    
                    Button("generate!") {
                        navigateToGeneration = true
                    }
                    
                    
                }.padding(.top, 20).padding(.bottom, 30)
                
            }.navigationDestination(isPresented: $navigateToGeneration) {
                LoadingView().navigationBarBackButtonHidden(true)
            }
        }
    }
}


struct LocationInput: View {
    @Binding var text: String
    var onTapped: () -> Void
    
    @FocusState var isEditing : Bool

    var body: some View {
        HStack {
            Image("LocIcon")
              .frame(width: 24, height: 24)
            
            VStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Location")
                        .padding(.horizontal, 8)
                        .contentShape(Rectangle())
                        .focused($isEditing)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(text)
                        .padding(.horizontal, 8)
                        .contentShape(Rectangle())
                        .focused($isEditing)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(width: 329, height: 34)
            .background(Color(red: 0.94, green: 0.94, blue: 0.94))
            .cornerRadius(6)
            .onTapGesture { onTapped() }
            //.border(Color(red: 0.94, green: 0.94, blue: 0.94), width: 1)
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct GenerationSettings: View {
    @State var innerStops: Int = 3
    @State private var selectedDate = Date()
    
    // Text for each location row you have
    @Binding var locations: [String]

    // Sheet state
    @Binding var showSuggestionSheet : Bool
    @Binding var activeFieldIndex: Int?
    
    @Binding var intermediateStops: Int
    
    var body: some View {
        VStack {
            // location view
            ZStack {
                Line().stroke(style: .init(dash: [2]))
                    .foregroundStyle(.black)
                    .frame(width: 70, height: 1).rotationEffect(Angle(degrees: 90)).offset(CGSize(width: -168.5, height: 0))
                Line().stroke(style: .init(dash: [2]))
                    .foregroundStyle(.black)
                    .frame(width: 70, height: 1).rotationEffect(Angle(degrees: 90)).offset(CGSize(width: -169.5, height: 0))
                
                VStack {
                    // Location 0
                    LocationInput(
                        text: $locations[0],
                        onTapped: { activeFieldIndex = 0; showSuggestionSheet = true; }
                    ).padding(.top, 8)
                    
                    // Location 1
                    LocationInput(
                        text: $locations[1],
                        onTapped: { activeFieldIndex = 1; showSuggestionSheet = true; }
                    )
                    
                    HStack {
                        // add button
                        ZStack {
                            Button("+") {
                                
                            }
                                .frame(width: 24, height: 24)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .cornerRadius(5)
                                .font(
                                    .system(size: 15)
                                    .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                        }.padding(.leading, 10)
                        
                        Spacer()
                        
                        HStack() {
                            Rectangle().opacity(0).frame(width: 7, height: 0)
                            
                            // counter up down
                            HStack {
                                Button() {
                                    intermediateStops -= 1
                                    
                                    if (intermediateStops < 1) {
                                        intermediateStops = 1
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .imageScale(Image.Scale.small)
                                }
                                .padding(.leading, 5)
                                .disabled(intermediateStops == 1)
                                .frame(width: 18, height: 34)
                                
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 25, height: 34)
                                        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    
                                    Text(String(intermediateStops))
                                }
                                .frame(width: 20, height: 34)
                                
                                Button() {
                                    intermediateStops += 1
                                    
                                    if (intermediateStops > 9) {
                                        intermediateStops = 9
                                    }
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .imageScale(Image.Scale.small)
                                        
                                }
                                .padding(.trailing, 5)
                                .disabled(intermediateStops == 9)
                                .frame(width: 18, height: 34)
                                
                            }.background(Color(red: 0.94, green: 0.94, blue: 0.94))
                            .padding(.trailing, 2)
                            .cornerRadius(9)
                            
                            
                            
                            DatePicker(
                                "",
                                selection: $selectedDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            
                        }.padding(.trailing, 10)
                    }.padding(.bottom, 4)
                }
                
                
            }.frame(width: 382, height: 136)
                .background(.white)
                .cornerRadius(10)
        }
        

    }
}

struct BottomGenerationView : View {
    @Binding var navigateToGenerate : Bool
        
    @Binding var openAdvancedOptions : Bool
    
    @State var budget : Int = 0
    

    
    var body : some View {
        VStack {
            
            HStack {
                Button () {
                    openAdvancedOptions = true
                } label: {
                    HStack {
                        Image(systemName: "ellipsis")
                        
                        Text("Advanced").font(
                            .system(size: 15)
                        ).foregroundStyle(.secondary)
                    }.padding(.horizontal, 10).padding(.vertical, 5)
                }
                    .foregroundColor(.secondary)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(10)
                    .padding(.leading, 10)
                
                Spacer()
                    
            }.padding(.top, 10).padding(.bottom, 5)
            
            Spacer()
            
            HStack {
                // Generate Button
                Button () {
                    navigateToGenerate = true
                } label: {
                    Text("Generate")
                }.font(
                    .system(size: 17)
                    .weight(.medium)
                )
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 155, height: 38, alignment: .center)
                .background(Color.black)
                .cornerRadius(25)
            }
            
        }.frame(width: UIScreen.main.bounds.width, height: 175)
            .background(.white)
    }
}

struct AdvancedOptions : View {
    @Binding var showAdvancedOptions : Bool
    
    @Binding var transit : TransportMethods
    
    @Binding var usePublicTransit : Bool
    
    @State var displayPublicTransit : Bool = true
    
    @Binding var flexibility : Float
    
    @Binding var intensity : Intensity
    
    @Binding var accessible : Bool
    
    @Binding var budget : Budget

    
    var body : some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Button() {
                        showAdvancedOptions = false
                    } label: {
                        Image(systemName: "chevron.left").frame(width: 32, height: 32)
                            .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                            .cornerRadius(6)
                    }.padding(.bottom, 10)
                    Spacer()
                }.padding(.leading, 20)

                
                Text("Advanced Options")
                    .font(
                        .system(size: 20, weight: .medium)
                    ).padding(.bottom, 10)
                
                VStack(alignment: .leading) {
                    Text("Transportation Method").frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("", selection: $transit) {
                        Text("Walking").tag(TransportMethods.WALKING)
                        Text("Biking").tag(TransportMethods.BIKING)
                        Text("Driving").tag(TransportMethods.DRIVING)
                    }.pickerStyle(SegmentedPickerStyle()).onChange(of: transit) {
                        if (transit == TransportMethods.DRIVING) {
                            displayPublicTransit = false
                        } else {
                            displayPublicTransit = usePublicTransit
                        }
                    }
                    
                    Toggle(isOn: $displayPublicTransit) {
                        Text("Use Public Transit")
                    }.padding(.top, 20).onChange(of: displayPublicTransit) {
                        if (transit != TransportMethods.DRIVING) {
                            usePublicTransit = displayPublicTransit
                        }
                    }.disabled(transit == TransportMethods.DRIVING)
                    
                    Text("Flexibility").frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
                    Slider(
                        value: $flexibility,
                        in: 0...100,
                        onEditingChanged: { editing in
                            
                        }
                    )
                    
                    HStack {
                        Text("strict (stick to shortest)")
                            .font(
                                .system(size: 12, weight: .light)
                            )
                        
                        Spacer()
                        
                        Text("flexible (scenic detours, etc)")
                            .font(
                                .system(size: 12, weight: .light)
                            )
                    }
                    
                    // intensity
                    Text("Intensity").frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
                    Picker("", selection: $intensity) {
                        Text("Relaxing").tag(Intensity.LOW)
                        Text("Moderate").tag(Intensity.MODERATE)
                        Text("Adventurous").tag(Intensity.HIGH)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    // accesiblility
                    Toggle(isOn: $accessible) {
                        Text("Accessible (wheelchair/stroller)")
                    }.padding(.top, 20)
                    
                    // budget
                    
                    Text("Budget").frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
                    Picker("", selection: $budget) {
                        Text("Free").tag(Budget.ZERO)
                        Text("$").tag(Budget.LOW)
                        Text("$$").tag(Budget.MODERATE)
                        Text("$$$").tag(Budget.HIGH)
                        Text("$$$$").tag(Budget.VERYHIGH)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                }.padding(.horizontal, 20).padding(.top, 5)
            }
            
            Spacer()
        }.padding(.top, 15)
    }
}

struct BetterGenerationView: View {
    let position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.4493177, longitude: -76.4956673),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    @State private var locations: [String] = ["", ""]
    @State private var locNames : [String] = ["", ""]
    
    @State private var pickedCoords : [CLLocationCoordinate2D?] = [nil, nil]

    // Sheet state
    @State private var showSuggestionSheet : Bool = false
    @State private var activeFieldIndex: Int? = nil
    
    @State private var navigateToGenerate : Bool = false
    
    @State private var intermediateStops : Int = 3
    
    @State private var showAdvancedOptions : Bool = false
    
    // advanced options
    @State var transit : TransportMethods = TransportMethods.WALKING
    
    @State var usePublicTransit : Bool = true
    
    @State var flexibility : Float = 50
    
    @State var intensity : Intensity = Intensity.MODERATE
    
    @State var accessible : Bool = false
    
    @State var budget : Budget = Budget.LOW;
    
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationView {
            ZStack {
                Map(initialPosition: position) {
                    ForEach(pickedCoords.indices, id: \.self) { i in
                        if let coord = pickedCoords[i] {
                            Marker(locNames[i], coordinate: coord)   // or: Annotation("Pin \(i+1)", coordinate: coord)
                                .tint(i == 0 ? .green : i == pickedCoords.count - 1 ? .red : .blue)
                                
                        }
                    }
                }
                .mapControlVisibility(.hidden)
                
                VStack() {
                    HStack {
                        Button() {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left").frame(width: 32, height: 32)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .cornerRadius(6)
                            
                        }.frame(width: 32, height: 32).padding(.bottom, 5)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                    
                    // top thing
                    GenerationSettings(
                        locations: $locations,
                        showSuggestionSheet: $showSuggestionSheet,
                        activeFieldIndex: $activeFieldIndex,
                        intermediateStops: $intermediateStops
                    )
                    
                    Spacer()
                    
                    // bottom thing
                    BottomGenerationView(
                        navigateToGenerate: $navigateToGenerate,
                        openAdvancedOptions: $showAdvancedOptions
                    )
                }
            }.navigationDestination(isPresented: $navigateToGenerate) {
                ResultsLoadingView().navigationBarBackButtonHidden(true)
            }.sheet(isPresented: $showSuggestionSheet) {
                // Determine which text field is active and bind its text into the sheet
                let idx = activeFieldIndex ?? 0
                
                LocationSuggestionsSheet(query: $locations[idx], onPick: { picked in
                    // Write the formatted place into the active field and dismiss
                    locations[idx] = picked.subtitle.isEmpty
                    ? picked.title
                    : "\(picked.title), \(picked.subtitle)"
                    
                    locNames[idx] = picked.title
                                        
                    showSuggestionSheet = false
                    
                    activeFieldIndex = nil
                    
                    let loc : CLLocation? = getLocation(completion: picked)
                                        
                    if loc != nil {
                        pickedCoords[idx] = loc!.coordinate
                    } else {
                        pickedCoords[idx] = nil
                    }
                    
                    
                }, customPick: { cpick in
                    
                    if cpick.identifier == .USER_LOCATION {
                        locations[idx] = "Your Location"
                    } else if (cpick.identifier == .ON_MAP) {
                        // navigate to other page
                        locations[idx] = "TODO"
                    } else if (cpick.identifier == .PREV_LOCATION) {
                        locations[idx] = cpick.subtitle.isEmpty
                        ? cpick.title
                        : "\(cpick.title), \(cpick.subtitle)"
                    }
                    
                    showSuggestionSheet = false
                    
                    activeFieldIndex = nil
                })
                
            }
            .toolbar(.hidden)
        }.sheet(isPresented: $showAdvancedOptions) {
            AdvancedOptions(
                showAdvancedOptions: $showAdvancedOptions,
                transit: $transit,
                usePublicTransit: $usePublicTransit,
                flexibility: $flexibility,
                intensity: $intensity,
                accessible: $accessible,
                budget: $budget
            )
        }
        
    }
}

#Preview {
    BetterGenerationView()
}
