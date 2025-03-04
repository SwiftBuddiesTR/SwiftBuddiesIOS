//
//  EndpointManager.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 14.09.2024.
//

import Foundation

// APIs.Map.getEvents.url(),

public enum APIs {
    /// if you need to add a new endpoint see the example below
    public enum Login: Endpoint {
        case register
        
        public var value: String {
            switch self {
            case .register: 
                "register"
            }
        }
    }
    
    public enum Feed: Endpoint {
        case getFeed
        case createPost
        case uploadImage
        case getImage
        
        public var value: String {
            switch self {
            case .getFeed: 
                "getFeed"
            case .createPost:
                "createPost"
            case .uploadImage:
                "uploadImage"
            case .getImage:
                "getImage"
            }
        }
    }
    
    public enum Map: Endpoint {
        case getEvents
        case createEvent
        
        public var value: String {
            switch self {
            case .getEvents:
                "getEvents"
            case .createEvent:
                "createEvent"
            }
        }
    }
    
    public enum Profile: Endpoint {
        case getUserInfo
        case updateUsername
        case updateSocialMedias
        
        public var value: String {
            switch self {
            case .getUserInfo:
                "whoAmI"
            case .updateSocialMedias:
                "updateSocialMedias"
            case .updateUsername:
                "updateUsername"
            }
        }
    }
    
    public enum GitHub: Endpoint {
        case contributors
        case userStats(username: String?)
        case userActivities(username: String?)
        case userEvents(username: String?)
        case userRepos(username: String?)
        
        public var value: String {
            switch self {
            case .contributors:
                "repos/SwiftBuddiesTR/BuddiesIOS/contributors"
            case .userStats(let username):
                "users/\(username ?? "")"
            case .userActivities(let username):
                "users/\(username ?? "")/events/public"
            case .userEvents(let username):
                "users/\(username ?? "")/received_events"
            case .userRepos(let username):
                "users/\(username ?? "")/repos"
            }
        }
    }
}

extension Endpoint {
    /// Use this function to create an URL for network requests.
    /// - Parameter host: Host that which base url to be used for the request.
    /// - Returns: Returns URL with provided endpoint and selected Host.
    /**
     An example use scenario:
     
     let url: URL = APIs.Claim.uploadFile.url(.prod)
     
     */
    public func url(_ host: Hosts = .qa) -> URL {
        host.env.url(path: self)
    }
    
}

protocol Host {
    static var baseUrl: URL { get }
}

// swiftlint: disable all
public enum Hosts {
    struct Prod: Host {
        static let baseUrl: URL = URL(string: "https://swiftbuddies.vercel.app/api/")!
    }
    
    struct Qa: Host {
        static let baseUrl: URL = URL(string: "https://swiftbuddies.vercel.app/api/")!
    }
    
    struct ProdV2: Host {
        static let baseUrl: URL = URL(string: "https://swiftbuddies.vercel.app/api/v2/")!
    }
    
    struct GitHub: Host {
        static let baseUrl: URL = URL(string: "https://api.github.com/")!
    }
    
    case prod
    case qa
    case github
    case prodV2
    
    var env: Host {
        switch self {
        case .prod: Prod()
        case .qa: Qa()
        case .github: GitHub()
        case .prodV2: ProdV2()
        }
    }
}

fileprivate extension Host {
    func url(path: any Endpoint) -> URL {
        Self.baseUrl.appending(path: path.value)
    }
}

public protocol Endpoint {
    var value: String { get }
}
