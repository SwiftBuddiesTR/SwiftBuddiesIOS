import SwiftUI

public protocol ContributorsModuleProtocol {
    associatedtype ContributorsViewType: View
    
    func makeContributorsView() -> ContributorsViewType
} 