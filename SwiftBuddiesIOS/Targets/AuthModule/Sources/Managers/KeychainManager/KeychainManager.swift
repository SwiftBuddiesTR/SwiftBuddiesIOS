//
//  KeychainManager.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 17.09.2024.
//

import Foundation
//import SwiftUI

public class KeychainManager {
    public enum Key: String {
        case accessToken
    }
    
    public static let shared = KeychainManager()
    
    @discardableResult
    public func save(key: KeychainManager.Key, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            debugPrint("Failed to convert value to data")
            return false
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data
        ]
        
        // Delete any existing item before saving
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else {
            debugPrint("Failed to save item: \(status)")
            return false
        }
    }
    
    public func get(key: KeychainManager.Key) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as CFTypeRef,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            guard let stringValue = String(data: data, encoding: .utf8) else {
                debugPrint("Failed to convert data to string")
                return nil
            }
            return stringValue
        } else {
            if status != errSecItemNotFound {
                debugPrint("Failed to retrieve item: \(status)")
            }
            return nil
        }
    }
    
    @discardableResult
    public func delete(_ key: KeychainManager.Key) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue,
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
}
