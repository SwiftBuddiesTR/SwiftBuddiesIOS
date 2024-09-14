import SwiftUI
import MapKit
import Design
import SwiftData

public struct MapView: View {
    
    @StateObject var vm = MapViewModel()
    @StateObject var coordinator = MapNavigationCoordinator()

    @StateObject var locationManager = LocationManager()
    @Query private var items: [EventModel]
    @State private var selectedItems: [EventModel] = []
    

    public init() {
        locationManager.checkLocationAuthorization()
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.mapNavigationStack) {
            ZStack {
                MapLayer
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
    
                VStack(alignment: .leading) {
                    listHeader
                        .padding(.horizontal)
                    categoryFilterButton
                        .padding(.leading)
                    Spacer()
                    if !vm.categoryModalShown {
                        VStack {
                            Spacer()
                            HStack {
                                learnMoreButton
                                createEventButton
                            }
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
            .navigationDestination(for: MapNavigationCoordinator.NavigationDestination.self) { destination in
                switch destination {
                case .mapView:
                    MapView()
                case .newEventView:
                    NewEventView()
                case .selectLocationMapView(let event):
                    LocationSelectionView(newEvent: event)
                }
            }
        }
        .environmentObject(locationManager)
        .environmentObject(vm)
        .environmentObject(coordinator)
    }
}
#Preview {
    MapView()
}




// MARK: COMPONENTS
extension MapView {
    
    private var MapLayer: some View {
        Map(coordinateRegion: $vm.region, annotationItems: selectedItems) { item in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                AnnotationView(color: .orange)
                        .shadow(radius: 10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.setMapRegion(to: item)
                                vm.showEventListView = false
                            }
                        }
                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)

            }
        }
        .onAppear{
            locationManager.startUpdatingLocation()
            locationManager.checkLocationAuthorization()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
            locationManager.checkLocationAuthorization()
        }
    }
    
    //                if item.category == EventCategory.meeting.rawValue {
    //                    AnnotationView()
    //                        .shadow(radius: 10)
    //                        .onTapGesture {
    //                            withAnimation(.easeInOut) {
    //                                vm.setMapRegion(to: item)
    //                                vm.showEventListView = false
    //                            }
    //                        }
    //                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
    //
    //                } else if item.category == EventCategory.studyBody.rawValue {
    //                    RedAnnotationView()
    //                        .shadow(radius: 10)
    //                        .onTapGesture {
    //                            withAnimation(.easeInOut) {
    //                                vm.setMapRegion(to: item)
    //                                vm.showEventListView = false
    //                            }
    //                        }
    //                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
    //
    //                } else if item.category == EventCategory.placeToWork.rawValue {
    //
    //                    BlueAnnotationView()
    //                        .shadow(radius: 10)
    //                        .onTapGesture {
    //                            withAnimation(.easeInOut) {
    //                                vm.setMapRegion(to: item)
    //                                vm.showEventListView = false
    //                            }
    //                        }
    //                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
    //
    //                } else if item.category == EventCategory.swiftBuddiesEvent.rawValue {
    //
    //                    GreenAnnotationView()
    //                        .shadow(radius: 10)
    //                        .onTapGesture {
    //                            withAnimation(.easeInOut) {
    //                                vm.setMapRegion(to: item)
    //                                vm.showEventListView = false
    //                            }
    //                        }
    //                        .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
    //                }
    
    private var listHeader: some View {
        VStack {
            Button {
                vm.toggleEventList()
            } label: {
                Text(vm.currentEvent.name)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showEventListView ? 180 : 0))
                    }
            }
            
            if vm.showEventListView {
                EventListView(events: selectedItems)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 20 ,x: 0 , y: 15)
        
    }
    
    private var categoryFilterButton: some View {
        VStack{
            Button(action: {
                vm.categoryModalShown.toggle()
            }) {
                Text("filter by category")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .padding()
            }
        }
        .frame(height: 30)
        .background(.thickMaterial)
        .shadow(color: .black.opacity(0.3), radius: 20 ,x: 0 , y: 15)
        .cornerRadius(30)
       
        
    }
    
    private var learnMoreButton: some View {
        NavigationLink {
            EventDetailsView(event: (vm.currentEvent))
        } label: {
            Text(" Learn More ")
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    
    
    private var createEventButton: some View {
        Button(action: {
            coordinator.navigate(to: .newEventView)
        }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(55/2)
        }
    }
    
}
