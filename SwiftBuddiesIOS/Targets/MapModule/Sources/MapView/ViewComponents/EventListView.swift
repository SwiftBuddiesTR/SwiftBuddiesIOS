//
//  EventListView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 22.07.2024.
//

import SwiftUI

struct EventListView: View {
    
    @StateObject var vm = MapViewModel()
    var events: [EventModel]
    
    var body: some View {
        List{
            ForEach(events) { event in
                NavigationLink {
                    EventDetailsView(event: event)
                } label: {
                    listRowView(event: event)
                }
                .padding(.vertical , 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    EventListView(events: [EventModel(category: .mock, name: "test", aboutEvent: "test", startDate: "", dueDate: "", latitude: 12, longitude: 12)])
}

extension EventListView {
    
    private func listRowView(event: EventModel) -> some View {
        HStack{
            Image(systemName: "circle.dotted.circle")
                .foregroundColor(imageColor(event: event))
            
            VStack(alignment: .leading){
                Text(event.name)
                    .font(.headline)
                Text(event.category.name)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
    
    private func imageColor(event: EventModel) -> Color {
//        if event.category == "Meeting" /*EventCategory.meeting.rawValue*/ {
//            return .orange
//        } else if event.category == "Study Body" /*EventCategory.studyBody.rawValue*/ {
//            return .red
//        } else if event.category == "Place the work" /*EventCategory.placeToWork.rawValue*/ {
//            return .blue
//        } else if event.category == "Swift Buddies Event" /*EventCategory.swiftBuddiesEvent.rawValue*/ {
//            return .green
//        }
//
//        return .orange
        Color(hex: event.category.color)
    }
}
