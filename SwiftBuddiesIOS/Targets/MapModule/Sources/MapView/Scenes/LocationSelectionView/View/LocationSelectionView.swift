//
//  SelectLocationMapView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 10.07.2024.
//

import SwiftUI
import MapKit
import SwiftData

struct LocationSelectionView: View {
    //BUTON FOCUS PROBLEMİ VAR.
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var coordinator: MapNavigationCoordinator
    @StateObject var vm = LocationSelectionViewViewModel()
    @State var newEvent: NewEventModel

    @State var tappedLocation: CLLocationCoordinate2D? = nil
    @State private var showAlert: Bool = false
    
    init(
        newEvent: NewEventModel
    ) {
        self.newEvent = newEvent
    }
    
    var body: some View {
        ZStack {
            mapLayer
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
            VStack {
                Spacer()
                createButton
                    .padding()
            }
            .alert(isPresented: $showAlert) {
                createAlert()
            }
        }
    }
    
   
}


#Preview {
    LocationSelectionView(
        newEvent: .init(
            category: .mock,
            name: "name",
            aboutEvent: "about",
            startDate: "start",
            dueDate: "due",
            latitude: 0.00,
            longitude: 0.00
        )
    )
}

// MARK: COMPONENTS
extension LocationSelectionView {
    
    private var mapLayer: some View {
        
        ZStack {
            MapViewRepresentable(tappedLocation: $tappedLocation, searchResults: $vm.searchResults, selectedAnnotation: $vm.selectedAnnotation)
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
            
            VStack {
                SearchBar(text: $vm.searchText, onSearchButtonClicked: vm.search)
                    .padding()
                
                Spacer()
            }
            .padding(.top, 80)
        }
        
//        VStack {
//            MapViewRepresentable(tappedLocation: $tappedLocation)
//                .mapControls {
//                    MapUserLocationButton()
//                    MapPitchToggle()
//                }
//        }
//        .aspectRatio(1, contentMode: .fill)
//        .cornerRadius(15)
//        .padding(.horizontal)
         
    }
    
    private var createButton: some View {
        Button(action: {
            // Save the event into core data
            if tappedLocation != nil {
                newEvent.latitude = tappedLocation?.latitude
                newEvent.longitude = tappedLocation?.longitude
                vm.addItem(
                    modelContext: context,
                    newEventModel: newEvent
                )
                coordinator.popToRoot()
                
            } else {
                showAlert = true
            }
            
        }) {
            Text("Create")
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                .foregroundStyle(.white)
                .fontWeight(.bold)
            
        }
    }
    
    private func createAlert() -> Alert {
        return Alert(title: Text("Ups 🧐"),
                     message: Text("Please specify the event location."),
                     dismissButton: .default(Text("OK")))
    }

}
