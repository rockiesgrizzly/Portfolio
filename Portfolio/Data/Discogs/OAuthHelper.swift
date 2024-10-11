//
//  OAuthHelper.swift
//  Portfolio
//
//  Created by joshmac on 10/11/24.
//

import AuthenticationServices
import CryptoKit
import Foundation
import Networking

protocol OAuthHelper {}

extension OAuthHelper {
    
    // MARK: - Public
    
    ///  Send a GET request to the Discogs request token URL
    static func requestToken(fromUrl url: URL, apiKey: String, apiSecret: String, session: Networking.URLSessionAsycProtocol = URLSession.shared) async throws -> String {
        var request = URLRequest(url: url)
        let parameters = oAuthParameters(apiKey: apiKey, apiSecret: apiSecret)
        let signature = signature(parameters: parameters)
        
        let authHeader = authorizationHeader(from: parameters, signature: signature)
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        addUserAgent(to: &request)
        
        let responseString = try await StringRequest.asyncGet(request, session: session)
        guard let token = token(from: responseString, key: "oauth_token") else { throw HelperError.noData}
        
        return token
    }
    
    
    static func accessToken(fromUrl url: URL, apiKey: String, apiSecret: String, requestToken: String, verifier: String, session: Networking.URLSessionAsycProtocol = URLSession.shared) async throws -> (token: String, secret: String) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        var parameters = oAuthParameters(apiKey: apiKey, apiSecret: apiSecret)
        parameters["oauth_token"] = requestToken
        parameters["oauth_verifier"] = verifier

        // Calculate the signature with the request token secret
        let signature = signature(parameters: parameters)

        let authHeader = authorizationHeader(from: parameters, signature: signature)
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        addUserAgent(to: &request)

        let responseString = try await StringRequest.asyncGet(request, session: session)

        // Extract the access token and secret from the response
        guard let accessToken = token(from: responseString, key: "oauth_token"),
              let accessTokenSecret = token(from: responseString, key: "oauth_token_secret") else {
            throw HelperError.missingToken
        }

        return (accessToken, accessTokenSecret)
    }
    
    static func getModel<Model: Decodable>(from url: URL, apiKey: String, apiSecret: String, authToken: String, authTokenSecret: String, session: Networking.URLSessionAsycProtocol = URLSession.shared) async throws -> Model {
        var request = URLRequest(url: url)
        var parameters = oAuthParameters(apiKey: apiKey, apiSecret: apiSecret)
        parameters["oauth_token"] = authToken

        let signature = getSignature(for: request, parameters: parameters, apiSecret: apiSecret, tokenSecret: authTokenSecret)

        let authHeader = authorizationHeader(from: parameters, signature: signature)
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        addUserAgent(to: &request)

        // Use async/await to get the data
        guard let data = try await Request<Data>.asyncGet(request, session: session) else { throw HelperError.noData }
        let identity = try JSONDecoder().decode(Model.self, from: data)

        return identity
    }
    
    private static func addUserAgent(to request: inout URLRequest) {
        request.setValue("Portfolio/1.0.0", forHTTPHeaderField: "User-Agent")
    }

    
    // MARK: - Private
    
    ///Authorization:
    ///    oauth_consumer_key="your_consumer_key",
    ///    oauth_nonce="random_string_or_timestamp",
    ///    oauth_signature="your_consumer_secret&",
    ///    oauth_signature_method="PLAINTEXT",
    ///    oauth_timestamp="current_timestamp",
    ///    oauth_callback="your_callback"
    static func oAuthParameters(apiKey: String, apiSecret: String) -> [String: String] {
        var parameters = [String: String]()

        parameters["oauth_consumer_key"] = apiKey
        parameters["oauth_nonce"] = nonce
        parameters["oauth_signature_method"] = "PLAINTEXT"
        parameters["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
        parameters["oauth_callback"] = PortfolioApp.oauthCallbackUrl
        parameters["oauth_signature"] = "\(percentEncode(apiSecret))&"

        return parameters
    }

    static func signature(parameters: [String: String]) -> String {
        parameters["oauth_signature"] ?? ""
    }
    
    private static func getSignature(for request: URLRequest,
                                parameters: [String: String],
                                apiSecret: String,
                                tokenSecret: String? = nil) -> String {

        let signatureBaseString = signatureBaseString(for: request, parameters: parameters)
        let signingKey = "\(percentEncode(apiSecret))&\(percentEncode(tokenSecret ?? ""))"
        let signature = hmacSha(for: signatureBaseString, with: signingKey)

        return signature
    }
    
    private static var nonce: String { UUID().uuidString }
    
    private static func signatureBaseString(for request: URLRequest, parameters: [String: String]) -> String {
        let method = request.httpMethod!.uppercased()
        
        // Construct the base URL without query parameters
        guard let url = request.url,
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return ""
        }
        urlComponents.query = nil
        let encodedURL = urlComponents.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let sortedParameters = parameters.sorted { $0.key < $1.key }
        let parameterString = sortedParameters.map { "\(percentEncode($0.key))=\(percentEncode($0.value))" }.joined(separator: "&")
        let encodedParameters = parameterString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        return "\(method)&\(encodedURL)&\(encodedParameters)"
    }
    
    private static func hmacSha(for text: String, with key: String) -> String {
        let keyData = Data(key.utf8)
        let textData = Data(text.utf8)

        let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: textData, using: SymmetricKey(data: keyData))
        return Data(hmac).base64EncodedString()
    }
    
    private static func percentEncode(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            .replacingOccurrences(of: "!", with: "%21")
            .replacingOccurrences(of: "'", with: "%27")
            .replacingOccurrences(of: "(", with: "%28")
            .replacingOccurrences(of: ")", with: "%29")
            .replacingOccurrences(of: "*", with: "%2A")
    }
    
    
    // Helper functions to extract tokens from response strings
    private static func token(from responseString: String, key: String) -> String? {
        // Implement logic to parse the response and extract the oauth_token
        // This will involve splitting the response string by '&' and '=' to find the value associated with 'oauth_token'
        // Example:
        let components = responseString.components(separatedBy: "&")
        for component in components {
            let keyValuePair = component.components(separatedBy: "=")
            if keyValuePair.count == 2 && keyValuePair[0] == key {
                return keyValuePair[1]
            }
        }
        return nil
    }
    
    private static func verifier(from callbackURL: URL) -> String? {
        // Implement logic to parse the callback URL and extract the oauth_verifier
        // This will likely involve getting the query parameters from the URL and finding the value associated with 'oauth_verifier'
        // Example:
        guard let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        return queryItems.first(where: { $0.name == "oauth_verifier" })?.value
    }
    
    static func authorizationHeader(from parameters: [String: String], signature: String) -> String {
        var authHeader = "OAuth "
        let sortedParameters = parameters.sorted { $0.key < $1.key }
        for (index, (key, value)) in sortedParameters.enumerated() {
            authHeader += "\(percentEncode(key))=\"\(percentEncode(value))\""
            if index < sortedParameters.count - 1 {
                authHeader += ", "
            }
        }
        authHeader += ", oauth_signature=\"\(percentEncode(signature))\""
        return authHeader
    }
}

enum HelperError: Error {
    case invalidResponse
    case missingToken
    case noData
}
