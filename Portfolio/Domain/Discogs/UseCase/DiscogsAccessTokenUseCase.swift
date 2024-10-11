//
//  DiscogsAccessTokenUseCase.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsAccessTokenUseCase {
    static func execute(with verifier: String) async throws -> Result<Bool, Error>
}

struct DiscogsAccessTokenUseCaseImplementation: DiscogsAccessTokenUseCase {
    static func execute(with verifier: String) async throws -> Result<Bool, Error> {
        do {
            // TODO: add dynamic handling here to track expiration
            let requestToken = try await DiscogsDataSource.retrieveRequestToken()
            let accessToken = try await DiscogsRepository.accessToken(for: requestToken, and: verifier)
            try await DiscogsDataSource.saveAccessToken(accessToken.token)
            try await DiscogsDataSource.saveAccessTokenSecret(accessToken.secret)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}
