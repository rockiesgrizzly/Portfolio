//
//  GenAiService.swift
//  Emotions
//
//  Created by joshmac on 8/31/24.
//

import Foundation
import GoogleGenerativeAI

struct GeminiServiceConsumer {
    static var model: GenerativeModel? {
        guard let apiKey = ProcessInfo.processInfo.environment["GOOGLE_GEN_AI_KEY"] else {
            assertionFailure("missing api key")
            return nil
        }
        
        return GenerativeModel(name: "gemini-1.5-flash-latest",
                        apiKey: apiKey)
    }
    
    static func response(toPrompt prompt: String) async throws -> String? {
        guard let content = try await model?.generateContent([prompt]) else { return nil }
        return content.text
    }
}

