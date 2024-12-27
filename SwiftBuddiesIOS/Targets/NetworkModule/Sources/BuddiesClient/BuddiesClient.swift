//
//  BuddiesClient.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 14.09.2024.
//

import Foundation
import BuddiesNetwork


final public class BuddiesClient {
    private let apiClient: APIClient
    
    public static var shared: BuddiesClient!
    
    public init(networkTransporter: NetworkTransportProtocol) {
        apiClient = .init(networkTransporter: networkTransporter)
    }
    
    @discardableResult
    public func perform<Request: Requestable>(
        _ request: Request,
        dispatchQueue: DispatchQueue = .main,
        cachePolicy: CachePolicy = .returnCacheDataAndFetch,
        completion: @escaping HTTPResultHandler<Request>
    ) -> (any Cancellable)? {
        apiClient.perform(
            request,
            dispatchQueue: dispatchQueue,
            cachePolicy: cachePolicy,
            completion: completion
        )
    }
    
    public func watch<Request: Requestable>(
        _ request: Request,
        cachePolicy: CachePolicy = .returnCacheDataAndFetch,
        dispatchQueue: DispatchQueue = .main
    ) -> AsyncThrowingStream<Request.Data, Error> {
        AsyncThrowingStream { continuation in
            let task = perform(
                request,
                dispatchQueue: dispatchQueue,
                cachePolicy: cachePolicy) { result in
                    switch result {
                    case .success(let httpResult):
                        continuation.yield(httpResult.data)
                        
                        if httpResult.isFinalForCachePolicy(policy: cachePolicy) {
                            continuation.finish()
                        }
                    case .failure(let error):
                        continuation.finish(throwing: error)
                    }
                }
            
            continuation.onTermination = { @Sendable termination in
                task?.cancel()
            }
        }
    }
    
    @discardableResult
    public func perform<Request: Requestable>(
        _ request: Request,
        cachePolicy: CachePolicy = .returnCacheDataElseFetch,
        dispatchQueue: DispatchQueue = .main
    ) async throws -> Request.Data {
        try await apiClient.perform(request, cachePolicy: cachePolicy, dispatchQueue: dispatchQueue)
    }
}

extension HTTPResult {
    func isFinalForCachePolicy(policy: CachePolicy) -> Bool {
        switch policy {
        case .returnCacheDataElseFetch:
            return true
        case .fetchIgnoringCacheData:
            return source == .server
        case .fetchIgnoringCacheCompletely:
            return source == .server
        case .returnCacheDataDontFetch:
            return source == .cache
        case .returnCacheDataAndFetch:
            return source == .server
        }
    }
}
