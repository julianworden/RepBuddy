//
//  RepBuddyUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/14/22.
//

import XCTest

final class RepBuddyUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        
    }

    func test_LaunchApp_ExercisesTabNavigationTitleExists() {
        let navigationTitle = app.navigationBars[UITestingConstants.Exercises]
        XCTAssertTrue(navigationTitle.exists)
    }

    func test_LaunchApp_TabViewExists() {
        let tabBar = app
            .tabBars[UITestingConstants.TabBar]
        let exercisesTabButton = app
            .tabBars[UITestingConstants.TabBar]
            .buttons[UITestingConstants.Exercises]
        let workoutsTabButton = app
            .tabBars[UITestingConstants.TabBar]
            .buttons[UITestingConstants.Workouts]

        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(exercisesTabButton.exists)
        XCTAssertTrue(workoutsTabButton.exists)
    }

    func test_LaunchApp_ExercisesTabIsSelected() {
        let exercisesTabButton = app
            .tabBars[UITestingConstants.TabBar]
            .buttons[UITestingConstants.Exercises]

        XCTAssertTrue(exercisesTabButton.isSelected)
    }
}
