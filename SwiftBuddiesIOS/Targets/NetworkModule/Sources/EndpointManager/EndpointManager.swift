//
//  EndpointManager.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 14.09.2024.
//

import Foundation

public enum APIs {
    /// if you need to add a new endpoint see the example below
    public enum Login: Endpoint {
        case register
        
        public var value: String {
            switch self {
            case .register: "register"
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
    
    case prod
    case qa
    
    var env: Host {
        switch self {
        case .prod: Prod()
        case .qa: Qa()
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
