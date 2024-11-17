//
//  BuddiesAuthenticationService.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 17.09.2024.
//

import Foundation
import Network
import BuddiesNetwork

// Sends the credentials from SSOs to the buddies backend
public final class BuddiesAuthenticationService {
    public static var shared: BuddiesAuthenticationService!
    
    private let notificationCenter: NotificationCenter
    private let apiClient: BuddiesClient
    
    public init(notificationCenter: NotificationCenter, apiClient: BuddiesClient) {
        self.notificationCenter = notificationCenter
        self.apiClient = apiClient
    }
    
    public func logout() async {
        await loginState()
    }
    
    public func registerUser(signInRequest: SignInRequest) async {
        let request = RegisterRequest(
            accessToken: signInRequest.accessToken,
            registerType: signInRequest.type
        )
        
        do {
            let data = try await apiClient.perform(request)
            let token = data.token
            let type = data.type
            debugPrint("token: \(token), \ntype: \(type)")
            await loginState(token: token)
        } catch {
            debugPrint(error)
            await loginState()
        }
    }
    
    public func checkIfLoggedIn() async {
        if let token = KeychainManager.shared.get(key: .accessToken) {
            await loginState(token: token)
        } else {
            await loginState()
        }
    }
    
    @MainActor
    private func loginState(token: String? = nil) async {
        if let token {
            KeychainManager.shared.save(key: .accessToken, value: token)
            notificationCenter.post(name: .didLoggedIn, object: nil)
        } else {
            KeychainManager.shared.delete(.accessToken)
            notificationCenter.post(name: .didLoggedOut, object: nil)
        }
    }
}

// MARK: - RegisterRequest
struct RegisterRequest: Requestable {
    var accessToken: String
    var registerType: String
    
    struct Data: Decodable {
        let token: String
        let type: String
    }
    
    func toUrlRequest() throws -> URLRequest {
        try URLProvider.returnUrlRequest(
            method: .post,
            url: APIs.Login.register.url(),
            data: self
        )
    }
}
