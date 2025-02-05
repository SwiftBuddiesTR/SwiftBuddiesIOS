struct PaginationInfo {
    var limit: Int = 10
    var offset: Int = 0
    var hasMore: Bool = true
    var fetching: Bool = false
    
    mutating func reset() {
        offset = 0
        hasMore = true
        fetching = false
    }
    
    func checkLoadingMore() -> Bool {
        return hasMore && !fetching
    }
    
    mutating func nextOffset() {
        fetching = true
        offset += limit
    }
}
