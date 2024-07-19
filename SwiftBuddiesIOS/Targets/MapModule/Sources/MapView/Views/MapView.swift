import SwiftUI
import MapKit
import Design
import SwiftData


public struct MapView: View {
    
    @StateObject var vm = MapViewModel()
    
    //QUERY MAPVİEWMODEL A AKTARILMALI?
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
            .onAppear {
                // Map açıldığında tüm eventler de ki anotasyonları görebilmek için
                self.selectedItems = items
            }
            .bottomSheet(
                presentationDetents: [.large, .fraction(0.2), .fraction(0.4), .fraction(0.5), .fraction(0.9), .medium],
                detentSelection: $vm.selectedDetent,
                isPresented: $vm.categoryModalShown,
                sheetCornerRadius: 12,
                interactiveDismissDisabled: false) {
                    CategoryPicker(selectedCategory: $vm.selectedCategory) {}
                } onDismiss: {
                    withAnimation(.easeInOut) {
                        vm.filteredItems(items: items, selectedItems: &selectedItems)
                    }
                }
            .navigationDestination(for: Coordinator.NavigationDestination.self) { destination in
                switch destination {
                case .newEventView:
                    NewEventView()
                        .environmentObject(coordinator)
                case .selectLocationMapView:
                    LocationSelectionView()
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
    
    private var MapLayer: some View {
        Map(coordinateRegion: $vm.region, annotationItems: selectedItems) { item in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                // BU KONTROL ENUMLA GERÇEKLEŞTİRELECEK!
               
                if item.category == EventCategory.meeting.rawValue {
                    OrangeAnnotationView()
                        .shadow(radius: 10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.setMapRegion(to: item)
                            }
                        }
                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
                    
                } else if item.category == EventCategory.studyBody.rawValue {
                    RedAnnotationView()
                        .shadow(radius: 10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.setMapRegion(to: item)
                            }
                        }
                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
                    
                } else if item.category == EventCategory.placeToWork.rawValue {
                    
                    BlueAnnotationView()
                        .shadow(radius: 10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.setMapRegion(to: item)
                            }
                        }
                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
                    
                } else if item.category == EventCategory.swiftBuddiesEvent.rawValue {
                    
                    GreenAnnotationView()
                        .shadow(radius: 10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.setMapRegion(to: item)
                            }
                        }
                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
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
