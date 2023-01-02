//
//  AddEditExerciseViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class AddEditExerciseViewUITests: XCTestCase {
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

    func test_OnCancelButtonTapped_AddEditExerciseViewIsDismissed() {
        helpers.createExerciseNoDataFoundButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.exercisesNavigationTitle.exists, "ExercisesView should be presented after pressing AddEditExerciseView's Cancel button")
    }

    func test_OnCreateExercise_SaveExerciseButtonTextIsCorrect() {
        helpers.createExerciseNoDataFoundButton.tap()
        app.swipeUp()

        XCTAssertTrue(helpers.saveExerciseButton.exists, "The button should read 'Save Exercise'")
    }

    func test_OnEditExercise_AllAddEditExerciseViewValuesAreCorrect() {
        helpers.createTestExerciseWithNonDefaultValues()
        helpers.testExerciseWithNonDefaultValuesListRowExercisesView.tap()
        helpers.detailsViewEditButton.tap()

        let nameTextFieldWithExerciseNameTyped = app.collectionViews.textFields["Test"]
        XCTAssertTrue(nameTextFieldWithExerciseNameTyped.exists, "The Exercise's name should appear in the TextField")

        app.swipeUp()

        XCTAssertTrue(helpers.addEditExerciseKilogramsButton.isSelected, "The kilograms button should be selected")
        XCTAssertTrue(helpers.updateExerciseButton.exists, "The button should read 'Update Exercise'")
    }

    func test_OnDeleteExerciseTapped_ConfirmationAlertExists() {
        helpers.createTestExerciseWithDefaultValues()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.detailsViewEditButton.tap()
        app.swipeUp()
        helpers.deleteExerciseButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlertTitle.waitForExistence(timeout: 5), "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(helpers.deleteExerciseConfirmationAlertMessage.exists, "A message with more info should be shown to the user")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    func test_OnDeleteExercise_ExercisesViewIsPresented() {
        helpers.createTestExerciseWithDefaultValues()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.detailsViewEditButton.tap()
        app.swipeUp()
        helpers.deleteExerciseButton.tap()
        _ = helpers.deleteConfirmationAlertYesButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.exercisesNavigationTitle.waitForExistence(timeout: 5), "ExercisesView should be presented after an Exercise is deleted")
    }

    func test_OnCancelButtonTap_AddEditExerciseDeleteConfirmationAlertDismisses() {
        helpers.createTestExerciseWithDefaultValues()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.detailsViewEditButton.tap()
        helpers.deleteConfirmationAlertCancelButton.tap()

        XCTAssertFalse(helpers.deleteConfirmationAlertTitle.exists, "The delete confirmation alert should've been deleted")
    }
}
