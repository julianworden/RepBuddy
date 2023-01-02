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

    func test_OnCancelButtonTapped_AddEditWorkoutViewIsDismissed() {
        helpers.navigateToWorkoutsTab()
        helpers.createWorkoutNoDataFoundButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.workoutsNavigationTitle.exists, "WorkoutsView should be presented after pressing AddEditWorkoutView's Cancel button")
    }

    func test_OnCancelButtonTap_AddEditWorkoutDeleteConfirmationAlertDismisses() {
        helpers.createTestWorkoutWithDefaultValues()
        helpers.testWorkoutListRowWithDefaultValues.tap()
        helpers.detailsViewEditButton.tap()
        app.swipeUp()
        helpers.deleteWorkoutButton.tap()
        _ = helpers.deleteConfirmationAlertCancelButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertCancelButton.tap()
        sleep(2)

        XCTAssertFalse(helpers.deleteConfirmationAlertTitle.exists, "The confirmation alert should no longer show after pressing Cancel")
    }

    func test_OnCreateWorkout_SaveButtonTextIsCorrect() {
        helpers.navigateToWorkoutsTab()
        helpers.createWorkoutNoDataFoundButton.tap()

        XCTAssertTrue(helpers.saveWorkoutButton.exists, "The button should read 'Save Workout'")
    }

    func test_OnEditWorkout_AllAddEditWorkoutViewValuesAreCorrect() {
        helpers.createTestWorkoutWithNonDefaultValues()
        helpers.testWorkoutListRowWithNonDefaultValues.tap()
        helpers.detailsViewEditButton.tap()

        let legsPickerButton = app.collectionViews.buttons["Type, Legs"]

        XCTAssertTrue(helpers.updateWorkoutButton.exists, "The button should say 'Update Workout'")
        XCTAssertTrue(legsPickerButton.exists, "The non-default Legs Workout type should be shown in the picker")
    }

    func test_OnDeleteWorkoutTapped_ConfirmationAlertExists() {
        helpers.createTestWorkoutWithDefaultValues()
        helpers.testWorkoutListRowWithDefaultValues.tap()
        helpers.detailsViewEditButton.tap()
        helpers.deleteWorkoutButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlertTitle.exists, "The alert's title should be displayed")
        XCTAssertTrue(helpers.deleteWorkoutConfirmationAlertMessage.exists, "The alert's delete confirmation message should be displayed")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    func test_OnDeleteWorkout_WorkoutsViewIsPresented() {
        helpers.createTestWorkoutWithDefaultValues()
        helpers.testWorkoutListRowWithDefaultValues.tap()
        helpers.detailsViewEditButton.tap()
        app.swipeUp()
        helpers.deleteWorkoutButton.tap()
        _ = helpers.deleteConfirmationAlertYesButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.workoutsNavigationTitle.waitForExistence(timeout: 5), "WorkoutsView should be presented after a Workout is deleted")
    }
}
