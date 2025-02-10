//
//  SignInResponse.swift
//  Auth
//
//  Created by Berkay Tuncel on 11.08.2024.
//

import Foundation

public struct SignInResponse: Decodable, Equatable {
    public let type: String
    public let token: String
}
