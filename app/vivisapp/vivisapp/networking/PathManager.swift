//
//  PathManager.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/20/25.
//

import Foundation
import SwiftUI

public class Loc : Codable {
    var name : String;
    var subtitle : String?;
    var lat : Float;
    var lon : Float;
    
    init(name: String, lat: Float, lon: Float, subtitle: String? = nil) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.subtitle = subtitle
    }
}
/**
 // advanced options
 @State var transit : TransportMethods = TransportMethods.WALKING
 
 @State var usePublicTransit : Bool = true
 
 @State var flexibility : Float = 50
 
 @State var intensity : Intensity = Intensity.MODERATE
 
 @State var accessible : Bool = false
 
 @State var budget : Budget = Budget.LOW;
 
 */


public enum PathError: LocalizedError {
    case pathGenerationFailed(String)
    case serverError(String)
    case unexpectedResponse
    
    public var errorDescription: String? {
        switch self {
        case .pathGenerationFailed(let msg): return msg
        case .serverError(let msg):       return msg
        case .unexpectedResponse:         return "Unexpected server response."
        }
    }
    
    public var readableDescription: String? {
        switch self {
        case .pathGenerationFailed(_): return "Path generation failed"
        case .serverError(_): return "Something went wrong"
        case .unexpectedResponse: return "Something went wrong"
        }
    }
}

func sendRequest(locs: [Loc], intmStops: Int, transportMethod: TransportMethods, usePublicTransit: Bool, flexibility: Float, intensity: Intensity, accessible: Bool, budget: Budget) async throws {
    guard let url = URL(string: Constants.api_url + "path/generate") else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let body: [String: Any] = [
        "locations": locs.map { ["name": $0.name, "subtitle": $0.subtitle ?? "", "lat": $0.lat, "lon": $0.lon] },
        "intermediate_stops": intmStops,
        "transport_method": transportMethod,
        "use_public_transit": usePublicTransit,
        "flexibility": flexibility,
        "intensity": intensity,
        "accessible": accessible,
        "budget": budget
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
    
    } catch {
        print("Error serializing JSON: \(error)")
        return
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("Invalid response from server")
        return
    }
    
    // Handle the response data as needed
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response from server: \(responseString)")
    } else {
        print("Unable to convert response data to string")
    }
    
    // todo: work on the backend!!!!!
    
    
    guard let http = response as? HTTPURLResponse else {
        throw PathError.unexpectedResponse
    }
    
    let decoder = JSONDecoder()
    if !(http.statusCode == 200 || http.statusCode == 201) {
        throw PathError.pathGenerationFailed("Path generation failed")
    }
    
    
}
