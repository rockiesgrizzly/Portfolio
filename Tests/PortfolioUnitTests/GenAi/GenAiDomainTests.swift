//
//  GenAiDomainTests.swift
//  PortfolioTests
//
//  Created by joshmac on 9/27/24.
//

import XCTest
@testable import Portfolio

final class GenAiDomainTests: XCTestCase {
    let promptModelGemini = GenAiPromptModel(prompt: "Running unit tests. Any response will do. Thanks.", service: .Gemini)
    
    // MARK: - GenAiGetResponseUseCase
    func testGenAiGetResponseUseCaseExecutePromptModel() async throws {
        let response = try await GenAiGetUseCaseImplementation.execute(promptModel: promptModelGemini)
        XCTAssertNotNil(response)
    }
}
