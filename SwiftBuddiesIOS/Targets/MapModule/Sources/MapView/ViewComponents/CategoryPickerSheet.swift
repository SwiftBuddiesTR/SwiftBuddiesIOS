//
//  CategoryPickerSheet.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 5.06.2024.
//

import SwiftUI
import SwiftData

struct CategoryPicker: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mapVM: MapViewModel

    @Binding var selectedCategory: String
    @StateObject var vm = MapViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(mapVM.categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text(category)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Select Category")
            .navigationBarItems(trailing: backButton)
            
        }
    }
}

// MARK: COMPONENTS
extension CategoryPicker {
    
    private var backButton: some View{
        Button(action: {
            //dismiss sheet
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .shadow(radius: 7)
                
        }
        .padding(.top, 20)
    }
}
