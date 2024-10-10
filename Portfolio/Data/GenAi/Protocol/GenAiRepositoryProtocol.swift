//
//  GenAiRepositoryProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol GenAiRepositoryProtocol {
    static func getAiResponse(promptModel: GenAiPromptModel) async throws -> GenAiResponseEntryModel
}
