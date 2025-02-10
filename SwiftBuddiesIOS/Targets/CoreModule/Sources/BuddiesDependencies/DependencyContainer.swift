//
//  DependencyContainer.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 26.09.2024.
//

import SwiftUI
import Auth
import Network
//import Core

@preconcurrency public final class DependencyContainer: DependencyContainerProtocol {
    enum Error: String, LocalizedError {
        case productNotFound
        
        var errorDescription: String { rawValue }
    }
    
    
    public static var shared: DependencyContainer = .init()
    
    let buddiesNetwork = DependencyKey<BuddiesClient>()
    let buddiesAuthenticator = DependencyKey<BuddiesAuthenticationService>()
    let authManager = DependencyKey<AuthenticationManager>()
    
    private init() { }
    
    private var builtDependencies: [String: Any] = [:]
    
    private func register<Product>(_ value: Product) {
        let name = String(reflecting: value)
        builtDependencies[name] = value
    }
    
    public func get<Product>(_ dependencyKey: DependencyKey<Product>) throws -> Product {
        guard let product = builtDependencies[dependencyKey.name] as? Product else {
            throw Error.productNotFound
        }
        return product
    }
    
    @MainActor
    public func build() {
        let accessToken: (() -> String?) = {
            KeychainManager.shared.get(key: .accessToken)
        }
        
        let buddiesInterceptorProvider = BuddiesInterceptorProvider(
            client: .init(
                sessionConfiguration: .default
            ),
            currentToken: accessToken
        )
        
        let buddiesChainNetworkTransport = BuddiesRequestChainNetworkTransport.getChainNetworkTransport(
            interceptorProvider: buddiesInterceptorProvider
        )
        
        let buddiesClient = BuddiesClient(
            networkTransporter: buddiesChainNetworkTransport
        )
        register(buddiesClient)
        BuddiesClient.shared = buddiesClient
        
        let buddiesAuthService = BuddiesAuthenticationService(
            notificationCenter: .default,
            apiClient: .shared
        )
        register(buddiesAuthService)
        BuddiesAuthenticationService.shared = buddiesAuthService
        
        let authenticationManager = AuthenticationManager(authService: BuddiesAuthenticationService.shared)
        AuthenticationManager.shared = authenticationManager
        register(authenticationManager)
    }
}
