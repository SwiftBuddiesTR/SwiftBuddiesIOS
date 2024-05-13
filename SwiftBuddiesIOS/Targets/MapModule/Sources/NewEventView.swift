//
//  NewEventView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import SwiftUI
import MapKit

struct NewEventView: View {
    
    @StateObject var viewModel = NewEventViewModel()
    @FocusState private var fieldInFocus: textFieldFocus?
    
    @State private var selectedCategory: String?
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    private let categories = [
        "Meeting",
        "Study Body",
        "Place to work",
        "Swift Buddies Event"
    ]
    
    var body: some View {
       
            ScrollView{
                VStack(spacing: 15){
                    
                    DropdownMenu(prompt: "Select..",
                                 options: categories,
                                 selection:$selectedCategory
                    )
                    
                    eventNameTextfield
                    aboutText
                    datePickers
                    mapLayer
                    createButton
                }
                .navigationTitle("Event Details")
                .padding(.top)
                Spacer()
            }
         
        
        
    }
    
    enum textFieldFocus: Hashable {
        case category, name, about, startDate, dueDate
    }
}

#Preview {
    NewEventView()
}



extension NewEventView {
    
    private var eventNameTextfield: some View {
        TextField("Event name...", text: $viewModel.name )
            .frame(height: 50)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color(UIColor.systemBackground))
            .textInputAutocapitalization(.never)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .padding(.horizontal)
            .fontWeight(.bold)
            .onSubmit {
                fieldInFocus = .about
            }
            .focused($fieldInFocus, equals: .name)
    }
    
    private var aboutText: some View {
        TextEditor(text: $viewModel.about)
            .frame(height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .padding(.horizontal)
    }
    
    private var datePickers: some View {
        VStack(spacing: 15) {
            DatePicker("Start Date", selection: $viewModel.startDate)
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .background(Color(UIColor.systemBackground))
                .textInputAutocapitalization(.never)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .fontWeight(.bold)
                .padding(.horizontal)
                .onSubmit {
                    fieldInFocus = .dueDate
                }
            .focused($fieldInFocus, equals: .startDate)
            
            DatePicker("Due Date", selection: $viewModel.dueDate)
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .background(Color(UIColor.systemBackground))
                .textInputAutocapitalization(.never)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .fontWeight(.bold)
                .padding(.horizontal)
                .onSubmit {
                    
                }
                .focused($fieldInFocus, equals: .dueDate)
        }
    }
    
    private var mapLayer: some View {
        VStack {
            Map(position: $cameraPosition) {
                
            }
            .mapControls {
                MapUserLocationButton()
                MapPitchToggle()
            }
            .onAppear{
                CLLocationManager().requestWhenInUseAuthorization()
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .padding()
        .cornerRadius(20)
    }
    
    private var createButton: some View {
        Button(action: {
            // Save the event to database
        }) {
            Text("Create")
                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                .foregroundStyle(.white)
                .fontWeight(.bold)
                
        }

    }
}
