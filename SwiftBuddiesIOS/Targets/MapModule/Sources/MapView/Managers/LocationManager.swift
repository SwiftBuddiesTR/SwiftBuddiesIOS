//
//  LocationManager.swift
//  SwiftBuddiesIOS
//
//  Created by Oğuzhan Abuhanoğlu on 14.09.2024.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager() // Singleton
    
    private let manager = CLLocationManager()
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
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
        case .authorizedAlways, .authorizedWhenInUse:
            debugPrint("Location authorized")
        @unknown default:
            debugPrint("Location service disabled")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        // Burada LocationManager sadece konum güncellemeleri sağlıyor, ViewModel'e bildirecek
        LocationManager.shared.didUpdateLocation(coordinate)
    }
    
    // Bu method, LocationManager singleton üzerinden location güncellenmesi sağlanacak
    private var locationUpdateHandler: ((CLLocationCoordinate2D) -> Void)?
    
    func setLocationUpdateHandler(_ handler: @escaping (CLLocationCoordinate2D) -> Void) {
        self.locationUpdateHandler = handler
    }
    
    private func didUpdateLocation(_ coordinate: CLLocationCoordinate2D) {
        locationUpdateHandler?(coordinate)
    }
}
