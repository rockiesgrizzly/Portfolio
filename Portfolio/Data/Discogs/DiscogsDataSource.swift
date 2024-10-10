//
//  DiscogsDataSource.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

struct DiscogsDataSource: DiscogsDataSourceProtocol, KeyChainHandler {
    private static let keychainCredentialKey = "Portfolio_DiscogsCredentialKey"
    
    // MARK: - Keychain
    static func saveCredential(_ credential: DiscogsCredential) async throws {
        guard let encodedCredential = try? JSONEncoder().encode(credential) else {
                    print("Error encoding credential")
                    return
                }
        try save(encodedCredential, forKey: keychainCredentialKey)
    }
    
    static func retrieveCredential() async throws -> DiscogsCredential? {
        guard let encodedCredential = try? retrieve(forKey: keychainCredentialKey) else {
            return nil
        }
        return try? JSONDecoder().decode(DiscogsCredential.self, from: encodedCredential)
    }
    
}
 
