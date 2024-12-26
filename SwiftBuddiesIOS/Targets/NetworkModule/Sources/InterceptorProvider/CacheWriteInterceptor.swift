//
//  CacheWriteInterceptor.swift
//  Network
//
//  Created by dogukaan on 26.12.2024.
//

import Foundation
import BuddiesNetwork

public protocol CacheStore {
    func write<Request: Requestable>(for request: HTTPRequest<Request>, response: HTTPResponse<Request>)
    func read<Request>(
        for request: HTTPRequest<Request>,
        chain: any RequestChain,
        completion: @escaping (
            Result<
            Request.Data,
            any Error
            >
        ) -> Void
    )
}

public class URLCacheStore: CacheStore {
    
    private var cache: URLCache
    
    public init(cache: URLCache = .shared) {
        self.cache = cache
    }
    
    public func write<Request>(for request: HTTPRequest<Request>, response: HTTPResponse<Request>) where Request : Requestable {
        let cachedURLResponse = CachedURLResponse(response: response.httpResponse, data: response.rawData)
        
        do {
            let urlRequest = try  request.rawRequest.toUrlRequest()
            cache.storeCachedResponse(cachedURLResponse, for: urlRequest)
        } catch {
            print("Error while storing cache: \(error)")
        }
    }
    
    public func read<Request>(for request: HTTPRequest<Request>, chain: any RequestChain, completion: @escaping (Result<Request.Data, any Error>) -> Void) where Request : Requestable {
        
        do {
            let urlRequest = try  request.rawRequest.toUrlRequest()
            cache.cachedResponse(for: urlRequest)
        } catch {
            print("Error while storing cache: \(error)")
        }
    }
}

final class CacheWriteInterceptor: Interceptor {
    enum CacheWriteError: String, LocalizedError {
        case noResponseToParse
        
        var errorDescription: String? { rawValue }
    }
    
    init(store: any CacheStore) {
        self.store = store
    }
    
    var id: String = "com.swiftbuddies.network.cachewriteinterceptor"
    var store: any CacheStore
    
    func intercept<Request>(
        chain: any RequestChain,
        request: HTTPRequest<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping (Result<Request.Data, any Error>) -> Void
    ) where Request : Requestable {
        guard !chain.isCancelled else {
            return
        }
        
        guard request.cachePolicy != .fetchIgnoringCacheCompletely else {
            // If we're ignoring the cache completely, we're not writing to it.
            chain.proceed(
                request: request,
                interceptor: self,
                response: response,
                completion: completion
            )
            return
        }
        
        guard let createdResponse = response else {
            chain.handleErrorAsync(
                CacheWriteError.noResponseToParse,
                request: request,
                response: response,
                completion: completion
            )
            return
        }
        
        self.store.write(for: request, response: createdResponse)
        
        chain.proceed(
            request: request,
            interceptor: self,
            response: createdResponse,
            completion: completion
        )
    }
    
        
}
