//
//  GenAiDataSoureProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol GenAiDataSourceProtocol {
    static func getAiResponse(prompt: String) async throws -> GenAiResponseModel
}
