//
//  CacheWriteInterceptor.swift
//  Network
//
//  Created by dogukaan on 26.12.2024.
//

import Foundation
import BuddiesNetwork

public protocol CacheStore {
    func write<Request: Requestable>(
        for operation: HTTPOperation<Request>,
        response: HTTPResponse<Request>
    )
    func read<Request>(
        for operation: HTTPOperation<Request>,
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
    enum CacheStoreError: String, LocalizedError {
        case noResponseToParse
        
        var errorDescription: String? { rawValue }
    }

    
    private var cache: URLCache
    private var jsonDecoder: JSONDecoder = JSONDecoder()
    
    public init(cache: URLCache = .shared) {
        self.cache = cache
    }
    
    public func write<Request>(for operation: HTTPOperation<Request>, response: HTTPResponse<Request>) where Request : Requestable {
        let cachedURLResponse = CachedURLResponse(response: response.httpResponse, data: response.rawData)
        
        do {
            let urlRequest = try  URLProvider.urlRequest(from: operation.properties)
            cache.storeCachedResponse(cachedURLResponse, for: urlRequest)
        } catch {
            print("Error while storing cache: \(error)")
        }
    }
    
    public func read<Request>(for operation: HTTPOperation<Request>, chain: any RequestChain, completion: @escaping (Result<Request.Data, any Error>) -> Void) where Request : Requestable {
        
        do {
            let urlRequest = try  URLProvider.urlRequest(from: operation.properties)
            if let data = cache.cachedResponse(for: urlRequest) {
                let decodedData = try jsonDecoder.decode(Request.Data.self, from: data.data)
                completion(.success(decodedData))
            } else {
                completion(.failure(CacheStoreError.noResponseToParse))
            }
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
        operation: HTTPOperation<Request>,
        response: HTTPResponse<Request>?,
        completion: @escaping HTTPResultHandler<Request>
    ) where Request : Requestable {
        guard !chain.isCancelled else {
            return
        }
        
        guard operation.cachePolicy != .fetchIgnoringCacheCompletely else {
            // If we're ignoring the cache completely, we're not writing to it.
            chain.proceed(
                operation: operation,
                interceptor: self,
                response: response,
                completion: completion
            )
            return
        }
        
        guard let createdResponse = response else {
            chain.handleErrorAsync(
                CacheWriteError.noResponseToParse,
                operation: operation,
                response: response,
                completion: completion
            )
            return
        }
        
        self.store.write(for: operation, response: createdResponse)
        
        chain.proceed(
            operation: operation,
            interceptor: self,
            response: createdResponse,
            completion: completion
        )
    }
    
        
}
