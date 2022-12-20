//
//  ExercisesViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class ExercisesViewUITests: XCTestCase {
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

    func test_NoExercisesExist_TextIsShownAndEditButtonIsHidden() {
        let noDataFoundText = app.staticTexts["You haven't created any exercises. Use the plus button to create one!"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertTrue(noDataFoundText.exists)
        XCTAssertFalse(editButton.exists)
    }

    func test_ExerciseCreated_RowAndEditButtonExist() {
        helpers.createTestExercise()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let testExerciseRowDescription = app.collectionViews.staticTexts["Goal: 20 Pounds"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertEqual(app.collectionViews.activityIndicators.count, 1, "One exercise should be shown")
        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(testExerciseRowDescription.exists, "The exercise's goal should be displayed")
        XCTAssertTrue(editButton.exists, "The EditButton should be shown")
        XCTAssertFalse(helpers.noExercisesFoundText.exists, "The user should see an Exercise, not a 'no data found' message")
    }

    func test_ExerciseCreatedWithNonDefaultValues_DisplaysCorrectValueInExercisesList() {
        helpers.navigationBarAddButton.tap()

        helpers.typeTestExerciseName()

        app.collectionViews.textFields["Weight goal"].tap()

        app.typeText("0")

        app.collectionViews.buttons["Kilograms"].tap()
        helpers.saveExerciseButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 200 Kilograms"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "'200 Kilograms' should be displayed")
    }

    func test_EditedExercise_DisplaysUpdatedValuesInExercisesList() {
        helpers.createAndUpdateTestExercise()

        helpers.exerciseDetailsViewBackButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test1"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 200 Pounds"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test1' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "The updated Exercise goal should update to '200 Pounds' in the UI")
    }

    func test_OnExerciseDelete_ExerciseIsDeletedAndNoDataTextDisplays() {
        helpers.createTestExercise()
        helpers.navigationBarEditButton.tap()
        helpers.minusButtonInEditMode.tap()
        helpers.rowDeleteButton.tap()

        XCTAssertTrue(helpers.noExercisesFoundText.exists, "The no data found text should display after all Exercises are deleted")
        XCTAssertFalse(helpers.navigationBarEditButton.exists, "The Edit button should not be shown after all Exercises are deleted")
        XCTAssertEqual(app.collectionViews.count, 0, "The ExercisesList should no longer appear after all Exercises are deleted")
    }

    func test_OnSwipeToDeleteExercise_WorkoutIsDeleted() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.swipeLeft()
        helpers.rowDeleteButton.tap()

        XCTAssertTrue(helpers.noExercisesFoundText.exists, "No Exercises should appear after swipe to delete")
        XCTAssertEqual(app.collectionViews.count, 0, "ExercisesList should no longer exist after deleting all workouts")
    }

    /// If all exercises are deleted by using the EditButton, by default editMode == .active,
    /// even when no exercises are visible. This tests that this is not happening, as
    /// editMode should equal .inactive when adding an Exercise to an empty list.
    func test_AllExercisesDeleted_EditModeIsDisabled() {
        helpers.createTestExercise()
        helpers.navigationBarEditButton.tap()
        helpers.minusButtonInEditMode.tap()
        helpers.rowDeleteButton.tap()
        helpers.createTestExercise()

        XCTAssertTrue(helpers.navigationBarEditButton.exists, "The Edit button should exist if the list is populated")
        XCTAssertFalse(helpers.minusButtonInEditMode.exists, "Edit mode should be disabled when an exercise is added after the exercises array was emptied")
    }
}
