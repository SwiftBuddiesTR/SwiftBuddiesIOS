//
//  BuddiesInterceptorProvider.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 14.09.2024.
//

import Foundation
import BuddiesNetwork

public final class BuddiesInterceptorProvider: InterceptorProvider {
    let client: URLSessionClient
    var cacheStore: any CacheStore
    
    public init(client: URLSessionClient,
                cacheStore: any CacheStore = URLCacheStore(), 
                currentToken: @escaping (() -> String?)) {
        self.client = client
        self.cacheStore = cacheStore
        self.currentToken = currentToken
    }
    
    public var currentToken: () -> String?
    
    public  func interceptors(for request: some Requestable) -> [Interceptor] {
        [
            MaxRetryInterceptor(maxRetry: 3),
            CacheReadInterceptor(store: cacheStore),
            BuddiesTokenProviderInterceptor(currentToken: currentToken),
            NetworkFetchInterceptor(client: client),
            JSONDecodingInterceptor(),
            CacheWriteInterceptor(store: cacheStore)
        ]
    }
    
    public func additionalErrorHandler(for request: some Requestable) -> (any ChainErrorHandler)? {
        AuthenticationErrorHandler()
    }
}

class AuthenticationErrorHandler: ChainErrorHandler {
    func handleError<Request>(
        error: any Error,
        chain: any RequestChain,
        request: HTTPRequest<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping (Result<Request.Data, any Error>) -> Void
    ) where Request: Requestable {
        if response?.httpResponse.statusCode == 401 {
            Task { @MainActor in
//                try await Authenticator.shared.logout()
                // TODO: Auto renew token request
                chain.cancel()
            }
        } else {
            completion(.failure(error))
        }
    }
}
 
public final class BuddiesRequestChainNetworkTransport {
    public static func getChainNetworkTransport(
        interceptorProvider: some InterceptorProvider
    ) -> any NetworkTransportProtocol {
        return DefaultRequestChainNetworkTransport(interceptorProvider: interceptorProvider)
    }
}

// MARK: - Token Interceptor provider
public final class BuddiesTokenProviderInterceptor: Interceptor {
    
    enum TokenProviderError: Error, LocalizedError {
        case tokenNotFound
        
        var errorDescription: String? {
            switch self {
            case .tokenNotFound: "Token is not found."
            }
        }
    }
    
    public var id: String = UUID().uuidString
    
    var currentToken: () -> String?
    
    public init(currentToken: @escaping () -> String?) {
        self.currentToken = currentToken
    }
    
    public func intercept<Request>(
        chain: RequestChain,
        request: HTTPRequest<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping (Result<Request.Data, Error>) -> Void
    ) where Request: Requestable {
        if let token = currentToken() {
            request.addHeader(key: "Authorization", val: "\(token)")
        }
        
        chain.proceed(
            request: request,
            interceptor: self,
            response: response,
            completion: completion
        )
    }
}
