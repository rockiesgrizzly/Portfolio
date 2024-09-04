//
//  GenAiPromptRepository.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

struct GenAiDataSource: GenAiDataSourceProtocol {
    static func getAiResponse(promptModel: GenAiPromptModel) async throws -> GenAiResponseModel {
        switch promptModel.service {
        case .ChatGPT:
            let response = try await OpenAiService.response(toPrompt: promptModel.prompt)
            return GenAiResponseModel(response: response)
        case .Gemini:
            let response = try await GeminiService.response(toPrompt: promptModel.prompt)
            return GenAiResponseModel(response: response)
        }
    }
}
 
