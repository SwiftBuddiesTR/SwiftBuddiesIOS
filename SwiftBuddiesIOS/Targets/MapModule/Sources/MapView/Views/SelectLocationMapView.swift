//
//  SelectLocationMapView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 10.07.2024.
//

import SwiftUI
import MapKit
import SwiftData

struct SelectLocationMapView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var coordinator: Coordinator
    
    @StateObject var vm = MapViewModel()

    @State var tappedLocation: CLLocationCoordinate2D? = nil
    let eventSingleton = EventSingletonModel.sharedInstance
    
    var body: some View {
        ZStack {
            mapLayer
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
            
            VStack {
                Spacer()
                createButton
                    .padding()
            }
            
        }
    }
}

#Preview {
    SelectLocationMapView()
}

extension SelectLocationMapView {
    
    private var mapLayer: some View {
        VStack {
            MapViewRepresentable(tappedLocation: $tappedLocation)
                .mapControls {
                    MapUserLocationButton()
                    MapPitchToggle()
                }
                .onAppear{
                    CLLocationManager().requestWhenInUseAuthorization()
                }
        }
        .aspectRatio(1, contentMode: .fill)
        .cornerRadius(15)
        .padding(.horizontal)
         
    }
    
    private var createButton: some View {
        Button(action: {
            // Save the event into core data
            vm.addItem(modelContext: context, id: UUID().uuidString, category: eventSingleton.category, name: eventSingleton.name, about: eventSingleton.aboutEvent, startDate: eventSingleton.startDate, dueDate: eventSingleton.dueDate, latitude: tappedLocation!.latitude, longitude: tappedLocation!.longitude)
            
            coordinator.popToRoot()
        }) {
            Text("Create")
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                .foregroundStyle(.white)
                .fontWeight(.bold)
            
        }
    }

}
