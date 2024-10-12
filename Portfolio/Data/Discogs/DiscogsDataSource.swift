//
//  DiscogsDataSource.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

struct DiscogsDataSource: DiscogsDataSourceProtocol, KeyChainHandler {
    private static let keychainRequestTokenKey = "Portfolio_Discogs_Request_Token"
    private static let keychainTokenKeAccessTokenKey = "Portfolio_Discogs_Access_Token"
    private static let keychainTokenKeAccessTokenSecretKey = "Portfolio_Discogs_Access_Token_Secret"
    private static let keychainUsernameKey = "Portfolio_Discogs_User_Name"
    
    // MARK: - Keychain Save
    
    static func saveRequestToken(_ token: String) async throws {
        guard let data = token.data(using: .utf8) else { throw SourceError.encodingIssue }
        try save(data, forKey: keychainRequestTokenKey)
    }
    
    static func saveAccessToken(_ token: String) async throws {
        guard let data = token.data(using: .utf8) else { throw SourceError.encodingIssue }
        try save(data, forKey: keychainTokenKeAccessTokenKey)
    }
    
    static func saveAccessTokenSecret(_ secret: String) async throws {
        guard let data = secret.data(using: .utf8) else { throw SourceError.encodingIssue }
        try save(data, forKey: keychainTokenKeAccessTokenSecretKey)
    }
    
    static func saveUsername(_ name: String) async throws {
        guard let data = name.data(using: .utf8) else { throw SourceError.encodingIssue }
        try save(data, forKey: keychainUsernameKey)
    }
    
    
    // MARK: - Keychain Retrieve
    
    static func retrieveRequestToken() async throws -> String {
        guard let data = try? retrieve(forKey: keychainRequestTokenKey) else {
            throw SourceError.notFound
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw SourceError.decodingIssue
        }
        
        return string
    }
    
    static func retrieveAccessToken() async throws -> String {
        guard let data = try? retrieve(forKey: keychainTokenKeAccessTokenKey) else {
            throw SourceError.notFound
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw SourceError.decodingIssue
        }
        
        return string
    }
    
    static func retrieveAccessTokenSecret() async throws -> String {
        guard let data = try? retrieve(forKey: keychainTokenKeAccessTokenSecretKey) else {
            throw SourceError.notFound
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw SourceError.decodingIssue
        }
        
        return string
    }
    
    static func retrieveUsername() async throws -> String {
        guard let data = try? retrieve(forKey: keychainUsernameKey) else {
            throw SourceError.notFound
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw SourceError.decodingIssue
        }
        
        return string
    }
    
    enum SourceError: Error {
        case decodingIssue
        case encodingIssue
        case notFound
    }
    
}
 
