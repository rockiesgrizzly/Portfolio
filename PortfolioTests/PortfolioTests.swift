//
//  PortfolioTests.swift
//  PortfolioTests
//
//  Created by joshmac on 9/1/24.
//

import XCTest
@testable import Portfolio

final class PortfolioTests: XCTestCase {

    func testPromptSuccess() async throws {
        let prompt = "Which young NFL quarterback has the best chance at MVP this year?"
        
        if let response = try await GeminiService.response(toPrompt: prompt) {
            XCTAssert(!response.isEmpty, "Response received: \(response)")
        } else {
            XCTFail("No response received.")
        }

    }

}
