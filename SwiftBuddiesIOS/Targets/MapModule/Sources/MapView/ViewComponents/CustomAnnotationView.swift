//
//  CustomAnnotationView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 2.07.2024.
//

import SwiftUI

struct AnnotationView: View {
    
    let color: Color
    var isSelected: Bool = false
    
    var body: some View {
       
        VStack{
            Image(systemName: "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(6)
                .background(color)
                .clipShape(.circle)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -11)
        }
        .scaleEffect(isSelected ? 1 : 0.8)

        //bu paddingi annotation yerleştirildiğinde konumu kapatmaması ve okun tam lokasyonnu göstermesi için kullandım
        .padding(.bottom)
    }
}

#Preview {
    AnnotationView(color: .red)
}
