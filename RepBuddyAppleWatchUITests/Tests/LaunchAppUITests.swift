//
//  LaunchAppUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class LaunchAppUITests: XCTestCase {
    var app: XCUIApplication!
    var helpers: UITestHelpers!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()

        helpers = UITestHelpers(app: app)
    }

    override func tearDownWithError() throws { }

    /// Swipes the screen to move between Views to confirm that two
    /// tabs exist. It appears that referencing the TabView directly via
    /// an .accessibilityIdentifier is not possible, hence this approach.
    func test_LaunchApp_TabViewExists() {
        XCTAssertTrue(helpers.exercisesNavigationTitle.exists, "The ExercisesView should be shown by default")

        app.swipeLeft()

        XCTAssertTrue(helpers.workoutsNavigationTitle.exists, "The WorkoutsView should be shown when the user swipes left")

        app.swipeRight()

        XCTAssertTrue(helpers.exercisesNavigationTitle.exists, "The ExercisesView should be shown when the user swipes right on WorkoutsView")
    }
}
