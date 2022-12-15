//
//  RepBuddyUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/14/22.
//

import XCTest

final class ExercisesViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }

    override func tearDownWithError() throws { }

    func test_NoExercisesExists_TextIsShownAndEditButtonIsHidden() {
        let noDataFoundText = app.staticTexts["You haven't created any exercises. Use the plus button to create one!"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertTrue(noDataFoundText.exists)
        XCTAssertFalse(editButton.exists)
    }

    func test_ExerciseAdded_RowAndEditButtonExist() {
        app.navigationBars["Exercises"].buttons["Add"].tap()

        app.collectionViews.textFields["Name (required)"].tap()

        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.collectionViews.buttons["Save Exercise"].tap()

        let noDataFoundText = app.staticTexts["You haven't created any exercises. Use the plus button to create one!"]
        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let testExerciseRowDescription = app.collectionViews.staticTexts["Goal: 20 Pounds"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertEqual(app.collectionViews.activityIndicators.count, 1, "One exercise should be shown")
        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(testExerciseRowDescription.exists, "The exercise's goal should be displayed")
        XCTAssertTrue(editButton.exists, "The EditButton should be shown")
        XCTAssertFalse(noDataFoundText.exists, "The user should see an exercise, not a 'no data found' message")
    }

    func test_EditedExerciseGoal_DisplaysInExercisesList() {
        app.navigationBars["Exercises"].buttons["Add"].tap()

        app.collectionViews.textFields["Name (required)"].tap()

        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()

        app.collectionViews.textFields["Weight goal"].tap()

        app.keys["delete"].tap()
        app.keys["more"].tap()
        app.keys["5"].tap()

        app.collectionViews.buttons["Kilograms"].tap()
        app.collectionViews.buttons["Save Exercise"].tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 25 Kilograms"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "The updated Exercise goal should update in the UI")
    }
}
