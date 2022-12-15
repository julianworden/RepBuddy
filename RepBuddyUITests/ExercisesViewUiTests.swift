//
//  RepBuddyUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/14/22.
//

import XCTest

final class ExercisesViewUiTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }

    override func tearDownWithError() throws { }

    func test_LaunchApp_ExercisesTabNavigationTitleExists() {
        let navigationTitle = app.navigationBars["Exercises"]
        XCTAssertTrue(navigationTitle.exists)
    }

    func test_LaunchApp_TabViewExists() {
        let tabBar = app
            .tabBars["Tab Bar"]
        let exercisesTabButton = app
            .tabBars["Tab Bar"]
            .buttons["Exercises"]
        let workoutsTabButton = app
            .tabBars["Tab Bar"]
            .buttons["Workouts"]

        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(exercisesTabButton.exists)
        XCTAssertTrue(workoutsTabButton.exists)
    }

    func test_LaunchApp_ExercisesTabIsSelected() {
        let exercisesTabButton = app
            .tabBars["Tab Bar"]
            .buttons["Exercises"]

        XCTAssertTrue(exercisesTabButton.isSelected)
    }

    func test_LaunchApp_PlusNavigationBarButtonExists() {
        let plusNavigationBarButton = app
            .navigationBars["Exercises"]
            .buttons["Add"]

        XCTAssertTrue(plusNavigationBarButton.exists)
    }

    func test_WhenNoExercisesExists_TextIsShown() {
        let noDataFoundText = app
            .staticTexts["You haven't created any exercises. Use the plus button to create one!"]

        XCTAssertTrue(noDataFoundText.exists)
    }

    func test_ExerciseAdded_RowDisplays() {
        app.navigationBars["Exercises"].buttons["Add"].tap()

        app.collectionViews.textFields["Name (required)"].tap()

        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.buttons["Save Exercise"].tap()

        XCTAssertEqual(app.collectionViews.activityIndicators.count, 1, "One exercise should be shown in ExercisesView.")
        XCTAssertTrue(app.collectionViews.staticTexts["Test"].exists, "An exercise named 'test' should be displayed in ExercisesView")
    }
}
