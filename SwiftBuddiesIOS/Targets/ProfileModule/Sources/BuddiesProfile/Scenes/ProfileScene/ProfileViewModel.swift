//
//  BuddiesProfileViewModel.swift
//  Auth
//
//  Created by Fatih Özen on 31.01.2025.
//

import Foundation
import Network
import BuddiesNetwork

final class BuddiesProfileViewModel: ObservableObject {
    
    @Published private(set) var profileInfos: UserInfosResponse?
    private let apiClient: BuddiesClient!
    
    init(client: BuddiesClient = .shared) {
        self.apiClient = client
    }
    
    @MainActor
    func getProfileInfos() async {
        profileInfos = await fetchProfileInfos()
    }
    
    func fetchProfileInfos() async -> UserInfosResponse? {
        let request = GetUserInfosRequest()
        
        do {
            var latestData: UserInfosResponse?
            
            for try await data in apiClient.watch(request, cachePolicy: .returnCacheDataAndFetch) {
                latestData = data
            }
            
            return latestData
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
}

struct GetUserInfosRequest: Requestable {
    typealias Data = UserInfosResponse
    
    func httpProperties() -> HTTPOperation<GetUserInfosRequest>.HTTPProperties {
        .init(
            url: APIs.Profile.getUserInfo.url(),
            httpMethod: .get,
            data: self
        )
    }
}
