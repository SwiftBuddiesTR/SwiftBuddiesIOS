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
        for operation: HTTPOperation<Request>,
        chain: any RequestChain,
        completion: @escaping (Result<Request.Data, any Error>) -> Void
    ) where Request: Requestable {
        store.read(for: operation, chain: chain, completion: completion)
    }
    
    func intercept<Request>(
        chain: any RequestChain,
        operation: HTTPOperation<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping HTTPResultHandler<Request>
    ) where Request : Requestable {
        
        // request == .get else continue with the chain
        
        switch operation.cachePolicy {
        case .fetchIgnoringCacheCompletely,
                .fetchIgnoringCacheData:
            chain.proceed(
                operation: operation,
                interceptor: self,
                response: response,
                completion: completion
            )
            
        case .returnCacheDataAndFetch:
                        self.fetchFromCache(for: operation, chain: chain) { cacheFetchResult in
                            switch cacheFetchResult {
                            case .failure:
                                // Don't return a cache miss error, just keep going
                                break
                            case .success(let decodedData):
                                let result = HTTPResult<Request>(source: .cache, data: decodedData)
                                chain.returnValue(
                                    for: operation,
                                    result: result,
                                    completion: completion
                                )
                            }
            
                            // In either case, keep going asynchronously
                            chain.proceed(
                                operation: operation,
                                interceptor: self,
                                response: response,
                                completion: completion
                            )
                        }
        case .returnCacheDataElseFetch:
                        self.fetchFromCache(for: operation, chain: chain) { cacheFetchResult in
                            switch cacheFetchResult {
                            case .failure:
                                // Cache miss, proceed to network without returning error
                                chain.proceed(
                                    operation: operation,
                                    interceptor: self,
                                    response: response,
                                    completion: completion
                                )
            
                            case .success(let decodedData):
                                // Cache hit! We're done.
                                let result = HTTPResult<Request>(source: .cache, data: decodedData)
                                chain.returnValue(
                                    for: operation,
                                    result: result,
                                    completion: completion
                                )
                            }
                        }
        case .returnCacheDataDontFetch:
                        self.fetchFromCache(for: operation, chain: chain) { cacheFetchResult in
                            switch cacheFetchResult {
                            case .failure(let error):
                                // Cache miss - don't hit the network, just return the error.
                                chain.handleErrorAsync(
                                    error,
                                   operation: operation,
                                    response: response,
                                    completion: completion
                                )
            
                            case .success(let decodedData):
                                let result = HTTPResult<Request>(source: .cache, data: decodedData)
                                chain.returnValue(
                                    for: operation,
                                    result: result,
                                    completion: completion
                                )
                            }
                        }
        }
    }
}
