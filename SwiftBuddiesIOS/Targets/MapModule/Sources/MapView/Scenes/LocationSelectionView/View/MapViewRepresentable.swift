//
//  MapViewRepresentable.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 30.06.2024.
//
//
//
//

import Foundation
import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    @Binding var tappedLocation: CLLocationCoordinate2D?
    @Binding var searchResults: [MKMapItem]
    @Binding var selectedAnnotation: MKPointAnnotation?

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
                    
                    // Long press yapıldığında diğer tüm anotasyonları kaldır
                    parent.selectedAnnotation = nil
                    parent.searchResults.removeAll()
                }
            }
        }
        
        // Anotasyona tıklama işlemini ele al
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? MKPointAnnotation else { return }
            
            // Seçilen anotasyonu kaydet ve diğerlerini temizle
            parent.selectedAnnotation = annotation
            parent.searchResults.removeAll()
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation) // <-- Sadece seçilen anotasyonu ekle
            
            // Seçilen anotasyonun konumunu tappedLocation'a aktar
            parent.tappedLocation = annotation.coordinate
            
            print("Seçilen anotasyon: \(annotation.title ?? "Bilinmiyor")")
            print("Konum: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Long press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGesture)

        // Haritayı kullanıcının konumu ile başlat
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

   
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Eğer yeni bir arama yapılırsa, seçilen anotasyonu temizle
        if !searchResults.isEmpty {
            selectedAnnotation = nil
            // Arama sonuçları için haritayı odakla
            zoomToSearchResults(mapView: uiView)
        }
        
        // Eğer seçili bir anotasyon varsa sadece onu göster
        if let selectedAnnotation = selectedAnnotation {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(selectedAnnotation) // <-- Sadece seçili anotasyonu göster
        } else {
            // Eğer seçili anotasyon yoksa, arama sonuçlarını ekle
            uiView.removeAnnotations(uiView.annotations)
            if let location = tappedLocation {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                uiView.addAnnotation(annotation)
            }
            
            // Arama sonuçlarını göster
            for item in searchResults {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                uiView.addAnnotation(annotation)
            }
        }
    }
    
    // Haritanın arama sonuçlarına odaklanmasını sağlayan fonksiyon
    private func zoomToSearchResults(mapView: MKMapView) {
        guard !searchResults.isEmpty else { return }
        
        let coordinates = searchResults.map { $0.placemark.coordinate }
        let region = calculateRegion(for: coordinates)
        mapView.setRegion(region, animated: true)
        
    }

    // Koordinatlara göre region ayarla (arama sonuclarının hepsi görünsün)
    private func calculateRegion(for coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
