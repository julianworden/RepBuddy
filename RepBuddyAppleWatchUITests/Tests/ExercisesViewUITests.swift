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

    func test_NoExercisesExist_NoDataTextIsShown() {
        let noDataFoundText = app.staticTexts["You haven't created any exercises."]
        let createExerciseButton = helpers.createExerciseNoDataFoundButton

        XCTAssertTrue(noDataFoundText.exists)
        XCTAssertTrue(createExerciseButton.exists)
    }

    /// This test does not test the stepper, as it doesn't appear that it's possible to reference a watchOS stepper in UI Testing. All attempts
    /// have failed, it's possible that this hasn't been implemented yet because watchOS UI Steppers were only released about 3 months ago.
    func test_ExerciseCreated_DisplaysInExercisesListAndCreateExerciseToolbarButtonExists() {
        helpers.createExerciseNoDataFoundButton.tap()
        // Not sure if this waitForExistence keeps this test from failing occassionally
        _ = helpers.addEditExerciseNameTextField.waitForExistence(timeout: 5)
        helpers.typeTestExerciseName()
        app.swipeUp()
        helpers.addEditExerciseKilogramsButton.tap()
        helpers.saveExerciseButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 60 Kilograms"]

        XCTAssertTrue(helpers.navigationBarCreateExerciseButton.exists, "The user should be able to create an Exercise")
        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "'60 Kilograms' should be displayed")
    }

    func test_EditedExercise_DisplaysUpdatedValuesInExercisesList() {
        helpers.createAndUpdateTestExercise()

        helpers.navigationBarBackButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test1"]
        // The weight is not actually an updated value yet, as referencing a stepper on watchOS doesn't appear to be possible
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 60 Kilograms"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test1' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "The Exercise goal should be listed on the UI")
    }

    func test_OnExerciseDelete_NoDataTextAndCreateExerciseButtonDisplay() {
        helpers.createTestExerciseWithDefaultValues()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.detailsViewEditButton.tap()
        app.swipeUp()
        helpers.deleteExerciseButton.tap()
        _ = helpers.deleteConfirmationAlertYesButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.noExercisesFoundText.waitForExistence(timeout: 5), "The no data found text should display after all Exercises are deleted")
        XCTAssertTrue(helpers.createExerciseNoDataFoundButton.exists, "The 'Create Exercise' Button should appear when no Exercises exist")
    }
}
