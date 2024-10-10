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
    static var credential: DiscogsCredential {
        get async throws {
            let discogsServiceCredential = try await DiscogsService.credential()
            if let credential = discogsServiceCredential.credential {
                return credential
            } else if let error = discogsServiceCredential.error {
                throw error
            }
            throw RepositoryError.invalidCredential
        }
    }
    
    enum RepositoryError: Error {
        case invalidCredential
    }
}
