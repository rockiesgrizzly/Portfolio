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
    
    // MARK: - User Collection
    
    // TODO: collection here
}
