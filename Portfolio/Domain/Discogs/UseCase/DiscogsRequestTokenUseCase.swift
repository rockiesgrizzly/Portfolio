//
//  DiscogsRequestTokenUseCase.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsRequestTokenUseCase {
    static func execute() async throws -> Result<String, Error>
}

struct DiscogsRequestTokenUseCaseImplementation: DiscogsRequestTokenUseCase {
    static func execute() async throws -> Result<String, Error> {
        do {
            let requestToken = try await DiscogsRepository.requestToken
            try await DiscogsDataSource.saveRequestToken(requestToken)
            return .success(requestToken)
        } catch {
            return .failure(error)
        }
    }
}
