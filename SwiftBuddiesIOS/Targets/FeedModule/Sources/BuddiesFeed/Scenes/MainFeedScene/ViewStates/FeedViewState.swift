//
//  FeedViewState.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 2.03.2025.
//

import Foundation

// MARK: - Feed States
/// Feed state
/// - idle: No content
/// - loading: Loading content
/// - error: Error state
/// - loaded: Content loaded
enum FeedState: Equatable {
    case idle
    /// Loading content
    /// - Parameter LoadingType: Loading type
    /// - initial: Initial loading
    /// - nextPage: Loading next page
    /// - refresh: Refreshing content
    case loading(LoadingType)
    case error(FeedError)
    case loaded(hasMore: Bool)
    
    /// Loading type
    /// - initial: Initial loading
    /// - nextPage: Loading next page
    /// - refresh: Refreshing content
    enum LoadingType: Equatable {
        case initial
        case nextPage
        case refresh
    }
    
    /// FeedError
    /// - network(String): Network error
    ///     - Parameter message: Error message
    /// - parsing: Parsing error
    /// - unknown: Unknown error
    enum FeedError: LocalizedError, Equatable {
        case network(String)
        case parsing
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .network(let message):
                return "Network Error: \(message)"
            case .parsing:
                return "Failed to parse feed data"
            case .unknown:
                return "An unknown error occurred"
            }
        }
    }
}
