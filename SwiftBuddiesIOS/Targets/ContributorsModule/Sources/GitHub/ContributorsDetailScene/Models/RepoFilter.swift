import Foundation

struct RepoFilter: Identifiable, Hashable {
    let id: String
    let name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.id = name // Using repo name as id since it's unique in the context
        self.name = name
        self.isSelected = isSelected
    }
} 