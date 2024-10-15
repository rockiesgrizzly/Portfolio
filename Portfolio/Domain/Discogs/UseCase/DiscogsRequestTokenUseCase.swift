//
//  DiscogsRequestTokenUseCase.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsRequestTokenUseCase {
    static func execute() async throws -> Result<Bool, Error>
}

struct DiscogsRequestTokenUseCaseImplementation: DiscogsRequestTokenUseCase {
    static func execute() async throws -> Result<Bool, Error> {
        do {
            let retrievedRequestToken = try await DiscogsDataSource.retrieveRequestToken()
            
            if !retrievedRequestToken.isEmpty {
                return .success(true)
            } else {
                let requestToken = try await DiscogsRepository.requestToken
                try await DiscogsDataSource.saveRequestToken(requestToken)
                return .success(true)
            }
        } catch {
            return .failure(error)
        }
    }
}
