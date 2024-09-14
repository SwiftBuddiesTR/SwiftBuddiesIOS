//
//  LocationManager.swift
//  SwiftBuddiesIOS
//
//  Created by Oğuzhan Abuhanoğlu on 14.09.2024.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published private(set) var lastKnownLocation: Coord?
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    func checkLocationAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            debugPrint("Location restricted")
            
        case .denied:
            debugPrint("Location denied")
            
        case .authorizedAlways:
            debugPrint("Location authorizedAlways")
            
        case .authorizedWhenInUse:
            debugPrint("Location authorized when in use")
            if let coordinate = manager.location?.coordinate {
                lastKnownLocation = Coord(lat: coordinate.latitude.magnitude, lon: coordinate.longitude.magnitude)
            }
            
        @unknown default:
            debugPrint("Location service disabled")
        }
        
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            lastKnownLocation = Coord(lat: coordinate.latitude.magnitude, lon: coordinate.longitude.magnitude)
        }
        manager.stopUpdatingLocation()
    }
}
