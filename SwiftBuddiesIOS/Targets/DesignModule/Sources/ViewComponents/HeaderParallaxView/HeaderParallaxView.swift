//
//  HeaderParallaxView.swift
//  SwiftBuddiesMain
//
//  Created by dogukaan on 21.01.2024.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SwiftUI

public struct HeaderParallaxView<HeaderView: View, Content: View>: View {
    @State private var imageHeight: CGFloat = .zero

    var headerView: () -> HeaderView
    var content: () -> Content
    
    public init(@ViewBuilder headerView: @escaping () -> HeaderView, @ViewBuilder content: @escaping () -> Content) {
        self.headerView = headerView
        self.content = content
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                headerView()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }
            .frame(height: 300)
            content()
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }

}

extension View {
    func getMainRect() -> CGRect {
        UIScreen.main.bounds
    }
}
#Preview {
    HeaderParallaxView {
        Image(systemName: "house")
            .resizable()
    } content: {
        Text("content")
    }
}
