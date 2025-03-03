//
//  ColorPickers.swift
//  Design
//
//  Created by dogukaan on 3.03.2025.
//

import SwiftUI

struct DesignColorPicker: View {
    
    @Binding var color: Color
    
    @State private var selectedColor: DesignColors = DesignAsset.Colors.white
    
    private let colorOptions: [DesignColors] = [
        DesignAsset.Colors.white,
        DesignAsset.Colors.black,
        DesignAsset.Colors.fulvous,
        DesignAsset.Colors.cyan,
        DesignAsset.Colors.olive,
        DesignAsset.Colors.beaver
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<colorOptions.count, id: \.self) { index in
                    Button {
                        selectedColor = colorOptions[index]
                        color = selectedColor.swiftUIColor
                    } label: {
                        VStack {
                            Circle()
                                .fill(colorOptions[index].swiftUIColor)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor.name == colorOptions[index].name ? Color.primary : Color.clear, lineWidth: 2)
                                )
                            Text(colorOptions[index].name)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    DesignColorPicker(color: .constant(.red))
}
