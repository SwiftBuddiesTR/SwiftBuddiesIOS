import SwiftUI
import Design
import Localization

struct AboutView: View {
    var body: some View {
        HeaderParallaxView {
            VStack {
                Image("SwiftBuddiesHeader", bundle: DesignResources.bundle)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        } content: {
            VStack(alignment: .leading, spacing: 16) {
                L.about_title
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                L.about_paragraph1
                    .foregroundColor(.primary)
                
                L.about_paragraph2
                    .foregroundColor(.primary)
                
                L.about_paragraph3
                    .foregroundColor(.primary)
                
                L.about_welcome
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

#Preview {
    AboutView()
}
