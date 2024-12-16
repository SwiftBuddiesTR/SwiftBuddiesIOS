import Foundation

struct ContributorStats: Codable {
    let login: String
    let id: Int
    let publicRepos: Int
    let followers: Int
    let following: Int
    let bio: String?
    let company: String?
    let location: String?
    let name: String?
    let blog: String?
    let avatarURL: String
    let htmlURL: String
    
    enum CodingKeys: String, CodingKey {
        case login, id, followers, following, bio, company, location, name, blog
        case publicRepos = "public_repos"
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
} 