import Foundation
import BuddiesNetwork

public final class GitHubInterceptorProvider: InterceptorProvider {
    
    let client: URLSessionClient
    let cacheStore: URLCacheStore
    public init(client: URLSessionClient, cacheStore: URLCacheStore = .init()) {
        self.cacheStore = cacheStore
        self.client = client
    }
    
    public func interceptors<Request: Requestable>(for operation: HTTPOperation<Request>) -> [Interceptor] {
        [
            MaxRetryInterceptor(maxRetry: 3),
            CacheReadInterceptor(store: cacheStore),
            GitHubHeadersInterceptor(),
            NetworkFetchInterceptor(client: client),
            BuddiesJSONDecodingInterceptor(),
            CacheWriteInterceptor(store: cacheStore)
        ]
    }
    
    public func additionalErrorHandler(for request: some Requestable) -> (any ChainErrorHandler)? {
        GitHubErrorHandler()
    }
}

final class GitHubHeadersInterceptor: Interceptor {
    public var id: String = UUID().uuidString
    
    public func intercept<Request>(
        chain: RequestChain,
        operation: HTTPOperation<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping HTTPResultHandler<Request>
    ) where Request: Requestable {
        // Add GitHub API specific headers
        operation.addHeader(key: "Accept", val: "application/vnd.github.v3+json")
        
        chain.proceed(
            operation: operation,
            interceptor: self,
            response: response,
            completion: completion
        )
    }
}

final class GitHubErrorHandler: ChainErrorHandler {
    func handleError<Request>(
        error: any Error,
        chain: any RequestChain,
        operation: HTTPOperation<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping HTTPResultHandler<Request>
    ) where Request: Requestable {
        if response?.httpResponse.statusCode == 403 {
            // Handle rate limiting
            completion(.failure(GitHubAPIError.rateLimitExceeded))
        } else if response?.httpResponse.statusCode == 404 {
            completion(.failure(GitHubAPIError.repositoryNotFound))
        } else if response?.httpResponse.statusCode == 304 {
            completion(.failure(GitHubAPIError.notModified))
        } else {
            completion(.failure(error))
        }
    }
} 

// GitHubAPIError
public enum GitHubAPIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case rateLimitExceeded
    case repositoryNotFound
    case notModified
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .rateLimitExceeded:
            return "GitHub API rate limit exceeded. Please try again later."
        case .repositoryNotFound:
            return "Repository not found"
        case .notModified:
            return "Not modified"
        }
    }
}
