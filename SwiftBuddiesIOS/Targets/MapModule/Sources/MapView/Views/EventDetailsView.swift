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
    EventDetailsView(event: EventModel(category: "test", name: "test", aboutEvent: "test", startDate: Date(), dueDate: Date(), latitude: 12, longitude: 12))
}


extension EventDetailsView {
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(event.category)
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
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
                
            return VStack(alignment: .leading, spacing: 8) {
                Text("Between:")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(dateFormatter.string(from: event.startDate))
                Text(dateFormatter.string(from: event.dueDate))
            }
    }
    
    private var mapLocation: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), annotationItems: [event]) { event in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)) {
                    if event.category == EventCategory.meeting.rawValue {
                        OrangeAnnotationView()
                            .shadow(radius: 10)
                    } else if event.category == EventCategory.studyBody.rawValue {
                        RedAnnotationView()
                            .shadow(radius: 10)
                    } else if event.category == EventCategory.placeToWork.rawValue {
                        BlueAnnotationView()
                            .shadow(radius: 10)
                        
                    } else if event.category == EventCategory.swiftBuddiesEvent.rawValue {
                        GreenAnnotationView()
                            .shadow(radius: 10)
                    }
                }
            }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
        }
    }
    
}
