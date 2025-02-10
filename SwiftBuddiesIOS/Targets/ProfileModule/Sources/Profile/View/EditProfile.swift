//
//  EditProfile.swift
//  Buddies
//
//  Created by Fatih Özen on 13.01.2025.
//

import SwiftUI

struct EditProfile: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedImage: UIImage?
    @State private var name: String = ""
    @State private var jobTitle: String = ""
    @State private var linkedin: String = ""
    @State private var github: String = ""
    @State private var cvUrl: URL?
    
    @State private var isPhotoPickerPresented = false
    @State private var isPdfPickerPresented = false
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            VStack {
                Button {
                    isPhotoPickerPresented = true
                } label: {
                    Group {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                        }
                    }
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.cyan)
                    .clipShape(Circle())
                }
                
                Spacer()
                    .frame(height: size.height / 14)
                
                VStack(spacing: 15) {
                    CustomEditProfileTextField(type: .name, text: $name)
                    CustomEditProfileTextField(type: .title, text: $jobTitle)
                    CustomEditProfileTextField(type: .linkedIn, text: $linkedin)
                    CustomEditProfileTextField(type: .github, text: $github)
                    
//                    HStack {
//                        Text("CV:")
//                            .padding(.trailing, 5)
//                            .frame(minWidth: 80, alignment: .leading)
//                        Spacer()
//                        Button {
//                            isPdfPickerPresented = true
//                        } label: {
//                            Group {
//                                if let cvUrl = cvUrl {
//                                    Image(systemName: "doc.on.doc.fill")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 30, height: 30)
//                                    Text(cvUrl.lastPathComponent)
//                                        .frame(width: 60, height: 20)
//                                } else {
//                                    Image(systemName: "doc.badge.plus")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 30, height: 30)
//                                }
//                            }
//                            .foregroundStyle(.cyan)
//                            
//                            Spacer()
//                        }
//                    }
//                    .padding(10)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Save")
                        .frame(width: size.width / 1.2, height: 60)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .contentShape(RoundedRectangle(cornerRadius: 15))
                
                
                Spacer()
                    .frame(height: 20)
            }
            .padding([.top], 25)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit Profile")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color.dynamicColor)
                    }
                }
            }
            .sheet(isPresented: $isPhotoPickerPresented) {
                PhotoPicker(selectedImage: $selectedImage)
            }
            .fullScreenCover(isPresented: $isPdfPickerPresented) {
                PDFPicker(selectedPDFURL: $cvUrl)
            }
            
        }
    }
}

extension Color {
    static var dynamicColor: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        })
    }
    
    static var dynamicBackgroundColor: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        })
    }
}
