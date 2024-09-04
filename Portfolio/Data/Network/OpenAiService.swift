//
//  OpenAiService.swift
//  Portfolio
//
//  Created by joshmac on 9/3/24.
//

import Foundation
import OpenAISwift

struct OpenAiService {
    private static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_KEY") as? String else { assertionFailure("No api key found. If you're testing this code, you'll need to grab an API key and drop it in Info.plist"); return "" }
        return apiKey
    }
    
    private static var openAiSwift: OpenAISwift {
        let config = OpenAISwift.Config.makeDefaultOpenAI(apiKey: apiKey)
        return OpenAISwift(config: config)
    }
}

extension OpenAiService: GenAiService {
    static func response(toPrompt prompt: String) async throws -> String? {
        let chatMessage = ChatMessage(role: .user, content: prompt)
        let result = try await openAiSwift.sendChat(with: [chatMessage])
        
        return result.results?.first?.message.content
    }
}
