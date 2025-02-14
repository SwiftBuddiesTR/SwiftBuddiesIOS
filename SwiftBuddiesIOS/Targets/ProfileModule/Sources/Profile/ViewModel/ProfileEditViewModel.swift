//
//  ProfileEditViewModel.swift
//  Buddies
//
//  Created by Fatih Özen on 12.02.2025.
//

import Foundation

final class ProfileEditViewModel: ObservableObject {
    
    private let profileService = ProfileService()
    
    @Published var username: String = ""
    @Published var linkedinURL: String = ""
    @Published var githubURL: String = ""
    @Published private(set) var socialMessage: String = ""
    @Published private(set) var usernameMessage: String = ""
    
    private var profileInfos = UserInfosResponse(
        registerType: "",
        registerDate: "",
        lastLoginDate: "",
        email: "",
        name: "",
        username: "",
        picture: ""
    )
    
    @MainActor
    func getProfileInfos() async {
        profileInfos = await profileService.fetchProfileInfos() ?? UserInfosResponse(
            registerType: "",
            registerDate: "",
            lastLoginDate: "",
            email: "",
            name: "",
            username: "",
            picture: ""
        )
        
        username = profileInfos.username
        linkedinURL = profileInfos.linkedin ?? ""
        githubURL = profileInfos.github ?? ""
    }
    
    func saveProfile() async {
        await updateUsername()
        await updateSocialMediaURL()
    }
    
    @MainActor
    private func updateUsername() async {
        if !username.isEmpty && username != profileInfos.username {
            usernameMessage = await profileService.updateUsername(username: username)
        }
    }
    
    @MainActor
    private func updateSocialMediaURL() async {
        var socialMedias: [SocialMediaResponse] = []
        
        if !linkedinURL.isEmpty && linkedinURL != profileInfos.linkedin {
            socialMedias.append(SocialMediaResponse(key: "linkedin", value: linkedinURL))
        }
        
        if !githubURL.isEmpty && githubURL != profileInfos.github {
            socialMedias.append(SocialMediaResponse(key: "github", value: githubURL))
        }
        
        if !socialMedias.isEmpty {
            socialMessage = await profileService.updateSocialMedias(socialMedias: socialMedias)
        }
    }
}
