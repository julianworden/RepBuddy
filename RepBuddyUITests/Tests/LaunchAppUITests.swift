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

    func test_LaunchApp_ExercisesTabNavigationTitleExists() {
        XCTAssertTrue(helpers.exercisesNavigationTitle.exists)
    }

    func test_LaunchApp_TabViewExists() {
        let tabBar = app.tabBars["Tab Bar"]
        let exercisesTabButton = app.tabBars["Tab Bar"].buttons["Exercises"]
        let workoutsTabButton = app.tabBars["Tab Bar"].buttons["Workouts"]

        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(exercisesTabButton.exists)
        XCTAssertTrue(workoutsTabButton.exists)
    }

    func test_LaunchApp_TabViewHasTwoTabs() {
        let tabBar = app.tabBars["Tab Bar"]

        XCTAssertEqual(tabBar.buttons.count, 2, "There should be two tab bars in RootView's TabView")
    }

    func test_LaunchApp_ExercisesTabIsSelected() {
        let exercisesTabButton = app.tabBars["Tab Bar"].buttons["Exercises"]

        XCTAssertTrue(exercisesTabButton.isSelected)
    }

    func test_LaunchApp_PlusNavigationBarButtonExists() {
        let plusNavigationBarButton = app.navigationBars["Exercises"].buttons["Add"]

        XCTAssertTrue(plusNavigationBarButton.exists)
    }
}
