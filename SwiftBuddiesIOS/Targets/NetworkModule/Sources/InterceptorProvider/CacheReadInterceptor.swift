//
//  CacheReadInterceptor.swift
//  Network
//
//  Created by dogukaan on 26.12.2024.
//

import Foundation
import BuddiesNetwork


final class CacheReadInterceptor: Interceptor {
    
    var id: String = "com.swiftbuddies.cache-read-interceptor"
    
    init(store: any CacheStore) {
        self.store = store
    }
    
    var store: any CacheStore
    
    func fetchFromCache<Request>(
        for request: HTTPRequest<Request>,
        chain: any RequestChain,
        completion: @escaping (
            Result<
            Request.Data,
            any Error
            >
        ) -> Void
    ) where Request: Requestable {
        store.read(for: request, chain: chain, completion: completion)
    }
    
    func intercept<Request>(
        chain: any RequestChain,
        request: HTTPRequest<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping (Result<Request.Data, any Error>) -> Void
    ) where Request : Requestable {
        
        // request == .get else continue with the chain
        
        switch request.cachePolicy {
        case .fetchIgnoringCacheCompletely,
                .fetchIgnoringCacheData:
            chain.proceed(
                request: request,
                interceptor: self,
                response: response,
                completion: completion
            )
            
        case .returnCacheDataAndFetch:
                        self.fetchFromCache(for: request, chain: chain) { cacheFetchResult in
                            switch cacheFetchResult {
                            case .failure:
                                // Don't return a cache miss error, just keep going
                                break
                            case .success(let graphQLResult):
                                chain.returnValue(
                                    for: request,
                                    value: graphQLResult,
                                    completion: completion
                                )
                            }
            
                            // In either case, keep going asynchronously
                            chain.proceed(
                                request: request,
                                interceptor: self,
                                response: response,
                                completion: completion
                            )
                        }
        case .returnCacheDataElseFetch:
                        self.fetchFromCache(for: request, chain: chain) { cacheFetchResult in
                            switch cacheFetchResult {
                            case .failure:
                                // Cache miss, proceed to network without returning error
                                chain.proceed(
                                    request: request,
                                    interceptor: self,
                                    response: response,
                                    completion: completion
                                )
            
                            case .success(let graphQLResult):
                                // Cache hit! We're done.
                                chain.returnValue(
                                    for: request,
                                    value: graphQLResult,
                                    completion: completion
                                )
                            }
                        }
        case .returnCacheDataDontFetch:
                        self.fetchFromCache(for: request, chain: chain) { cacheFetchResult in
                            switch cacheFetchResult {
                            case .failure(let error):
                                // Cache miss - don't hit the network, just return the error.
                                chain.handleErrorAsync(
                                    error,
                                    request: request,
                                    response: response,
                                    completion: completion
                                )
            
                            case .success(let result):
                                chain.returnValue(
                                    for: request,
                                    value: result,
                                    completion: completion
                                )
                            }
                        }
        }
    }
}
