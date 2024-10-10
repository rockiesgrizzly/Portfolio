//
//  DiscogsAuthenticateUseCase.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsAuthenticateUseCase {
    static func execute(userInfo: DiscogsUserInfoModel) async throws -> Result<DiscogsAuthResponseModel, Error>
}

struct DiscogsAuthenticateUseCaseImplementation: DiscogsAuthenticateUseCase {
    static func execute(userInfo: DiscogsUserInfoModel) async throws -> Result<DiscogsAuthResponseModel, Error> {
        do {
//            let response = try await GenAiResponseRepository.getAiResponse(userInfo: userInfo)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
