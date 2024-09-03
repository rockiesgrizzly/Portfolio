//
//  GenAiGetUseCase.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol GenAiGetResponseUseCase {
    static func execute(promptModel: GenAiPromptModel) async throws -> Result<GenAiResponseEntryModel, Error>
}

struct GenAiGetUseCaseImplementation: GenAiGetResponseUseCase {
    static func execute(promptModel: GenAiPromptModel) async throws -> Result<GenAiResponseEntryModel, Error> {
        do {
            let response = try await GenAiResponseRepository.getAiResponse(promptModel: promptModel)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
