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

    @Test static func requestTokenSucceeds() async throws {
        let token = try await TestOAuthHelper.requestToken(fromUrl: OAuthHelperTests.url, apiKey: apiKey, apiSecret: apiSecret, session: OAuthTestURLSession())
        #expect(token == "your_request_token")
    }
    
    @Test static func accessTokenSucceeds() async throws {
        let accessToken = try await TestOAuthHelper.accessToken(fromUrl:  OAuthHelperTests.url, apiKey: apiKey, apiSecret: apiSecret, requestToken: "", verifier: "", session: OAuthTestAuthURLSession())
        
        print("testAccessToken: \(accessToken)")
        #expect(accessToken.token == "your_request_token")
        #expect(accessToken.secret == "your_request_token_secret")
    }
    
    @Test static func identitySucceeds() async throws {
        let identity: DiscogsUserIdentity = try await TestOAuthHelper.getModel(from: OAuthHelperTests.url, apiKey: "", apiSecret: "", accessToken: "", accessTokenSecret: "", session: OAuthTestIdentityRLSession())
        #expect(identity.username == username)
    }
    
    @Test static func userCollectionSucceeds() async throws {
        let collection: DiscogsUserCollectionResponse = try await TestOAuthHelper.getModel(from: OAuthHelperTests.url, apiKey: "", apiSecret: "", accessToken: "", accessTokenSecret: "", session: OAuthTestCollectionURLSession())
        #expect(collection.releases.count == 2)
    }
}

struct TestOAuthHelper: OAuthHelper { }

// MARK: - Test Models

let url = URL(string: "u2.com")! // unused
let requestTokenString = "oauth_token=your_request_token&oauth_token_secret=your_request_token_secret&oauth_callback_confirmed=true"
let username = "rockiesgrizzly"
let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!

struct OAuthTestURLSession: Networking.URLSessionAsycProtocol {
    var data = requestTokenString.data(using: .utf8)!
    static let url = URL(string: "u2.com")! // unused
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return (data, response)
    }
}

let authTokenString = "oauth_token=your_access_token&oauth_token_secrett=your_access_token_secret"

struct OAuthTestAuthURLSession: Networking.URLSessionAsycProtocol {
    var data = requestTokenString.data(using: .utf8)!
    static let url = URL(string: "u2.com")! // unused

    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return (data, response)
    }
}

let identity = """
{
    "username": "\(username)" 
}
""".data(using: .utf8)!

struct OAuthTestIdentityRLSession: Networking.URLSessionAsycProtocol {
    var data = try? JSONEncoder().encode(identity)

    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        guard let data = data else { throw TestError.invalidResponse }
        return (data, response)
    }
}

enum TestError: Error {
    case invalidResponse
}

let collection = """
{
    "pagination": {
        "per_page": 50,
        "pages": 2,
        "page": 1,
        "urls": {
            "last": "https://api.discogs.com/users/example/collection/folders/0/releases?page=2&per_page=50",
            "next": "https://api.discogs.com/users/example/collection/folders/0/releases?page=2&per_page=50"
        },
        "items": 100
    },
    "releases": [
        {
            "instance_id": 123456789,
            "date_added": "2023-10-26T14:10:17-07:00",
            "basic_information": {
                "id": 987654321,
                "master_id": 543219876,
                "master_url": "https://api.discogs.com/masters/543219876",
                "title": "Album Title 1",
                "year": 2023,
                "artists": [
                    {
                        "name": "Artist Name",
                        "anv": "",
                        "join": "",
                        "role": "",
                        "tracks": "",
                        "id": 12345,
                        "resource_url": "https://api.discogs.com/artists/12345"
                    }
                ],
                "formats": [
                    {
                        "name": "Vinyl",
                        "qty": "1",
                        "descriptions": [
                            "LP",
                            "Album"
                        ]
                    }
                ],
                "labels": [
                    {
                        "name": "Label Name",
                        "catno": "CAT123",
                        "entity_type": "1",
                        "entity_type_name": "Label",
                        "id": 67890,
                        "resource_url": "https://api.discogs.com/labels/67890"
                    }
                ],
                "genres": [
                    "Rock"
                ],
                "styles": [
                    "Alternative Rock"
                ]
            }
        },
        {
            "instance_id": 987654321,
            "date_added": "2024-01-15T09:30:22-07:00",
            "basic_information": {
                "id": 543219876,
                "master_id": 123459876,
                "master_url": "https://api.discogs.com/masters/123459876",
                "title": "Album Title 2",
                "year": 2022
            }
        }
    ]
}
""".data(using: .utf8)!

struct OAuthTestCollectionURLSession: Networking.URLSessionAsycProtocol {
    var data = try? JSONEncoder().encode(collection)

    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        guard let data = data else { throw TestError.invalidResponse }
        return (data, response)
    }
}
