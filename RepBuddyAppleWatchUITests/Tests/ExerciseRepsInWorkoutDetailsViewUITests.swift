//
//  ExerciseRepsInWorkoutDetailsViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class ExerciseRepsInWorkoutDetailsViewUITests: XCTestCase {
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

    func test_OnAppearWithNoRepSets_ViewDisplaysCorrectly() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        helpers.exerciseInWorkoutDetailsViewChartButton.tap()

        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNavigationTitle.exists, "'Sets' should be the navigation title")
        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNoDataFoundCreateSetButton.exists, "The user should get prompted to add a set to the Exercise")
        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNoDataText.exists, "The user should see a message telling them they haven't created any sets for the Exercise")
    }

    func test_CreatedExerciseRepSet_AppearsInList() {
        helpers.createTestExerciseAndAddRepSet()
        helpers.exerciseInWorkoutDetailsViewChartButton.tap()

        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewTestRepSetListRow.exists, "The RepSet should be visible in the list")
        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNavigationTitle.exists, "The 'Sets' navigation title should still be visible")
    }

    func test_OnDeleteRepSet_ListIsUpdatedAccordingly() {
        helpers.createTestExerciseAndAddRepSet()
        helpers.exerciseInWorkoutDetailsViewChartButton.tap()
        helpers.exerciseRepsInWorkoutDetailsViewTestRepSetListRow.tap()
        app.swipeUp()
        helpers.deleteSetButton.tap()
        _ = helpers.deleteConfirmationAlertYesButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNavigationTitle.waitForExistence(timeout: 5), "'Sets' should be the navigation title")
        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNoDataFoundCreateSetButton.exists, "The user should get prompted to add a set to the Exercise")
        XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNoDataText.exists, "The user should see a message telling them they haven't created any sets for the Exercise")
    }
}
