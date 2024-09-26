//
//  AddPostHeaderButtonsView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct AddPostHeaderButtonsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
            }
            Spacer()
            Button {
                print("safe button pressed")
            } label: {
                Text("Post")
                    .font(.title2)
                    .fontWeight(.regular)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .foregroundColor(.cyan)
    }
}

#Preview {
    AddPostHeaderButtonsView()
}
