//
//  DiscogsReleaseUseCase.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsReleaseUseCase {
    static func execute(with verifier: String) async throws -> Result<Bool, Error>
}

struct DiscogsReleaseUseCaseImplementation: DiscogsReleaseUseCase {
    static func execute(with id: String) async throws -> Result<Bool, Error> {
        do {
            let accessToken = try await DiscogsDataSource.retrieveAccessToken()
            let accessTokenSecret = try await DiscogsDataSource.retrieveAccessTokenSecret()
            let release = try await DiscogsRepository.releases(withId: id, andAccessToken: accessToken, andAccessTokenSecret: accessTokenSecret)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}
