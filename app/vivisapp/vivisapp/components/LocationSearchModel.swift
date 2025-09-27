//
//  LocationSearchModel.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/14/25.
//

import MapKit
import SwiftUI

final class LocationSearchModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []

    private let completer: MKLocalSearchCompleter = {
        let c = MKLocalSearchCompleter()
        c.resultTypes = [.query, .address, .pointOfInterest, .physicalFeature]
        return c
    }()

    override init() {
        super.init()
        completer.delegate = self
    }

    func update(query: String) {
        completer.queryFragment = query
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // You can surface the error if you want
        results = []
    }
}

enum PrepickIdentifier {
    case USER_LOCATION,
    ON_MAP,
    PREV_LOCATION
}

struct NoResultObject {
    var title : String
    var subtitle : String
    var identifier : PrepickIdentifier
    var systemImage : String? = nil
    
    init(title: String, subtitle: String, identifier: PrepickIdentifier, systemImage: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.identifier = identifier
        if let systemImage = systemImage {
            self.systemImage = systemImage
        }
    }
}

public func getLocation(completion: MKLocalSearchCompletion) -> CLLocation?
{
    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    
    var returnedData : CLLocation? = nil
    
    search.start
    {
        (response, error) in
        guard let response = response else {
            print("search failed: \(error?.localizedDescription ?? "No error information")")
            return
        }
    
        for item in response.mapItems
        {
            
            if let location = item.placemark.location
            {
                returnedData = location
            }
            
        }
    }
    // Wait for the search to complete
    while returnedData == nil {
        RunLoop.current.run(until: Date().addingTimeInterval(0.01))
    }
    
    return returnedData
}

struct LocationSuggestionsSheet: View {
    @Binding var query: String
    var onPick: (MKLocalSearchCompletion) -> Void
    var customPick : ((NoResultObject) -> Void)? = nil

    @StateObject private var model = LocationSearchModel()
    
    var noResultObjects : [NoResultObject] = [
        NoResultObject(title: "Your Location", subtitle: "", identifier: .USER_LOCATION, systemImage: "location.circle.fill"),
        NoResultObject(title: "Choose on Map", subtitle: "", identifier: .ON_MAP, systemImage: "mappin.circle.fill"),
    ]

    var body: some View {
        NavigationStack {
            List {
                if model.results.indices.isEmpty {
                    
                    ForEach(noResultObjects.indices, id: \.self) { i in
                        
                        let item = noResultObjects[i]
                            
                        Button {
                            if customPick != nil {
                                customPick!(item)
                            }
                            
                            //onPick(item)
                            //onPick(MKLocalSearchCompletion((query as NSString).lastPathComponent as NSString))
                        } label: {
                            HStack {
                                if item.systemImage != nil {
                                    Image(systemName: item.systemImage!).padding(.trailing, 5)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.body)
                                    if !item.subtitle.isEmpty {
                                        Text(item.subtitle)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }.padding(.vertical, 4)
                        }
                    }
                    
                } else {
                    // index-based ForEach avoids Hashable issues with MKLocalSearchCompletion
                    ForEach(model.results.indices, id: \.self) { i in
                        let item = model.results[i]
                        Button {
                            onPick(item)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.body)
                                if !item.subtitle.isEmpty {
                                    Text(item.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Search places")
            .searchable(text: $query, placement: .navigationBarDrawer, prompt: "Enter a place")
        }
        .onAppear { model.update(query: query) }
        .onChange(of: query) { model.update(query: $0) }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    @Previewable @State var test = "";
    LocationSuggestionsSheet(query: $test) { _ in
        
    }
}
