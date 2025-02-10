//
//  ProfileViewModel.swift
//  Auth
//
//  Created by Fatih Özen on 31.01.2025.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    private let profileService = ProfileService()
    @Published var profileInfos = UserInfos(registerType: "",
                                            registerDate: "",
                                            lastLoginDate: "",
                                            email: "",
                                            name: "",
                                            username: "",
                                            picture: "")
    
    @MainActor
    func getProfileInfos() async {
        profileInfos = await profileService.fetchEvents() ?? UserInfos(registerType: "",
                                                                       registerDate: "",
                                                                       lastLoginDate: "",
                                                                       email: "",
                                                                       name: "",
                                                                       username: "",
                                                                       picture: "")
    }
}
