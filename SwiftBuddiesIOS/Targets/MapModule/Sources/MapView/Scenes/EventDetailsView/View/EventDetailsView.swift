//
//  EventDetailsView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 22.07.2024.
//

import SwiftUI
import MapKit

struct EventDetailsView: View {
    
    var event: EventModel
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 16){
                    titleSection
                    Divider()
                    if event.aboutEvent != "" {
                        descriptionSection
                        Divider()
                    }
                    eventDates
                    Divider()
                    mapLocation
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        
        }
        .background(.ultraThinMaterial)
           
        
        
        
    }
}


#Preview {
    EventDetailsView(event: EventModel(category: .init(name: "", color: ""), name: "test", aboutEvent: "test", startDate: "", dueDate: "", latitude: 12, longitude: 12))
}

// MARK: COMPONENTS
extension EventDetailsView {
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(event.category.name)
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading) {
            Text(event.aboutEvent)
        }
    }
    
    private var eventDates: some View {
        // ISO 8601 formatını çözmek için doğru formatı kullanıyoruz
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Between:")
                .font(.title2)
                .fontWeight(.bold)
            
            if let startDate = dateFormatter.date(from: event.startDate) {
                let formattedStartDate = displayFormatter.string(from: startDate)
                Text(formattedStartDate)
            }
            
            if let dueDate = dateFormatter.date(from: event.dueDate) {
                let formattedDueDate = displayFormatter.string(from: dueDate)
                Text(formattedDueDate)
            }
        }
    }
    
    private var mapLocation: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), annotationItems: [event]) { event in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)) {
                    AnnotationView(color: Color(hex: event.category.color))
                        .shadow(radius: 10)
                }
            }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
        }
    }
    
}
