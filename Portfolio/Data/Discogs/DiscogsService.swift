//
//  DiscogsService.swift
//  Portfolio
//
//  Created by joshmac on 9/30/24.
//

import Foundation

import UIKit // Required for Discogs OAuth1 webview

struct DiscogsCredential: Codable {
    var oauthToken = ""
    var oauthRefreshToken = ""
    var oauthTokenSecret = ""
    var oauthTokenExpiresAt: Date?
    
    init(oauthToken: String = "", oauthRefreshToken: String = "", oauthTokenSecret: String = "", oauthTokenExpiresAt: Date? = nil) {
        self.oauthToken = oauthToken
        self.oauthRefreshToken = oauthRefreshToken
        self.oauthTokenSecret = oauthTokenSecret
        self.oauthTokenExpiresAt = oauthTokenExpiresAt
    }
}

struct DiscogsUserIdentity: Codable {
    let username: String
}

/// Service retrieving token and user collection from Discogs APi https://www.discogs.com/developers/#page:home,header:home-quickstart
struct DiscogsService: OAuthHelper {
    private static let apiBaseUrl = "https://api.discogs.com"
    private static let requestTokenUrlSuffix = "/oauth/request_token"
    private static let accessTokenUrlSuffix = "/oauth/access_token"
    private static let identitySuffix = "/oauth/identity"
    private static let allUserReleasesSuffix = "/users/${username}/collection/folders/0/releases"
    private static let releasesSuffix = "/releases/${releaseId}"
    
    enum ServiceError: Error {
        case decodingError
        case invalidResponse
        case invalidData
        case invalidJSON
        case invalidURL
        case invalidRequest
        case invalidToken
        case invalidOAuthParameters
        case invalidUiApplicationKeyWindow
    }
    
    // MARK: - Authentication
    
    private static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_KEY") as? String else { assertionFailure("No api key found. If you're testing this code, you'll need to grab an API key and drop it in Info.plist"); return "" }
        return apiKey
    }
    
    private static var apiSecret: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_SECRET") as? String else { assertionFailure("No api secret found. If you're testing this code, you'll need to grab an API secret and drop it in Info.plist"); return "" }
        return apiKey
    }
    
    static var requestToken: String {
        get async throws {
            let urlString = apiBaseUrl + requestTokenUrlSuffix
            guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
            
            return try await requestToken(fromUrl: url, apiKey: apiKey, apiSecret: apiSecret)
        }
    }
        
    static func accessToken(for requestToken: String, and verifier: String) async throws -> (token: String, secret: String) {
        let urlString = apiBaseUrl + accessTokenUrlSuffix
        guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
        
        return try await accessToken(fromUrl: url, apiKey: apiKey, apiSecret: apiSecret, requestToken: requestToken, verifier: verifier)
    }
    
    static func username(forAccessToken accessToken: String, andAccessTokenSecret accessTokenSecret: String) async throws -> String {
        let urlString = apiBaseUrl + identitySuffix
        guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
        
        let identity: DiscogsUserIdentity = try await getModel(from: url, apiKey: apiKey, apiSecret: apiSecret, accessToken: accessToken, accessTokenSecret: accessTokenSecret)
        return identity.username
    }
    
    static func userCollection(forUsername username: String, withAccessToken accessToken: String?, andAccessTokenSecret accessTokenSecret: String?) async throws -> DiscogsUserCollectionResponse {
        let urlString = apiKey + String(format: allUserReleasesSuffix, username)
        guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
        
        return try await getModel(from: url, apiKey: apiKey, apiSecret: apiSecret, accessToken: accessToken, accessTokenSecret: accessTokenSecret)
    }
    
    static func release(withId releaseId: String, withAccessToken accessToken: String?, andAccessTokenSecret accessTokenSecret: String?) async throws -> DiscogsReleaseResponse {
        let urlString = apiKey + String(format: releasesSuffix, releaseId)
        guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
        
        return try await getModel(from: url, apiKey: apiKey, apiSecret: apiSecret, accessToken: accessToken, accessTokenSecret: accessTokenSecret)
    }
}
