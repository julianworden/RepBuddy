//
//  AddEditRepSetViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class AddEditRepSetViewUITests: XCTestCase {
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

    func test_OnCancelButtonTapped_AddEditRepSetViewIsDismissed() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        helpers.exerciseInWorkoutDetailsViewCreateSetButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.detailsNavigationTitle.exists, "WorkoutDetailsView should be visible after AddEditRepSetView is dismissed")
    }

    func test_OnCreateSetFromExerciseInWorkoutDetailsView_SaveButtonTextIsCorrect() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        helpers.exerciseInWorkoutDetailsViewCreateSetButton.tap()
        app.swipeUp()

        XCTAssertTrue(helpers.addEditRepSetViewCreateSetButton.exists, "A button that reads 'Create Set' should exist'")
    }

    func test_OnCreateSetFromRepSetsListView_SaveButtonTextIsCorrectAndDeleteButtonDoesNotExist() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        helpers.exerciseInWorkoutDetailsViewChartButton.tap()
        helpers.exerciseRepsInWorkoutDetailsViewNoDataFoundCreateSetButton.tap()
        app.swipeUp()

        XCTAssertTrue(helpers.addEditRepSetViewCreateSetButton.exists, "A button that reads 'Create Set' should exist'")
        XCTAssertFalse(helpers.deleteSetButton.exists, "The Delete Set button shouldn't exist")
    }

    func test_OnEditRepSet_SaveAndDeleteButtonsAppearCorrectly() {
        helpers.createTestExerciseAndAddRepSet()
        helpers.exerciseInWorkoutDetailsViewChartButton.tap()
        helpers.exerciseRepsInWorkoutDetailsViewTestRepSetListRow.tap()
        app.swipeUp()

        XCTAssertTrue(helpers.updateSetButton.exists, "The button should read 'Update Set'")
        XCTAssertTrue(helpers.deleteSetButton.exists, "There should be a Delete Set button")
    }

    func test_OnDeleteSetButtonTapped_DeleteConfirmationAlertAppears() {
        helpers.createTestExerciseAndAddRepSet()
        helpers.exerciseInWorkoutDetailsViewChartButton.tap()
        helpers.exerciseRepsInWorkoutDetailsViewTestRepSetListRow.tap()
        app.swipeUp()
        helpers.deleteSetButton.tap()
        _ = helpers.deleteConfirmationAlertTitle.waitForExistence(timeout: 5)

        XCTAssertTrue(helpers.deleteConfirmationAlertTitle.exists, "'Are You Sure?' should be the title of the alert")
        XCTAssertTrue(helpers.deleteRepSetConfirmationAlertMessage.exists, "The user should see a message explaining what will happen after deleting the RepSet")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The user should be able to cancel the delete")
    }
}
