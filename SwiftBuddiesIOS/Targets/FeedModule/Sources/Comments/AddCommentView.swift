//
//  AddCommentView.swift
//  Feed
//
//  Created by Kate Kashko on 15.04.2024.
//  Copyright © 2024 SwiftBuddies. All rights reserved.
//

import SwiftUI

struct AddCommentView: View {
    @State private var comment: String = ""
    
    var body: some View {
        HStack{
            TextField("Add commment", text: $comment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button{
                print("Send comment")
            } label: {
                Image(systemName: "paperplane")
                    .imageScale(.medium)
            }
        }
        .padding(20)
    }
}

#Preview {
    AddCommentView()
}
