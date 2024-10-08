//
//  GenAiPresentationTests.swift
//  Portfolio
//
//  Created by joshmac on 9/27/24.
//

import XCTest
@testable import Portfolio

final class GenAiPresentationTests: XCTestCase {
    // MARK: - GenAiViewModel
    @MainActor
    func testRespondToPrompt() async throws {
        let viewModel = GenAiViewModel()
        viewModel.userPromptText = "Unit testing. Return anything. Thanks!"
        
        try await viewModel.respond(toPrompt: viewModel.userPromptText)
        XCTAssert(viewModel.response?.response?.isEmpty == false)
    }
}

// MARK: newer Testing framework
import Testing

@Suite("GenAiPresentationTesting")
struct GenAiPresentationTesting {
    @MainActor
    @Test func responseIsNotEmpty() async throws {
        let viewModel = GenAiViewModel()
        viewModel.userPromptText = "Unit testing. Return anything. Thanks!"
        
        try await viewModel.respond(toPrompt: viewModel.userPromptText)
        #expect(viewModel.response?.response?.isEmpty == false)
    }
}
