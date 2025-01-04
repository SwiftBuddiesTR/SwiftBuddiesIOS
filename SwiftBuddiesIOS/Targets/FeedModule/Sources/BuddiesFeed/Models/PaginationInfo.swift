struct PaginationInfo {
    var totalCount: Int = 0
    var itemsPerPage: Int = 30
    var currentPage: Int = 0
    var isFetching: Bool = false
    
    var canLoadMore: Bool {
        !isFetching && (currentPage == 0 || totalCount >= (currentPage * itemsPerPage))
    }
    
    mutating func nextPage() {
        isFetching = true
        currentPage += 1
    }
    
    mutating func reset() {
        currentPage = 0
        totalCount = 0
        isFetching = false
    }
}