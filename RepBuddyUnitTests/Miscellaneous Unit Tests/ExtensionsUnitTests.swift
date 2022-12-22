//
//  ExtensionsUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//
@testable import RepBuddy

import XCTest

final class ExtensionsUnitTests: XCTestCase {
    func test_StringIsReallyEmptyExtension_WorksAsExpected() {
        let emptyStringWithSpace = "  "
        let emptyStringWithNoSpace = ""
        let emptyStringSpaceAndCharacter = "    b"

        XCTAssertTrue(emptyStringWithSpace.isReallyEmpty, "The string should be considered empty since it only has spaces")
        XCTAssertTrue(emptyStringWithNoSpace.isReallyEmpty, "The string should be considered empty")
        XCTAssertFalse(emptyStringSpaceAndCharacter.isReallyEmpty, "The string has a character at the end, so it's not empty")
    }

    func test_DateNumericDateNoTimeExtension_WorksAsExpected() {
        let dateFormattedNormally = Date.now.formatted(date: .numeric, time: .omitted)
        let dateFormattedWithExtension = Date.now.numericDateNoTime

        XCTAssertEqual(dateFormattedNormally, dateFormattedWithExtension, "The date formatted with the extension should match the .numeric date and .omitted time format")
    }
}
