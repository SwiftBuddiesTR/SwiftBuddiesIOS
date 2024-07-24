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

    @StateObject private var vm = NewEventViewViewModel()
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                DropdownMenu(prompt: "Select..",
                             options: vm.filteredCategories,
                             selection: $vm.selectedCategory)
                nameTextfield
                descriptionTextField
                datePickers
                NextButton
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

extension NewEventView {
    
    private var nameTextfield: some View {
        TextField("Event name...", text: $vm.nameText)
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
        TextField("About your event...", text: $vm.descriptionText)
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
            DatePicker("Start Date", selection: $vm.startDate)
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
            
            DatePicker("Due Date", selection: $vm.dueDate)
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
    
    private var NextButton: some View {
        Button(action: {
            if vm.selectedCategory != nil {
                EventSingletonModel.sharedInstance.category = vm.selectedCategory ?? ""
                EventSingletonModel.sharedInstance.name = vm.nameText
                EventSingletonModel.sharedInstance.aboutEvent = vm.descriptionText
                EventSingletonModel.sharedInstance.startDate = vm.startDate
                EventSingletonModel.sharedInstance.dueDate = vm.dueDate
                coordinator.navigate(to: .selectLocationMapView)
            } else {
                // Handle error message if selectedCategory is nil
            }
            
        }) {
            Text("Next")
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .disabled(vm.selectedCategory == nil) // Disable button if selectedCategory is nil
        
    }
}
