//
//  NewEventView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import SwiftUI
import SwiftData
import Localization

struct NewEventView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    
    @EnvironmentObject var coordinator: MapNavigationCoordinator
    @EnvironmentObject var mapVM: MapViewModel
    @StateObject private var vm = NewEventViewViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                categoryPickerMenu
                nameTextfield
                descriptionTextField
                Divider()
                datePickers
                nextButton
                    
            }
            .alert(isPresented: $vm.showAlert) {
                createAlert()
            }
            .navigationTitle(L.$event_details.localized)
            .navigationBarTitleDisplayMode(.large)
            .padding(.top)
            Spacer()
        }
    }
}



#Preview {
    NewEventView()
}


// MARK: COMPONENTS
extension NewEventView {
    
    private var categoryPickerMenu: some View {
        Menu {
            ForEach(mapVM.filteredCategories) { category in
                Button(action: {
                    vm.categorySelection = category
                }) {
                    Text(category.name.capitalized)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                }
            }
        } label: {
            HStack {
                Text(vm.categorySelection?.name ?? L.$textfield_select_category.localized)
                    .font(.headline)
                    .foregroundStyle(Color("AdaptiveColor"))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        Color(.secondarySystemBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
            }
        }
    }
    
    private var nameTextfield: some View {
        TextField(L.$textfield_event_name_placeholder.localized, text: $vm.nameText)
            .textInputAutocapitalization(.never)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                Color(.secondarySystemBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
    
    private var descriptionTextField: some View {
        TextField(L.$textfield_event_description_placeholder.localized, text: $vm.descriptionText)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                Color(.secondarySystemBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
    
    private var datePickers: some View {
        VStack(spacing: 20) {
            DatePicker(L.$datepicker_start_date.localized, selection: $vm.startDate, displayedComponents: [.date])
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(
                    Color(.secondarySystemBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
            DatePicker(L.$datepicker_due_date.localized, selection: $vm.dueDate, in: vm.startDate..., displayedComponents: [.date])
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(
                    Color(.secondarySystemBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            if let selection = vm.categorySelection {
                let newEventModel: NewEventModel = .init(
                    category: selection,
                    name: vm.nameText,
                    description: vm.descriptionText,
                    startDate: vm.startDate.toISOString(),
                    dueDate: vm.dueDate.toISOString(),
                    latitude: nil,
                    longitude: nil
                )
                coordinator.navigate(to: .selectLocationMapView(newEventModel))
            } else {
                vm.showAlert = true
            }
            
        }) {
            L.button_next
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        
    }
    
    private func createAlert() -> Alert {
        return Alert(title: L.alert_error_title,
                     message: L.alert_error_category_empty,
                     dismissButton: .default(L.alert_button_ok))
    }
}
