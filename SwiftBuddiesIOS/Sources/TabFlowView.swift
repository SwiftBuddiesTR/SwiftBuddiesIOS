import SwiftUI
import Feed
import Map
import Contributors
import Profile
import Localization

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
                    L.tab_feed
                }
                .tag(AppTab.feed)
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    L.tab_map
                }
                .tag(AppTab.map)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    L.tab_profile
                }
                .tag(AppTab.profile)
            
            ContributorsView()
                .tabItem {
                    Image(systemName: "person.3")
                    L.tab_contributors
                }
                .tag(AppTab.contributors)
        }
    }
}

#Preview {
    TabFlowView()
}
