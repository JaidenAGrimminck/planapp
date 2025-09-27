//
//  LocationManager.swift
//  vivisapp
//
//  Created by Jaiden Grimminck on 8/6/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    // get location
    @Published var location: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
    }

    /// Call this to prompt the system permission dialog
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
        
        location = manager.location
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .notDetermined:
            print("User has not yet made a choice")
        case .restricted, .denied:
            print("Location access was restricted or denied")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted")
        @unknown default:
            break
        }
    }
}
