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

    func test_OnSwipeDown_AddEditExerciseViewIsDismissed() {
        helpers.navigationBarAddButton.tap()
        helpers.navigationBar.swipeDown()

        XCTAssertFalse(helpers.addExerciseToWorkoutViewNavigationTitle.exists, "The user should be able to swipe down to dismiss AddEditExerciseView")
    }

    func test_OnCancelButtonTapped_AddEditExerciseViewIsDismissed() {
        helpers.navigationBarAddButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertFalse(helpers.addExerciseToWorkoutViewNavigationTitle.exists, "ExercisesView should be presented after pressing AddEditExerciseView's Cancel button")
    }

    func test_OnAppear_AddEditExerciseFormContainsFiveCells() {
        helpers.navigationBarAddButton.tap()

        // Section header counts as a cell, hence 5
        XCTAssertEqual(app.collectionViews.cells.count, 5, "There should be 4 rows in the Form")
    }

    func test_OnCreateExercise_NavigationTitleAndSaveButtonsAreCorrect() {
        helpers.navigationBarAddButton.tap()

        XCTAssertTrue(helpers.addExerciseToWorkoutViewNavigationTitle.exists, "The navigation title should be 'Add Exercise' when an Exercise is being created")
        XCTAssertTrue(helpers.saveExerciseButton.exists, "The button should read 'Save Exercise'")
    }

    func test_OnEditExercise_NavigationTitleAndSaveButtonsAreCorrect() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.navigationBarEditButton.tap()

        XCTAssertTrue(helpers.editExerciseNavigationTitle.exists, "The navigation title should be 'Edit Exercise' when an Exercise is being edited")
        XCTAssertTrue(helpers.updateExerciseButton.exists, "The button should read 'Update Exercise'")
    }

    func test_OnDeleteExerciseTapped_ConfirmationAlertExists() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.navigationBarEditButton.tap()

        helpers.deleteExerciseButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlert.exists, "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    func test_OnDeleteExercise_ExercisesViewIsPresented() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteExerciseButton.tap()
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.exercisesNavigationTitle.waitForExistence(timeout: 2), "ExercisesView should be presented after an Exercise is deleted")
    }

    func test_OnCancelButtonTap_AddEditExerciseDeleteConfirmationAlertDismisses() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteExerciseButton.tap()
        helpers.deleteConfirmationAlertCancelButton.tap()

        XCTAssertFalse(helpers.deleteConfirmationAlert.exists, "The confirmation alert should no longer show after pressing Cancel")
    }
}
