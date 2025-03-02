//
//  ProfileEditViewModel.swift
//  Buddies
//
//  Created by Fatih Özen on 12.02.2025.
//

import Foundation
import Network
import BuddiesNetwork

final class ProfileEditViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var linkedinURL: String = ""
    @Published var githubURL: String = ""
    @Published private(set) var socialMessage: String = ""
    @Published private(set) var usernameMessage: String = ""
    private let apiClient: BuddiesClient!
    
    init(client: BuddiesClient = .shared) {
        self.apiClient = client
    }
    
    private var profileInfos: UserInfosResponse?
    
    @MainActor
    func getProfileInfos() async {
        profileInfos = await fetchProfileInfos()
        
        username = profileInfos?.username ?? ""
        linkedinURL = profileInfos?.linkedin ?? ""
        githubURL = profileInfos?.github ?? ""
    }
    
    func saveProfile() async {
        await updateUsername()
        await updateSocialMediaURL()
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
    
    
    @MainActor
    private func updateUsername() async {
        if !username.isEmpty,
            username != profileInfos?.username {
            usernameMessage = await updateUsername(username: username)
        }
    }
    
    @MainActor
    private func updateSocialMediaURL() async {
        var socialMedias: [SocialMediaResponse] = []
        
        if linkedinURL != profileInfos?.linkedin {
            socialMedias.append(
                SocialMediaResponse(
                    key: "linkedin",
                    value: linkedinURL
                )
            )
        }
        
        if githubURL != profileInfos?.github {
            socialMedias.append(
                SocialMediaResponse(
                    key: "github",
                    value: githubURL
                )
            )
        }
        
//        if !socialMedias.isEmpty {
//            socialMessage = await profileService.updateSocialMedias(socialMedias: socialMedias)
//        }
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
