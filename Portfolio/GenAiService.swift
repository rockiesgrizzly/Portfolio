//
//  GenAiService.swift
//  Emotions
//
//  Created by joshmac on 8/31/24.
//

import Foundation
import GoogleGenerativeAI

struct GeminiService {
    static var model: GenerativeModel? {
        return GenerativeModel(name: "gemini-1.5-flash-latest",
                        apiKey: apiKey)
    }
    
    private static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_GEN_AI_KEY") as? String else { assertionFailure("No api key found. If you're testing this code, you'll need to grab an API key and drop it in Info.plist"); return "" }
        return apiKey
    }
    
    static func response(toPrompt prompt: String) async throws -> String? {
        guard let content = try await model?.generateContent([prompt]) else { return nil }
        return content.text
    }
}

