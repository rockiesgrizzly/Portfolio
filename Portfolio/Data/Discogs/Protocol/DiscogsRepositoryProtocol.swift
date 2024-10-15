//
// DiscogsRepositoryProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

protocol DiscogsRepositoryProtocol {
    // MARK: - Authentication
    static var requestToken: String { get async throws }
    static func accessToken(for requestToken: String, and verifier: String) async throws -> (token: String, secret: String)
    static func username(forAccessToken accessToken: String, andAccessTokenSecret accessTokenSecret: String) async throws -> String
    
    // MARK: - User Collection
    static func userCollection(forUsername username: String, withAccessToken accessToken: String, andAccessTokenSecret accessTokenSecret: String) async throws -> DiscogsUserCollectionResponse
    static func releases(withId id: String, andAccessToken accessToken: String, andAccessTokenSecret accessTokenSecret: String) async throws -> DiscogsReleaseResponse
}
