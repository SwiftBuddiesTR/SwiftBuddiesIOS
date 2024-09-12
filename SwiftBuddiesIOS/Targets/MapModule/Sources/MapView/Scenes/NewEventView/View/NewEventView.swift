//
//  NewEventView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import SwiftUI
import SwiftData

struct NewEventView: View {
    //BU EKRANIN TASARIMI GELİŞTİRİLEBİLİR.
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context

    @StateObject private var vm = NewEventViewViewModel()
    @EnvironmentObject var coordinator: MapNavigationCoordinator
    @State private var showAlert: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DropdownMenu(prompt: "Select..",
                             options: vm.filteredCategories,
                             selection: $vm.selectedCategory)
                nameTextfield
                descriptionTextField
                Divider()
                datePickers
                NextButton
                    
            }
            .alert(isPresented: $showAlert) {
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
        VStack(spacing: 20) {
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
                let newEventModel: NewEventModel = .init(
                    category: vm.selectedCategory ?? "",
                    name: vm.nameText,
                    aboutEvent: vm.descriptionText,
                    startDate: vm.startDate.toISOString(),
                    dueDate: vm.dueDate.toISOString(),
                    latitude: nil,
                    longitude: nil
                )
                coordinator.navigate(to: .selectLocationMapView(newEventModel))
            } else {
                // Handle error message if selectedCategory is nil
                showAlert = true
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
