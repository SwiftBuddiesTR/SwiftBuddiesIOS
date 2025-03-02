import SwiftUI
import MapKit
import Design
import Localization

public struct MapView: View {
    
    @StateObject var vm = MapViewModel()
    @StateObject var coordinator = MapNavigationCoordinator()
    @State private var hasAppeared = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $coordinator.mapNavigationStack) {
            ZStack {
                mapLayer
                    .ignoresSafeArea(edges: [.top, .leading, .trailing])
                
                VStack(alignment: .leading) {
                    listHeader
                        .padding(.top, 5)
                        .padding(.leading)
                        .padding(.trailing, 56)
                    categoryFilterButton
                        .padding(.horizontal)
                    Spacer()
                    
                    if !vm.categoryModalShown {
                        VStack {
                            HStack {
                                VStack {

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
                    CategoryPicker(
                        selectedCategory: $vm.selectedCategory,
                        categories: vm.categories
                    )
                } onDismiss: {
                    withAnimation(.easeInOut) {
                        vm.filteredItems(items: vm.allEvents, selectedItems: &vm.selectedEvents)
                    }
                }
            .navigationDestination(for: MapNavigationCoordinator.NavigationDestination.self) { destination in
                switch destination {
                case .mapView:
                    MapView()
                case .newEventView:
                    NewEventView()
                case .selectLocationMapView(let event):
                    LocationSelectionView(newEvent: event) { eventId in
                        if let eventId {
                            debugPrint("Event Created with ID: \(eventId)")
                            Task {
                                await vm.getAllEvents()
                            }
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut) {
                                    
                                    vm.currentEvent = vm.selectedEvents.last
                                    print("------------------- current event:", vm.currentEvent?.name)
                                    
                                }
                            }
                            
                        } else {
                            debugPrint("EVENT CREATION FAILED")
                        }
                    }
                }
            }
        }
        .environmentObject(vm)
        .environmentObject(coordinator)
    }
    
    private func createAlert(text: String? = nil) -> Alert {
        return Alert(title: L.alert_error_title,
                     message: Text(text ?? L.$alert_error_generic.localized),
                     dismissButton: .default(L.alert_button_ok))
    }
}


#Preview {
    MapView()
}


// MARK: COMPONENTS
extension MapView {
    
    private var mapLayer: some View {
        ZStack {
            Map(
                coordinateRegion: $vm.region,
                showsUserLocation: true,
                annotationItems: vm.selectedEvents
            ) { item in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                ) {
                    AnnotationView(color: Color(hex: item.category.color),
                                   isSelected: vm.currentEvent == item)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                vm.currentEvent = item
                                vm.showEventListView = false
                            }
                        }
                        .shadow(radius: 10)
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
                .mapControlVisibility(.visible)
                .padding(.top, 100)
        }
        .onAppear {
            if !hasAppeared {
                // İlk kez görünüyorsa, konum güncellemelerini başlat
                vm.setUserLocation()
                Task {
                    await vm.getAllEvents()
                }
                // Sonrasında setUserLocation çağrılmaya devam etmesin
                hasAppeared = true
            } else {
                // Son etkinliği seç
            }
        
        }
        .onDisappear {
            vm.stopUpdatingLocation()
            vm.showExplanationText = false
        }
    }
    
    private var listHeader: some View {
        VStack {
            Button {
                vm.toggleEventList()
            } label: {
                Text(vm.currentEvent?.name ?? L.$common_select_an_event.localized)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 44)
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
                EventListView(events: vm.selectedEvents)
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
                L.filter_by_category
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .padding()
            }
        }
        .frame(height: 24)
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
            L.map_event_info_hint
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
