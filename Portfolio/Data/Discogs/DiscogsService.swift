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
struct DiscogsService {
//    private static let authUrl = "https://www.discogs.com/oauth/authorize"
//    private static let apiBaseUrl = "https://api.discogs.com"
//    private static let requestTokenUrlSuffix = "/oauth/request_token"
//    private static let accessTokenUrlSuffix = "/oauth/access_token"
//    
//    enum ServiceError: Error {
//        case decodingError
//        case invalidResponse
//        case invalidData
//        case invalidJSON
//        case invalidURL
//        case invalidRequest
//        case invalidToken
//        case invalidOAuthParameters
//        case invalidUiApplicationKeyWindow
//    }
//    
//    // MARK: - Authentication
//    
//    private static var apiKey: String {
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_KEY") as? String else { assertionFailure("No api key found. If you're testing this code, you'll need to grab an API key and drop it in Info.plist"); return "" }
//        return apiKey
//    }
//    
//    private static var apiSecret: String {
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_SECRET") as? String else { assertionFailure("No api secret found. If you're testing this code, you'll need to grab an API secret and drop it in Info.plist"); return "" }
//        return apiKey
//    }
//    
//    static func credential() async throws -> DiscogsCredential {
//        let oAuthSwift = OAuth1Swift(consumerKey: apiKey,
//                                     consumerSecret: apiSecret,
//                                     requestTokenUrl: apiBaseUrl + requestTokenUrlSuffix,
//                                     authorizeUrl: authUrl,
//                                     accessTokenUrl: apiBaseUrl + accessTokenUrlSuffix)
//        
//        guard let rootViewController = await UIApplication.shared.topWindow?.rootViewController else { throw ServiceError.invalidUiApplicationKeyWindow }
//        oAuthSwift.authorizeURLHandler = SafariURLHandler(viewController: rootViewController, oauthSwift: oAuthSwift)
//        
//        guard let callbackUrl = URL(string: "oauth-swift://oauth-callback/discogs") else { throw ServiceError.invalidURL }
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            oAuthSwift.authorize(withCallbackURL: callbackUrl) { result in
//                switch result {
//                case .success(let (credential, _, _)):
//                    let credential = DiscogsCredential.from(credential)
//                    continuation.resume(returning: credential)
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//        
////        Content-Type: application/x-www-form-urlencoded
////        Authorization:
////                OAuth oauth_consumer_key="your_consumer_key",
////                oauth_nonce="random_string_or_timestamp",
////                oauth_signature="your_consumer_secret&",
////                oauth_signature_method="PLAINTEXT",
////                oauth_timestamp="current_timestamp",
////                oauth_callback="your_callback"
////        User-Agent: some_user_agent
//        
//        let consumerInfo = (key: apiKey, secret: apiSecret)
//        guard let requestTokenUrl = URL(string: apiBaseUrl + requestTokenUrlSuffix) else { throw ServiceError.invalidURL }
//        var request = URLRequest(url: requestTokenUrl)
//        
//    }
//    
//    static func username(credential: OAuthSwiftCredential) async throws -> String {
//        guard let url = URL(string: "https://api.discogs.com/oauth/identity") else { throw ServiceError.invalidURL }
//        let oAuthSwiftClient = OAuthSwiftClient(credential: credential)
//
//        return try await withCheckedThrowingContinuation { continuation in
//            oAuthSwiftClient.get(url) { result in
//                switch result {
//                case .success(let (data, _, _)):
//                    if let username = try? JSONDecoder().decode(DiscogsUserIdentity.self, from: data).username {
//                        continuation.resume(returning: username)
//                    }
//                    continuation.resume(throwing: ServiceError.decodingError)
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//    
//    // MARK: - User Collection Retrieval
//    
////    func retrieveUserCollection(for username: String, folderId: Int = 0, credential: OAuthSwiftCredential) async throws -> Data {
////        let urlString = "https://api.discogs.com/users/\(username)/collection/folders/\(folderId)/releases"
////        let url = URL(string: urlString)!
////
////        // Create an OAuthSwift client with the user's credentials
////        let client = OAuthSwiftClient(credential: credential)
////
////        // Make the API request
////        let (data, response) = try await client.get(url, headers: [:])
////
////        // Check for errors
////        if let httpResponse = response as? HTTPURLResponse,
////           !(200...299).contains(httpResponse.statusCode) {
////            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
////        }
////
////        return data
////    }
//    
}
