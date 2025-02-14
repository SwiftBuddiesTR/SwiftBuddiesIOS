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
    
    func updateUsername(username: String) async -> String {
        let request = UpdateUsernameRequest(username: username)
        
        do {
            let data = try await apiClient.perform(request)
            return data.message ?? ""
        } catch {
            debugPrint(error)
            return error.localizedDescription
        }
    }
    
    func updateSocialMedias(socialMedias: [SocialMediaResponse]) async -> String {
        let request = UpdateSocialMediasRequest(socialMedias: socialMedias)
        
        do {
            let data = try await apiClient.perform(request)
            return data.message ?? ""
        } catch {
            debugPrint(error)
            return error.localizedDescription
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

struct UpdateUsernameRequest: Requestable {
    let username: String
    
    struct Data: Decodable {
        let message: String?
        let data: UsernameResponse?
    }
    
    func httpProperties() -> HTTPOperation<UpdateUsernameRequest>.HTTPProperties {
        .init(
            url: APIs.Profile.updateUsername.url(),
            httpMethod: .put,
            data: self
        )
    }
}

struct UpdateSocialMediasRequest: Requestable {
    let socialMedias: [SocialMediaResponse]
    
    struct Data: Decodable {
        let message: String?
        let data: [SocialMediaResponse]?
    }
    
    func httpProperties() -> HTTPOperation<UpdateSocialMediasRequest>.HTTPProperties {
        .init(
            url: APIs.Profile.updateSocialMedias.url(),
            httpMethod: .put,
            data: self
        )
    }
}
