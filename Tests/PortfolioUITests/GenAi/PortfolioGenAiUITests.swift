//
//  PortfolioUITests.swift
//  PortfolioUITests
//
//  Created by joshmac on 9/1/24.
//

import XCTest

final class PortfolioUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSwiftUIGenAi() throws {
        let button = app.buttons["SwiftUI GenAi"]
        XCTAssertTrue(button.exists)
        button.tap()
        
        let frameworkText = "SwiftUI with Gemini API"
        let frameworkLabel = app.staticTexts[frameworkText]
        XCTAssertEqual(frameworkLabel.label, frameworkText)
        
        let invitationText = "How can artificial intelligence assist you?"
        let invitationLabel = app.staticTexts[invitationText]
        XCTAssertEqual(invitationLabel.label, invitationText)
    }
    
    func testUIKitGenAi() throws {
        let button = app.buttons["UIKit GenAi"]
        XCTAssertTrue(button.exists)
        button.tap()

        let frameworkText = "UIKit with Gemini API"
        let frameworkLabel = app.staticTexts[frameworkText]
        XCTAssertEqual(frameworkLabel.label, frameworkText)
        
        let invitationText = "How can artificial intelligence assist you?"
        let invitationLabel = app.staticTexts[invitationText]
        XCTAssertEqual(invitationLabel.label, invitationText)
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
