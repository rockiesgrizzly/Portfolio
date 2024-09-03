//
//  GenAiPromptRepository.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

struct GenAiDataSource {
    typealias GenAiSource = GeminiService
}

extension GenAiDataSource: GenAiDataSourceProtocol {
    static func getAiResponse(prompt: String) async throws -> GenAiResponseModel {
        let response = try await GenAiSource.response(toPrompt: prompt)
        return GenAiResponseModel(response: response)
    }
}
