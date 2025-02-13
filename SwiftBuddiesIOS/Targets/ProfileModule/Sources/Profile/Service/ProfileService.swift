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
    
    func fetchProfileInfos() async -> UserInfos? {
        let request = GetUserInfosRequest()
        
        do {
            let data = try await apiClient.perform(request)
            return data
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    func updateUsername(username: String) async {
        let request = UpdateUsernameRequest(username: username)
        
        do {
            let data = try await apiClient.perform(request)
            print(data)
        } catch {
            debugPrint(error)
        }
    }
    
    func updateSocialMedias(linkedin: String, github: String) async {
        let request = UpdateSocialMediasRequest(linkedin: linkedin, github: github)
        
        do {
            let data = try await apiClient.perform(request)
            print(data)
        } catch {
            debugPrint(error)
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

struct UpdateUsernameRequest: Requestable {
    let username: String
    
    typealias Data = UserInfos
    
    func httpProperties() -> HTTPOperation<UpdateUsernameRequest>.HTTPProperties {
        .init(
            url: APIs.Profile.updateUsername.url(),
            httpMethod: .put,
            data: self
        )
    }
}

struct UpdateSocialMediasRequest: Requestable {
    let linkedin: String?
    let github: String?
    
    struct Data: Decodable {
        let message: String?
        let socialMedias: [String: String]?
    }
    
    func httpProperties() -> HTTPOperation<UpdateSocialMediasRequest>.HTTPProperties {
        .init(
            url: APIs.Profile.updateSocialMedias.url(),
            httpMethod: .put,
            data: self
        )
    }
}
