//
//  DiscogsService.swift
//  Portfolio
//
//  Created by joshmac on 9/30/24.
//

import OAuthSwift
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
    
    static func from(_ credential: OAuthSwiftCredential) -> DiscogsCredential {
        DiscogsCredential(oauthToken: credential.oauthToken,
                          oauthRefreshToken: credential.oauthRefreshToken,
                          oauthTokenSecret: credential.oauthTokenSecret,
                          oauthTokenExpiresAt: credential.oauthTokenExpiresAt)
    }
}

/// Service retrieving token and user collection from Discogs APi https://www.discogs.com/developers/#page:home,header:home-quickstart
struct DiscogsService {
    private static let authUrl = "https://www.discogs.com/oauth/authorize"
    private static let apiBaseUrl = "https://api.discogs.com"
    private static let requestTokenUrlSuffix = "/oauth/request_token"
    private static let accessTokenUrlSuffix = "/oauth/access_token"
    
    enum ServiceError: Error {
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
    
    static func credential() async throws -> (credential: DiscogsCredential?, error: Error?) {
        let oAuthSwift = OAuth1Swift(consumerKey: apiKey,
                                     consumerSecret: apiSecret,
                                     requestTokenUrl: apiBaseUrl + requestTokenUrlSuffix,
                                     authorizeUrl: authUrl,
                                     accessTokenUrl: apiBaseUrl + accessTokenUrlSuffix)
        
        guard let rootViewController = await UIApplication.shared.topWindow?.rootViewController else { return (nil, ServiceError.invalidUiApplicationKeyWindow) }
        oAuthSwift.authorizeURLHandler = SafariURLHandler(viewController: rootViewController, oauthSwift: oAuthSwift)
        
        let callbackUrl = URL(string: "oauth-swift://oauth-callback/discogs")!
        
        return await withCheckedContinuation { continuation in
            oAuthSwift.authorize(withCallbackURL: callbackUrl) { result in
                switch result {
                case .success(let (credential, _, _)):
                    let credential = DiscogsCredential.from(credential)
                    continuation.resume(returning: (credential, nil))
                case .failure(let error):
                    continuation.resume(returning: (nil, error))
                }
            }
        }
    }
    
    // MARK: - User Collection Retrieval
    
//    func retrieveUserCollection(for username: String, folderId: Int = 0, credential: OAuthSwiftCredential) async throws -> Data {
//        let urlString = "https://api.discogs.com/users/\(username)/collection/folders/\(folderId)/releases"
//        let url = URL(string: urlString)!
//
//        // Create an OAuthSwift client with the user's credentials
//        let client = OAuthSwiftClient(credential: credential)
//
//        // Make the API request
//        let (data, response) = try await client.get(url, headers: [:])
//
//        // Check for errors
//        if let httpResponse = response as? HTTPURLResponse,
//           !(200...299).contains(httpResponse.statusCode) {
//            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
//        }
//
//        return data
//    }
    
}
