//
//  GenAiDataSoureProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol GenAiDataSourceProtocol {
    static func getAiResponse(promptModel: GenAiPromptModel) async throws -> GenAiResponseModel
}
