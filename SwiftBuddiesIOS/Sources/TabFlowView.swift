import SwiftUI
import Feed
import Map
import Profile
import Contributors

enum AppTab: Int, Identifiable {
    case feed = 0
    case map
    case profile
    case contributors
    
    var id: Int { rawValue }
}

struct TabFlowView: View {
    @State var selectedTab: AppTab = .feed
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Feed")
                }
                .tag(AppTab.feed)
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(AppTab.map)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(AppTab.profile)
            
            ContributorsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Contributors")
                }
                .tag(AppTab.contributors)
        }
    }
}

#Preview {
    TabFlowView()
}
