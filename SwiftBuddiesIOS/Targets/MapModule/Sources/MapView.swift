import SwiftUI
import MapKit
import Design

public struct MapView: View {
    
    @StateObject var vm = MapViewViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            MapLayer
            .bottomSheet(
                presentationDetents: [.large, .fraction(0.2), .fraction(0.4), .fraction(0.5), .medium],
                detentSelection: $vm.selectedDetent,
                isPresented: $vm.categoryModalShown,
                sheetCornerRadius: 12,
                interactiveDismissDisabled: false) {
                    CategoryPicker(selectedCategory: $vm.selectedCategory) {
                        vm.selectedDetent = .fraction(0.2)
                        vm.dismissableMessage.toggle()
                    }
                } onDismiss: {
                    
                }
                
            if !vm.categoryModalShown {
                VStack {
                    Spacer()
                    HStack{
                        seeLocationsButton
                        createEventButton
                            .padding()
                    }
                }
            }
            
            DismissableMessage(displayMessage: $vm.dismissableMessage, delay: 3.0) {
                Text("\(vm.selectedCategory)")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(5)
                    .padding(.top, 80) // Adjust this to properly place on the screen
            }
        }
    }
}

#Preview {
    MapView()
}



// Map view
struct MapLocationsView: View {
    var locations: [Location]

    var body: some View {
        VStack {
            Map(position: .constant(.automatic)) {
                ForEach(locations) { location in
                    Annotation(coordinate: location.coordinate) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(location.backgroundColor ?? Color.teal)
                            if let image = location.image {
                                image
                                    .frame(width: 12, height: 12)
                                    .padding(5)
                            } else {
                                Image(systemName: "house")
                                    .frame(width: 24, height: 24)
                                    .padding(5)
                            }
                        }
                    } label: {
                        Text(location.name)
                    }

                }
//                Annotation("Columbia University", coordinate: .columbiaUniversity) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 5)
//                            .fill(Color.teal)
//                        Text("🎓")
//                            .padding(5)
//                    }
//                }
            }
            
//            Map(
//                coordinateRegion: .constant(
//                    MKCoordinateRegion(
//                        center: CLLocationCoordinate2D(latitude: 41.04, longitude: 29),
//                        latitudinalMeters: 10000,
//                        longitudinalMeters: 10000
//                    )
//                ),
//                annotationItems: locations
//            ) { location in
//                MapPin(coordinate: location.coordinate, tint: Color.orange)
//            }
        }
    }
}

struct CategoryPicker: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedCategory: String
    let categories = ["Coffee Shops", "Where to Work", "Meeting Points"]
    var selectAction: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        selectAction()
                    }) {
                        Text(category)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Select Category")
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


// MARK: View extensions for mapView
extension MapView {
    
    private var MapLayer: some View {
        Map(position: $vm.position){
            
        }
        .mapControls {
            Spacer()
            MapUserLocationButton()
            MapPitchToggle()
        }
        .padding(.top, 40)
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
        .ignoresSafeArea()
    }
    
    private var seeLocationsButton: some View {
        Button(action: {
            vm.categoryModalShown.toggle()
        }) {
            Text("See Locations")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
    
    private var createEventButton: some View {
        Button(action: {
            // MARK: define function to create event
        
            vm.selectedCategory = "Select a meeting point on map"
            vm.dismissableMessage = true
            
        }) {
            Text("Create Event ")
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
        }
    }
    
}
