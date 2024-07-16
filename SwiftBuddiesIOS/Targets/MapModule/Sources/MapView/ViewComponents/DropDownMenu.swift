//
//  DropDownMenu.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 13.05.2024.
//

import SwiftUI

struct DropdownMenu: View {
    
    let prompt: String
    let options: [String]
    
    @State private var isShowing = false
    @Binding var selection: String?
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        VStack {
            HStack{
                Text(selection ?? prompt)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .rotationEffect(.degrees(isShowing ? -180 : 0))
            }
            .frame(height: 55)
            .background(
                Color(.secondarySystemBackground)
            )
            .padding(.horizontal)
            .bold()
            .onTapGesture {
                withAnimation(.easeInOut) {
                    isShowing.toggle()
                }
            }
            
            if isShowing {
                VStack{
                    ForEach(options, id: \.self) { option in
                        HStack{
                            Text(option)
                                .foregroundStyle(selection == option ? Color.primary : .gray)
                            
                            Spacer()
                            
                            if selection == option {
                                Image(systemName: "checkmark")
                                    .font(.subheadline)
                            }
                            
                        }
                        .frame(height: 40)
                        .padding(.horizontal)
                        .onTapGesture {
                            selection = option
                            withAnimation(.easeInOut) {
                                isShowing.toggle()
                            }
                            
                        }
                    }
                }
                
            }
               
        }
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


#Preview {
    DropdownMenu(prompt: "Select",
                 options: [
                    "option1",
                    "option2",
                    "option3"],
                 selection: .constant("option2")
    )
}

