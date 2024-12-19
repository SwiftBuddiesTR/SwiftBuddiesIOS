
// MARK: - FeedResponse
struct FeedResponse {
    var feed: [Feed]
}

// MARK: - Feed
struct Feed {
    var user: FeedUser
    var post: FeedPost
}

// MARK: - Post
struct FeedPost {
    var uid: String
    var sharedDate: String
    var content: String
    var images: [Any?]
    var likeCount: Int
    var isLiked: Bool
    var likers: [Liker]
    var commentCount: Int
    var hashtags: [String]
}

// MARK: - Liker
struct FeedLiker {
    var name: String
    var picture: String
    var uid: String
    var isSelf: Bool
}

// MARK: - User
struct FeedUser {
    var name: String
    var picture: String
}
