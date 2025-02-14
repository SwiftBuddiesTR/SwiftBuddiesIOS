//
//  UserInfos.swift
//  Auth
//
//  Created by Fatih Özen on 3.02.2025.
//

import Foundation

struct UserInfosResponse: Codable {
    var registerType: String
    var registerDate: String
    var lastLoginDate: String
    var email: String
    var name: String
    var username: String
    var picture: String
    var linkedin: String?
    var github: String?
}
