//
//  GenAiServiceProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/3/24.
//

protocol GenAiService {
    static func response(toPrompt prompt: String) async throws -> String?
}
