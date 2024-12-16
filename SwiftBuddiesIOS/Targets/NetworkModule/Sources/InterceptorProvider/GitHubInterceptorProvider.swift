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
            JSONDecodingInterceptor()
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
        } else {
            completion(.failure(error))
        }
    }
} 