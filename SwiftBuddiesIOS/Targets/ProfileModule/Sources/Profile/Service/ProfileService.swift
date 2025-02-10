//
//  ProfileService.swift
//  Auth
//
//  Created by Fatih Özen on 3.02.2025.
//

import Foundation
import BuddiesNetwork
import Network

final class ProfileService {
    private let apiClient: BuddiesClient!
    
    init() {
        self.apiClient = .shared
    }
    
    func fetchEvents() async -> UserInfos? {
        let request = GetUserInfosRequest()
        
        do {
            let data = try await apiClient.perform(request)
            return data
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
}

struct GetUserInfosRequest: Requestable {
    typealias Data = UserInfos
    
    func httpProperties() -> HTTPOperation<GetUserInfosRequest>.HTTPProperties {
        .init(
            url: APIs.Profile.getUserInfo.url(),
            httpMethod: .get,
            data: self
        )
    }
}
