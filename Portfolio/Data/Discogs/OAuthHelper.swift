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
    
    func requestToken(fromUrl url: URL, key: String, secret: String) async throws -> String {
        var request = URLRequest(url: url)
        let parameters = oAuthParameters(key: key, secret: secret)
        let signature = signature(for: request, parameters: parameters, consumerSecret: secret)
        
        let authHeader = authorizationHeader(from: parameters, signature: signature)
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        addUserAgent(to: &request)
        
        let data = try await Request<Data>.asyncGet(request)
        
        if let data, let responseString = String(data: data, encoding: .utf8),
           let requestToken = token(from: responseString) {
            return requestToken
        } else {
            throw HelperError.invalidResponse
        }
    }
    
    func accessToken(fromUrl url: URL, key: String, secret: String, requestToken: String, verifier: String) async throws -> (token: String, secret: String) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Access token request is a POST request

        var parameters = oAuthParameters(key: key, secret: secret)
        parameters["oauth_token"] = requestToken
        parameters["oauth_verifier"] = verifier

        // Calculate the signature with the request token secret
        let signature = signature(for: request, parameters: parameters, consumerSecret: secret, tokenSecret: requestToken) // Include tokenSecret

        let authHeader = authorizationHeader(from: parameters, signature: signature)
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        addUserAgent(to: &request)

        let data = try await Request<Data>.asyncGet(request)

        guard let data,
              let responseString = String(data: data, encoding: .utf8) else {
            throw HelperError.invalidResponse
        }

        // Extract the access token and secret from the response
        guard let accessToken = token(from: responseString),
              let accessTokenSecret = token(from: responseString) else {
            throw HelperError.missingToken
        }

        return (accessToken, accessTokenSecret)
    }
    
    private func addUserAgent(to request: inout URLRequest) {
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
    private func oAuthParameters(key: String, secret: String) -> [String: String] {
        var parameters = [String: String]()

        parameters["oauth_consumer_key"] = key
        parameters["oauth_nonce"] = nonce
        parameters["oauth_signature_method"] = "HMAC-SHA1"
        parameters["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
        parameters["oauth_callback"] = PortfolioApp.oauthCallbackUrl

        return parameters
    }

    private func signature(for request: URLRequest,
                            parameters: [String: String],
                            consumerSecret: String,
                            tokenSecret: String? = nil) -> String {

        let signatureBaseString = signatureBaseString(for: request, parameters: parameters)
        let signingKey = signingKey(consumerSecret: consumerSecret, tokenSecret: tokenSecret)
        let signature = hmacSha(for: signatureBaseString, with: signingKey)

        return signature
    }
    
    private var nonce: String { UUID().uuidString }
    
    private func signatureBaseString(for request: URLRequest, parameters: [String: String]) -> String {
        let method = request.httpMethod!.uppercased()
        guard let urlString = request.url?.absoluteString else {
            // Handle URL error (e.g., return an empty string or throw an error)
            return ""
        }
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let sortedParameters = parameters.sorted { $0.key < $1.key }
        let parameterString = sortedParameters.map { "\(percentEncode($0.key))=\(percentEncode($0.value))" }.joined(separator: "&")
        let encodedParameters = parameterString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return "\(method)&\(encodedURL)&\(encodedParameters)"
    }
    
    private func signingKey(consumerSecret: String, tokenSecret: String? = nil) -> String {
        if let tokenSecret = tokenSecret {
            return "\(percentEncode(consumerSecret))&\(percentEncode(tokenSecret))"
        } else {
            return "\(percentEncode(consumerSecret))&"
        }
    }
    
    private func hmacSha(for text: String, with key: String) -> String {
        let keyData = Data(key.utf8)
        let textData = Data(text.utf8)

        let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: textData, using: SymmetricKey(data: keyData))
        return Data(hmac).base64EncodedString()
    }
    
    private func percentEncode(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            .replacingOccurrences(of: "!", with: "%21")
            .replacingOccurrences(of: "'", with: "%27")
            .replacingOccurrences(of: "(", with: "%28")
            .replacingOccurrences(of: ")", with: "%29")
            .replacingOccurrences(of: "*", with: "%2A")
    }
    
    
    // Helper functions to extract tokens from response strings
    private func token(from responseString: String) -> String? {
        // Implement logic to parse the response and extract the oauth_token
        // This will involve splitting the response string by '&' and '=' to find the value associated with 'oauth_token'
        // Example:
        let components = responseString.components(separatedBy: "&")
        for component in components {
            let keyValuePair = component.components(separatedBy: "=")
            if keyValuePair.count == 2 && keyValuePair[0] == "oauth_token" {
                return keyValuePair[1]
            }
        }
        return nil
    }
    
    private func verifier(from callbackURL: URL) -> String? {
        // Implement logic to parse the callback URL and extract the oauth_verifier
        // This will likely involve getting the query parameters from the URL and finding the value associated with 'oauth_verifier'
        // Example:
        guard let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        return queryItems.first(where: { $0.name == "oauth_verifier" })?.value
    }
    
    private func authorizationHeader(from parameters: [String: String], signature: String) -> String {
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
