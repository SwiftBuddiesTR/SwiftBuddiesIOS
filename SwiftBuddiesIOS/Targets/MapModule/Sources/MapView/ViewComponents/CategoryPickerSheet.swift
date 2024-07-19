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

    @Binding var selectedCategory: String
    
    private let categories = EventCategory.allCases.map { $0.rawValue }
    
    var selectAction: () -> Void
    
    var body: some View {
        NavigationView {
            List {
            
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text(category)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Select Category")
            .navigationBarItems(trailing: Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
