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
    
    @MainActor
    func getProfileInfos() async {
        let profileInfos = await profileService.fetchProfileInfos() ?? UserInfos(
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
    }
    
    private func updateUsername() async {
        await profileService.updateUsername(username: username)
    }
    
    private func updateSocialMediaURL() async {
        await profileService.updateSocialMedias(linkedin: linkedinURL, github: githubURL)
    }
}
