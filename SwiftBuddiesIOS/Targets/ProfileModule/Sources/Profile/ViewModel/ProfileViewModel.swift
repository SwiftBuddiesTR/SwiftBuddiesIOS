//
//  ProfileViewModel.swift
//  Auth
//
//  Created by Fatih Özen on 31.01.2025.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    private let profileService = ProfileService()
    
    @Published private(set) var profileInfos = UserInfos(registerType: "",
                                                         registerDate: "",
                                                         lastLoginDate: "",
                                                         email: "",
                                                         name: "",
                                                         username: "",
                                                         picture: "")
    
    @MainActor
    func getProfileInfos() async {
        profileInfos = await profileService.fetchProfileInfos() ?? UserInfos(
            registerType: "",
            registerDate: "",
            lastLoginDate: "",
            email: "",
            name: "",
            username: "",
            picture: ""
        )
    }
}
