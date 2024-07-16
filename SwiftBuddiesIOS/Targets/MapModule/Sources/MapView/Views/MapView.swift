import SwiftUI
import MapKit
import Design
import SwiftData

public struct MapView: View {
    
    @StateObject var vm = MapViewModel()
    
    @Query private var items: [EventModel]
    @State private var selectedItems: [EventModel] = []
    @StateObject var coordinator = Coordinator()

    public init() {
        
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                MapLayer
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    .bottomSheet(
                        presentationDetents: [.large, .fraction(0.2), .fraction(0.4), .fraction(0.5), .fraction(0.9), .medium],
                        detentSelection: $vm.selectedDetent,
                        isPresented: $vm.categoryModalShown,
                        sheetCornerRadius: 12,
                        interactiveDismissDisabled: false) {
                            CategoryPicker(selectedCategory: $vm.selectedCategory) {}
                        } onDismiss: {
                            vm.filteredItems(items: items, selectedItems: &selectedItems)
                            print("all items count: \(items.count)")
                            print("selected items count: \(selectedItems.count)")
                            
                        }
                
                if !vm.categoryModalShown {
                    VStack {
                        Spacer()
                        HStack {
                            seeLocationsButton
                            createEventButton
                                .padding()
                        }
                    }
                }
            }
            .navigationDestination(for: Coordinator.NavigationDestination.self) { destination in
                switch destination {
                case .newEventView:
                    NewEventView()
                        .environmentObject(coordinator)
                case .selectLocationMapView:
                    SelectLocationMapView()
                        .environmentObject(coordinator)
                case .mapView:
                    MapView()
                        .environmentObject(coordinator)
                }
            }
        }
        .environmentObject(coordinator)
    }
}
#Preview {
    MapView()
}


// MARK: View extensions for mapView
extension MapView {
    
    // Core Dataya Location kaydedebilirsem. Bu haritayı o lokasyonlarla başlatacağım ver her category için farklı bir pin designi olcak.
    private var MapLayer: some View {
        Map(coordinateRegion: $vm.region, annotationItems: selectedItems) { item in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                RedAnnotationView()
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.setMapRegion(to: item)
                    }
            }
        }
        .mapControls {
            Spacer()
            MapUserLocationButton()
            MapPitchToggle()
        }
        .padding(.top, 50)
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
        .onDisappear {
            vm.locationManager.stopUpdatingLocation()
        }
        
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
                coordinator.navigate(to: .newEventView)
            }) {
                Text("Create Event")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
        }
    
}
