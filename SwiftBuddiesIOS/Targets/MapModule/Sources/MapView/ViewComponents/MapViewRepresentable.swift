//
//  MapViewRepresentable.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 30.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    @Binding var tappedLocation: CLLocationCoordinate2D?

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                let location = gestureRecognizer.location(in: gestureRecognizer.view as? MKMapView)
                if let mapView = gestureRecognizer.view as? MKMapView {
                    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                    parent.tappedLocation = coordinate
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(NavigationCoordinator.handleLongPress(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGesture)

        // Haritayı kullanıcının konumu ile başlat
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Anotasyonları kaldır ve yeni anotasyonu ekle
        uiView.removeAnnotations(uiView.annotations)
        if let location = tappedLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            uiView.addAnnotation(annotation)
        }
    }
}

