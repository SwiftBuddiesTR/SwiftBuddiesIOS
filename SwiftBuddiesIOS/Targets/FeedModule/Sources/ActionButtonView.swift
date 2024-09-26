//
//  ActionButtonView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI
import Design

struct ActionButtonView: View {
    
    @State private var isLiked = false
    @State private var showComments = false
    @State private var isSaved = false
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                isLiked.toggle()
            } label: {
                Text("Like")
            }
            .buttonStyle(.like(isLiked))
            Spacer()
            
            Button {
                showComments.toggle()
            } label: {
                Text("Comments")
            }
            .buttonStyle(.comment)
            Spacer()

            Button {
                isSaved.toggle()
            } label: {
                Text("Save")
            }
            .buttonStyle(.save(isSaved))
            
            Button {
                
            } label: {
                
            }
            .buttonStyle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Button Style@*/DefaultButtonStyle()/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        .padding(.top, 4)
        .padding([.bottom, .horizontal], 10)
        .foregroundColor(.gray)
    }
}

//#Preview {
//    ActionButtonView()
//}
