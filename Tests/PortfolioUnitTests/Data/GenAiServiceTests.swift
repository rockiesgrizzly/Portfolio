//
//  GenAiServiceTests.swift
//  PortfolioTests
//
//  Created by joshmac on 9/3/24.
//

import XCTest
@testable import Portfolio

final class GenAiServiceTests: XCTestCase {

    func testGeminiResponseToPrompt() async throws {
        let prompt = "I'm conducting unit testing."
        let response = try await GeminiService.response(toPrompt: prompt)
        XCTAssert(response?.isEmpty == false)
    }
    
    func testOpenAiResponseToPrompt() async throws {
        let prompt = "I'm conducting unit testing."
        let response = try await OpenAiService.response(toPrompt: prompt)
        XCTAssert(response?.isEmpty == false)
    }

}
