//
//  OAuthHelperTests.swift
//  PortfolioTests
//
//  Created by joshmac on 10/11/24.
//

import Foundation
import Networking
import Testing
@testable import Portfolio


struct OAuthHelperTests {
    static let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
    static var request = URLRequest(url: url)
    
    private let authUrl = "https://www.discogs.com/oauth/authorize"
    private let apiBaseUrl = "https://api.discogs.com"
    private let requestTokenUrlSuffix = "/oauth/request_token"
    private let accessTokenUrlSuffix = "/oauth/access_token"
    
    private static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_KEY") as? String else { assertionFailure("No api key found. If you're testing this code, you'll need to grab an API key and drop it in Info.plist"); return "" }
        return apiKey
    }
    
    private static var apiSecret: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_SECRET") as? String else { assertionFailure("No api secret found. If you're testing this code, you'll need to grab an API secret and drop it in Info.plist"); return "" }
        return apiKey
    }

    @Test static func testRequestToken() async throws {
        let token = try await TestOAuthHelper.requestToken(fromUrl: OAuthHelperTests.url, key: apiKey, secret: apiSecret, session: OAuthTestURLSession())
        #expect(token == "your_request_token")
    }
    
    @Test static func testAccessToken() async throws {
        request.httpMethod = "POST"

        let authToken = try await TestOAuthHelper.accessToken(fromUrl:  OAuthHelperTests.url, key: apiKey, secret: apiSecret, requestToken: "", verifier: "", session: OAuthTestAuthURLSession())
        
        print("testAccessToken: \(authToken)")
        #expect(authToken.token == "your_request_token")
        #expect(authToken.secret == "your_request_token_secret")
    }
}

struct TestOAuthHelper: OAuthHelper { }

// MARK: - Test Models

let url = URL(string: "u2.com")!
let requestTokenString = "oauth_token=your_request_token&oauth_token_secret=your_request_token_secret&oauth_callback_confirmed=true"

struct OAuthTestURLSession: Networking.URLSessionAsycProtocol {
    var data = requestTokenString.data(using: .utf8)!
    static let url = URL(string: "u2.com")! // unused
    static let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return (data, OAuthTestURLSession.response)
    }
}

let authTokenString = "oauth_token=your_access_token&oauth_token_secrett=your_access_token_secret"

struct OAuthTestAuthURLSession: Networking.URLSessionAsycProtocol {
    var data = requestTokenString.data(using: .utf8)!
    static let url = URL(string: "u2.com")! // unused
    static let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return (data, OAuthTestURLSession.response)
    }
}
