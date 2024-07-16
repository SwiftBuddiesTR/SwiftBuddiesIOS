//
//  CustomAnnotationView.swift
//  Map
//
//  Created by Oğuzhan Abuhanoğlu on 2.07.2024.
//

import SwiftUI

struct CustomAnnotationView: View {
    
    var body: some View {
       
        VStack{
            Image(systemName: "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.orange)
                .clipShape(.circle)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(Color.orange)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -11)
                
        }
        //bu paddingi annotation yerleştirildiğinde konumu kapatmaması ve okun tam lokasyonnu göstermesi için kullandım
        .padding(.bottom)
        
    }
}

#Preview {
    CustomAnnotationView()
}


struct RedAnnotationView: View {
    
    var body: some View {
       
        VStack{
            Image(systemName: "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.red)
                .clipShape(.circle)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -11)
                
        }
        //bu paddingi annotation yerleştirildiğinde konumu kapatmaması ve okun tam lokasyonnu göstermesi için kullandım
        .padding(.bottom)
        
    }
}

#Preview {
    RedAnnotationView()
}
