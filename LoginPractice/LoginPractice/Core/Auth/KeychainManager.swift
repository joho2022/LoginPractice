//
//  KeychainManager.swift
//  LoginPractice
//
//  Created by 조호근 on 3/11/25.
//

import Foundation
import Security

final class KeychainManager {

    private init() {}
    
    static func save(
        service: String,
        account: String,
        data: Data
    ) throws {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw AuthError.keychainSecurityError(status)
        }
    }
    
    static func load(
        service: String,
        account: String
    ) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw AuthError.keychainItemNotFound
            }
            throw AuthError.keychainSecurityError(status)
        }
        
        guard let data = result as? Data else {
            throw AuthError.keychainDataConversionError
        }
        
        return data
    }
    
    static func delete(
        service: String,
        account: String
    ) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AuthError.keychainSecurityError(status)
        }
    }

}
