//
//  NewEventView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import SwiftUI
import MapKit
import SwiftData

struct NewEventView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    @Query private var items: [EventModel]
    
    @StateObject var vm = MapViewModel()

    //@State private var tappedLocation: CLLocationCoordinate2D?
    
    private let categories = [
        "Meeting",
        "Study Body",
        "Place to work",
        "Swift Buddies Event"
    ]
    
    
    @State private var selectedCategory: String?
    @State var nameText: String = ""
    @State var descriptionText: String = ""
    @State var adressText: String = ""
    @State var startDate: Date = Date()
    @State var dueDate: Date = Date()
    //@State var location: CLLocationCoordinate2D =
   

    var body: some View {
       
            ScrollView{
                VStack(spacing: 15){
                    DropdownMenu(prompt: "Select..",
                                 options: categories,
                                 selection: $selectedCategory
                    )
                    nameTextfield
                    descriptionTextField
                    adressTextField
                    datePickers
                    mapLayer
                    createButton
                }
                .navigationTitle("Event Details")
                .padding(.top)
                Spacer()
            }
        
       
        
    }
    
}

#Preview {
    NewEventView()
}



extension NewEventView {
    
    private var nameTextfield: some View {
        TextField("Event name...", text: $nameText)
            .textInputAutocapitalization(.never)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .background(
                Color(.secondarySystemBackground)
            )
            .padding(.horizontal)
            
            
    }
    
    private var descriptionTextField: some View {
        TextField("About your event...", text: $descriptionText)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .background(
                Color(.secondarySystemBackground)
            )
            .padding(.horizontal)
            
    }
    
    private var adressTextField: some View {
        TextField("Full Adress...", text: $adressText)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .background(
                Color(.secondarySystemBackground)
            )
            .padding(.horizontal)
    }
    
    
    private var datePickers: some View {
        VStack(spacing: 15) {
            DatePicker("Start Date", selection: $startDate)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .padding(.horizontal)
                
            
            DatePicker("Due Date", selection: $dueDate)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .background(
                    Color(.secondarySystemBackground)
                )
                .padding(.horizontal)
        }
    }
    
    private var mapLayer: some View {
        VStack {
            Map(position: $vm.position) {
                
            }
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
            if selectedCategory != nil {
                vm.addItem(modelContext: context, id: UUID().uuidString, category: selectedCategory ?? "", name: nameText, about: descriptionText, startDate: startDate, dueDate: dueDate)
                print(items.count)
                self.presentationMode.wrappedValue.dismiss()
            } else {
              //Hata mesajı
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
}



/*import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKPointAnnotation]
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                let location = gestureRecognizer.location(in: gestureRecognizer.view as? MKMapView)
                if let mapView = gestureRecognizer.view as? MKMapView {
                    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    parent.annotations.append(annotation)
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

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var annotations = [MKPointAnnotation]()
    
    var body: some View {
        VStack {
            MapView(region: $region, annotations: $annotations)
                .aspectRatio(1, contentMode: .fill)
                .cornerRadius(15)
                .padding(.horizontal)
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}
*/
