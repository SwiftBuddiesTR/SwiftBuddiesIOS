import SwiftUI

struct ScrollPositionIndicator: View {
    let coordinateSpace: String
    let onReachBottom: () async -> Void
    
    @State private var isNearBottom = false
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named(coordinateSpace)).minY
                )
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    let threshold = UIScreen.main.bounds.height * 0.7
                    let isNearBottom = offset < threshold
                    
                    if isNearBottom && !self.isNearBottom {
                        Task {
                            await onReachBottom()
                        }
                    }
                    self.isNearBottom = isNearBottom
                }
        }
        .frame(height: 0)
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
} 