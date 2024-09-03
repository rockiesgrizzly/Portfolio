//
//  GenAiResponseRepository.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

struct GenAiResponseRepository { }

extension GenAiResponseRepository: GenAiRepositoryProtocol {
    static func getAiResponse(promptModel: GenAiPromptModel) async throws -> GenAiResponseEntryModel {
        let response = try await GenAiDataSource.getAiResponse(prompt: promptModel.prompt)
        return GenAiResponseEntryModel(response: response.response)
    }
}
