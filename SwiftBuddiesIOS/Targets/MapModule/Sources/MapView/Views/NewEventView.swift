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

    @StateObject var vm = LocationSelectionViewViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    private let categories = [
        "Meeting",
        "Study Body",
        "Place to work",
        "Swift Buddies Event"
    ]

    @State private var selectedCategory: String?
    @State var nameText: String = ""
    @State var descriptionText: String = ""
    @State var adressText: String = ""
    @State var startDate: Date = Date()
    @State var dueDate: Date = Date()
    

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                DropdownMenu(prompt: "Select..",
                             options: categories,
                             selection: $selectedCategory)
                nameTextfield
                descriptionTextField
                adressTextField
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
        TextField("Event name...", text: $nameText)
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
        TextField("About your event...", text: $descriptionText)
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
    
    private var adressTextField: some View {
        TextField("Full Address...", text: $adressText)
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
            DatePicker("Start Date", selection: $startDate)
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
            
            DatePicker("Due Date", selection: $dueDate)
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
            if selectedCategory != nil {
                EventSingletonModel.sharedInstance.category = selectedCategory ?? ""
                EventSingletonModel.sharedInstance.name = nameText
                EventSingletonModel.sharedInstance.aboutEvent = descriptionText
                EventSingletonModel.sharedInstance.startDate = startDate
                EventSingletonModel.sharedInstance.dueDate = dueDate
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
        .disabled(selectedCategory == nil) // Disable button if selectedCategory is nil
        
    }
}
