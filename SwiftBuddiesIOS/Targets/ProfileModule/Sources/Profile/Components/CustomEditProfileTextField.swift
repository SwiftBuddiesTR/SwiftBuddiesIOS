//
//  CustomEditProfileTextField.swift
//  Buddies
//
//  Created by Fatih Özen on 13.01.2025.
//

import SwiftUI

struct CustomEditProfileTextField: View {
    
    enum textFieldType: String {
        case username = "Username"
        case linkedIn = "LinkedIn"
        case github = "Github"
    }
    
    var type: textFieldType
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text("\(type.rawValue):")
                .padding(.trailing, 5)
                .frame(minWidth: 80, alignment: .leading)
            Spacer()
            TextField(type.rawValue, text: $text)
                .modifier(BottomBorderModifier())
        }
        .padding(10)
    }
}
