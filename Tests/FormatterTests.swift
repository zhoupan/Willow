//
//  FormatterTests.swift
//  Timber
//
//  Created by Christian Noon on 11/24/14.
//  Copyright (c) 2014 Nike. All rights reserved.
//

import UIKit
import XCTest

import Timber

class DefaultFormatterTestCase: TimberTestCase {
    
    func testThatItFormatsMessagesAsExpected() {
        
        // Given
        let formatter = DefaultFormatter()
        let message = "Test Message"
        let logLevels: [Logger.LogLevel] = [.Error, .Warn, .Event, .Info, .Debug]
        
        // When
        var actualMessages = logLevels.map { formatter.formatMessage(message, logLevel: $0) }
        
        // Then
        for (index, logLevel) in enumerate(logLevels) {
            let expectedMessage = "2014-10-03 08:20:45.000 [\(logLevel)] \(message)"
            XCTAssertEqual(actualMessages[index], expectedMessage, "Actual formatted message should equal the expected message")
        }
    }
}

// MARK: -

class ColorFormatterTestCase: XCTestCase {
    
    // MARK: - Private Properties
    
    var message = ""
    let escape = "\u{001b}["
    let reset = "\u{001b}[;"
    
    // MARK: - Setup / Teardown
    
    override func setUp() {
        self.message = "Test Message"
    }
    
    override func tearDown() {
        self.message = ""
    }
    
    // MARK: - Tests
    
    func testThatItAppliesForegroundColors() {
        
        // Given
        let red = UIColor(red: 0.95, green: 0.0, blue: 0.0, alpha: 1.0)
        let colorFormatter = ColorFormatter(foregroundColor: red, backgroundColor: nil)
        
        // When
        let coloredMessage = colorFormatter.formatMessage(self.message, logLevel: .Debug)
        
        // Then
        let expected = "\(self.escape)fg242,0,0;Test Message\(self.reset)"
        XCTAssertEqual(expected, coloredMessage, "Applying the foreground color formatting failed")
    }
    
    func testThatItAppliesBackgroundColors() {

        // Given
        let blue = UIColor(red: 45.0 / 255.0, green: 145.0 / 255.0, blue: 1.0, alpha: 1.0)
        let colorFormatter = ColorFormatter(foregroundColor: nil, backgroundColor: blue)
        
        // When
        let coloredMessage = colorFormatter.formatMessage(self.message, logLevel: .Debug)
        
        // Then
        let expected = "\(self.escape)bg45,145,255;Test Message\(self.reset)"
        XCTAssertEqual(expected, coloredMessage, "Applying the background color formatting failed")
    }
    
    func testThatItAppliesBothColors() {

        // Given
        let purple = UIColor(red: 153.0 / 255.0, green: 63.0 / 255.0, blue: 1.0, alpha: 1.0)
        let green = UIColor(red: 136.0 / 255.0, green: 207.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
        let colorFormatter = ColorFormatter(foregroundColor: purple, backgroundColor: green)
        
        // When
        let coloredMessage = colorFormatter.formatMessage(self.message, logLevel: .Debug)
        
        // Then
        let expected = "\(self.escape)fg153,63,255;\(self.escape)bg136,207,8;Test Message\(self.reset)"
        XCTAssertEqual(expected, coloredMessage, "Applying color formatting for both colors failed")
    }
}
