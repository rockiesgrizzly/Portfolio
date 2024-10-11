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
    
    // MARK: - User Collection
}
