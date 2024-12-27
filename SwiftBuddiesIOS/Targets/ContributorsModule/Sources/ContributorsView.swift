import SwiftUI
import Design

public struct ContributorsView: View {
    private let module: GitHubContributorsModule
    
    public init() {
        self.module = GitHubContributorsModule()
    }
    
    public var body: some View {
        GitHubContributorsFlow(module: module)
    }
}

#Preview {
    ContributorsView()
}
