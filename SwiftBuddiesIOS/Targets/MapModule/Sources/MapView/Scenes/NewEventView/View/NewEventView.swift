//
//  NewEventView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import SwiftUI
import SwiftData

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
            .navigationTitle("Event Details")
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
                Text(vm.categorySelection?.name ?? "Select a Category")
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
        TextField("Event name...", text: $vm.nameText)
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
        TextField("About your event...", text: $vm.descriptionText)
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
            DatePicker("Start Date", selection: $vm.startDate, displayedComponents: [.date])
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
            
            DatePicker("Due Date", selection: $vm.dueDate, in: vm.startDate..., displayedComponents: [.date])
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
            Text("Next")
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        
    }
    
    private func createAlert() -> Alert {
        return Alert(title: Text("Ups 🧐"),
                     message: Text("Category option can not be empty."),
                     dismissButton: .default(Text("OK")))
    }
}
