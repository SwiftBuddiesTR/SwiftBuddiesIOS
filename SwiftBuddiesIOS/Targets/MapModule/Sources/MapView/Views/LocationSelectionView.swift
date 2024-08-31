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
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    @StateObject var vm = LocationSelectionViewViewModel()

    @State var tappedLocation: CLLocationCoordinate2D? = nil
    @State private var showAlert: Bool = false
    let eventSingleton = EventSingletonModel.sharedInstance
    @FocusState private var isButtonFocused: Bool
    
    var body: some View {
        ZStack {
            mapLayer
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
             
            
            VStack {
                Spacer()
                createButton
                    .padding()
                    .focused($isButtonFocused)
            }
            .alert(isPresented: $showAlert) {
                createAlert()
            }
        }
    }
}


#Preview {
    LocationSelectionView()
}

extension LocationSelectionView {
    
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
            if tappedLocation != nil {
                vm.addItem(modelContext: context, id: UUID().uuidString, category: eventSingleton.category , name: eventSingleton.name, about: eventSingleton.aboutEvent, startDate: eventSingleton.startDate.toISOString(), dueDate: eventSingleton.dueDate.toISOString(), latitude: tappedLocation!.latitude, longitude: tappedLocation!.longitude)
                
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

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
