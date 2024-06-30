//
//  LittleMapView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 27.06.2024.
//


import SwiftUI
import MapKit

struct SelectLocationView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKPointAnnotation]
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SelectLocationView
        
        init(_ parent: SelectLocationView) {
            self.parent = parent
        }
        
        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                let location = gestureRecognizer.location(in: gestureRecognizer.view as? MKMapView)
                if let mapView = gestureRecognizer.view as? MKMapView {
                    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    //parent.annotations.append(annotation)
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
        
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
    }
}


