import Foundation
import BuddiesNetwork

public final class GitHubInterceptorProvider: InterceptorProvider {
    let client: URLSessionClient
    
    public init(client: URLSessionClient) {
        self.client = client
    }
    
    public func interceptors(for request: some Requestable) -> [Interceptor] {
        [
            MaxRetryInterceptor(maxRetry: 3),
            GitHubHeadersInterceptor(),
            NetworkFetchInterceptor(client: client),
            BuddiesJSONDecodingInterceptor()
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
        request: HTTPRequest<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping (Result<Request.Data, Error>) -> Void
    ) where Request: Requestable {
        // Add GitHub API specific headers
        request.addHeader(key: "Accept", val: "application/vnd.github.v3+json")
        
        chain.proceed(
            request: request,
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
        request: HTTPRequest<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping (Result<Request.Data, any Error>) -> Void
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
