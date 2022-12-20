//
//  AddEditWorkoutViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class AddEditWorkoutViewUITests: XCTestCase {
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

    func test_OnSwipeDown_WorkoutDetailsViewIsDismissed() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()
        helpers.navigationBar.swipeDown()

        XCTAssertFalse(helpers.addWorkoutNavigationTitle.exists, "The user should be able to swipe down to dismiss AddEditWorkoutView")
    }

    func test_OnCancelButtonTapped_AddEditWorkoutViewIsDismissed() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertFalse(helpers.addWorkoutNavigationTitle.exists, "WorkoutsView should be presented after pressing AddEditExerciseView's Cancel button")
    }

    func test_OnAppear_AddEditWorkoutViewContainsThreeCells() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()

        XCTAssertEqual(app.collectionViews.cells.count, 3, "AddEditWorkoutView's Form should have 3 cells")
    }

    func test_OnAppear_AddEditWorkoutFormContainsThreeCells() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()

        XCTAssertEqual(app.collectionViews.cells.count, 3, "There should be 3 rows in the Form")
    }

    func test_AddEditWorkoutViewCancelButtonWorks() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.workoutsNavigationTitle.exists, "WorkoutsView should be presented after pressing AddEditWorkoutView's Cancel button")
    }

    func test_OnCreateWorkout_NavigationTitleAndSaveButtonAreCorrect() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()

        XCTAssertTrue(helpers.addWorkoutNavigationTitle.exists, "The navigation title should be 'Add Workout' when a Workout is being created")
        XCTAssertTrue(helpers.saveWorkoutButton.exists, "The button should read 'Save Workout'")
    }

    func test_OnEditWorkout_NavigationTitleAndSaveButtonAreCorrect() {
        helpers.workoutsTabButton.tap()
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()

        XCTAssertTrue(helpers.editWorkoutNavigationTitle.exists, "The navigation title should be 'Edit Workout' when a Workout is being edited")
        XCTAssertTrue(helpers.updateWorkoutButton.exists, "The button should say 'Update Workout'")
    }

    func test_OnDeleteWorkoutTapped_ConfirmationAlertExists() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteWorkoutButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlert.exists, "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    func test_OnDeleteWorkout_WorkoutsViewIsPresented() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteWorkoutButton.tap()
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.workoutsNavigationTitle.waitForExistence(timeout: 2), "WorkoutsView should be presented after a Workout is deleted")
    }

    func test_OnCancelButtonTap_AddEditWorkoutDeleteConfirmationAlertDismisses() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteWorkoutButton.tap()
        helpers.deleteConfirmationAlertCancelButton.tap()

        XCTAssertFalse(helpers.deleteConfirmationAlert.exists, "The confirmation alert should no longer show after pressing Cancel")
    }
}
