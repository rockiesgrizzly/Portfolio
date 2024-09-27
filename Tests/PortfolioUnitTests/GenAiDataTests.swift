//
//  GenAiServiceTests.swift
//  PortfolioTests
//
//  Created by joshmac on 9/3/24.
//

import XCTest
@testable import Portfolio

final class GenAiDataTests: XCTestCase {
    let promptModelGemini = GenAiPromptModel(prompt: "Running unit tests. Any response will do. Thanks.", service: .Gemini)
    
    // MARK: - GenAiResponseRepository
    func testRepositoryGetAiResponseGemini() async throws {
        let response = try await GenAiResponseRepository.getAiResponse(promptModel: promptModelGemini)
        XCTAssert(response.response?.isEmpty == false)
    }
    
    // MARK: - GenAiDataSource
    func testGetAiResponseGemini() async throws {
        let response = try await GenAiDataSource.getAiResponse(promptModel: promptModelGemini)
        XCTAssert(response.response?.isEmpty == false)
    }
    
    // License for OpenAI needed
    //    func testGetAiResponseChatGPT() async throws {
    //        let promptModel = GenAiPromptModel(prompt: "How are you today?", service: .ChatGPT)
    //        let response = try await GenAiDataSource.getAiResponse(promptModel: promptModel)
    //        XCTAssert(response.response?.isEmpty == false)
    //    }
    
    // MARK: - GeminiService
    func testGeminiService_ResponseToPrompt() async throws {
        let prompt = "I'm conducting unit testing."
        let response = try await GeminiService.response(toPrompt: prompt)
        XCTAssert(response?.isEmpty == false)
    }
    
    // MARK: - OpenAiService
    // License for OpenAI needed
    //    func testOpenAiResponseToPrompt() async throws {
    //        let prompt = "I'm conducting unit testing."
    //        let response = try await OpenAiService.response(toPrompt: prompt)
    //        XCTAssert(response?.isEmpty == false)
    //    }
    
}
