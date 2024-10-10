//
//  KeyChainHandler.swift
//  Portfolio
//
//  Created by joshmac on 10/10/24.
//

import Foundation
import Security

public protocol KeyChainHandler {
    static func save(_ data: Data, forKey key: String) throws
    static func retrieve(forKey key: String) throws -> Data
}

extension KeyChainHandler {
    public static func save(_ data: Data, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data]

        // Delete if already exists
        SecItemDelete(query as CFDictionary)

        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            // Handle the error appropriately (e.g., throw a custom error)
            // For now, I'm just printing the error
            print("Error saving to Keychain: \(status)")
            throw KeyChainError.saveFailed(status: status)
        }
    }

    public static func retrieve(forKey key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne

        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else { throw KeyChainError.retrieveFailed(status: status) }
        return data
    }
}

enum KeyChainError: Error {
    case notFound
    case saveFailed(status: OSStatus)
    case retrieveFailed(status: OSStatus)
}
