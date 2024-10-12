//
//  DiscogsCollectionUseCase.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsCollectionUseCase {
    static func execute() async throws -> Result<DiscogsReleasesCollection, Error>
}

struct DiscogsCollectionUseCaseImplementation: DiscogsCollectionUseCase {
    static func execute() async throws -> Result<DiscogsReleasesCollection, Error> {
        do {
            let authToken = try await DiscogsDataSource.retrieveAccessToken()
            let authTokenSecret = try await DiscogsDataSource.retrieveAccessTokenSecret()
            let username = try await DiscogsDataSource.retrieveUsername()
            let response = try await DiscogsRepository.userCollection(forUsername: username, withAuthToken: authToken, andAuthTokenSecret: authTokenSecret)
            return .success(response.releasesCollection)
        } catch {
            return .failure(error)
        }
    }
}

extension DiscogsUserCollectionResponse {
    var releasesCollection: DiscogsReleasesCollection {
        return DiscogsReleasesCollection()
    }
}
