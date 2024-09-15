import SwiftUI
import MapKit
import Design
import SwiftData

public struct MapView: View {
    
    @StateObject var vm = MapViewModel()
    @StateObject var coordinator = MapNavigationCoordinator()

    @Query private var items: [EventModel]
   
    public init() {
        vm.locationManager.checkLocationAuthorization()
        
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.mapNavigationStack) {
            ZStack {
                mapLayer
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
    
                VStack(alignment: .leading) {
                    listHeader
                        .padding(.horizontal)
                    categoryFilterButton
                        .padding(.leading)
                    Spacer()
                    if !vm.categoryModalShown {
                        VStack {
                            HStack {
                                VStack {
                                    // add explanation text here
                                    if vm.showExplanationText == true , vm.currentEvent != nil {
                                        explanationText
                                    }
                                    if vm.currentEvent != nil {
                                        learnMoreButton
                                            .allowsHitTesting(vm.currentEvent != nil)
                                    }
                                }
                                .frame(maxHeight: .infinity, alignment: .bottom)
                               
                                createEventButton
                                    .padding(.horizontal)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                            }
                            .padding()
                        }
                    }
                }
            }
            .bottomSheet(
                presentationDetents: [.large, .fraction(0.2), .fraction(0.9), .medium],
                detentSelection: $vm.selectedDetent,
                isPresented: $vm.categoryModalShown,
                sheetCornerRadius: 12,
                interactiveDismissDisabled: false) {
                    CategoryPicker(selectedCategory: $vm.selectedCategory)
                } onDismiss: {
                    withAnimation(.easeInOut) {
                        vm.filteredItems(items: items, selectedItems: &vm.selectedItems)
                        vm.currentEvent = vm.selectedItems.first
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
        .environmentObject(vm)
        .environmentObject(coordinator)
    }
}
#Preview {
    MapView()
}


// MARK: COMPONENTS
extension MapView {
    
    private var mapLayer: some View {
        Map(coordinateRegion: $vm.locationManager.region, annotationItems: vm.selectedItems) { item in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                AnnotationView(color: .orange)
                    .scaleEffect(vm.currentEvent == item ? 1 : 0.8)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            vm.setMapRegion(to: item)
                            vm.showEventListView = false
                        }
                        
                    }
                    .shadow(radius: 10)
            }
        }
        .onAppear{
            vm.locationManager.startUpdatingLocation()
            vm.locationManager.checkLocationAuthorization()
            vm.selectedItems = items
            vm.currentEvent = vm.selectedItems.first
        }
        .onDisappear {
            vm.locationManager.stopUpdatingLocation()
            vm.locationManager.checkLocationAuthorization()
            vm.showExplanationText = false
            vm.showExplanationText = false
        }
    }
    
    private var listHeader: some View {
        VStack {
            Button {
                vm.toggleEventList()
            } label: {
                Text(vm.currentEvent?.name ?? "")
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
                EventListView(events: vm.selectedItems)
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
            if let event = vm.currentEvent {
                EventDetailsView(event: event)
            }
        } label: {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(55/2)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var explanationText: some View {
        VStack {
            Text("You can click for more information about the selected event on the map.")
                .font(.headline)
                .foregroundStyle(.red)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 180))
                .offset(x: -100 , y: -11)
        }
        .multilineTextAlignment(.center)
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
