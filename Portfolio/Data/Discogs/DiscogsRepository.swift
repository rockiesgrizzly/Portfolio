//
//  DiscogsRepository.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

struct DiscogsRepository { }

extension DiscogsRepository: DiscogsRepositoryProtocol {
    
    // MARK: - Authentication
    
    static var requestToken: String {
        get async throws {
            try await DiscogsService.requestToken
        }
    }
    
    static func accessToken(for requestToken: String, and verifier: String) async throws -> (token: String, secret: String) {
        try await DiscogsService.accessToken(for: requestToken, and: verifier)
    }
    
    // TODO: username here
    static func username(forAccessToken accessToken: String, andAccessTokenSecret accessTokenSecret: String) async throws -> String {
        try await DiscogsService.username(forAccessToken: accessToken, andAccessTokenSecret: accessTokenSecret)
    }
    
    // MARK: - User Collection
    static func userCollection(forUsername username: String, withAccessToken accessToken: String, andAccessTokenSecret accessTokenSecret: String) async throws -> DiscogsUserCollectionResponse {
        try await DiscogsService.userCollection(forUsername: username, withAccessToken: accessToken, andAccessTokenSecret: accessTokenSecret)
    }
    
    // MARK: - Releases
    static func releases(withId id: String, andAccessToken accessToken: String, andAccessTokenSecret accessTokenSecret: String) async throws -> DiscogsReleaseResponse {
        try await DiscogsService.release(withId: id, withAccessToken: accessToken, andAccessTokenSecret: accessTokenSecret)
    }
}
