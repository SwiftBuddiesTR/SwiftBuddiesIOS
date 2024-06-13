//
//  NewEventView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import SwiftUI
import MapKit

struct NewEventView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm = MapViewModel()

    //@State private var tappedLocation: CLLocationCoordinate2D?
    
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
    //@State var location: CLLocationCoordinate2D =
   

    var body: some View {
       
            ScrollView{
                VStack(spacing: 15){
                    DropdownMenu(prompt: "Select..",
                                 options: categories,
                                 selection: $selectedCategory
                    )
                    nameTextfield
                    descriptionTextField
                    adressTextField
                    datePickers
                    mapLayer
                    createButton
                }
                .navigationTitle("Event Details")
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
        TextField("Full Adress...", text: $adressText)
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
    
    private var mapLayer: some View {
        VStack {
            Map(position: $vm.position) {
                
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
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var createButton: some View {
        Button(action: {
            // Save the event into core data
            if selectedCategory != nil {
                
            } else {
               
            }
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



