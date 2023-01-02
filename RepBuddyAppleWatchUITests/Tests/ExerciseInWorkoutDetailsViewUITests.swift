//
//  ExerciseInWorkoutDetailsViewUITests.swift
//  RepBuddyAppleWatchUITests
//
//  Created by Julian Worden on 12/31/22.
//

import XCTest

final class ExerciseInWorkoutDetailsViewUITests: XCTestCase {
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

    func test_OnAppear_CorrectValuesAreDisplayed() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()

        let exerciseNameText = app.scrollViews.staticTexts["Test"]

        XCTAssertTrue(helpers.detailsNavigationTitle.exists, "The navigation title should be 'Details'")
        XCTAssertTrue(exerciseNameText.exists, "The name of the Exercise should be displayed")
        XCTAssertTrue(helpers.exerciseDetailsSetChart.exists, "A chart showing the Exercise's sets should be displayed")
        XCTAssertTrue(helpers.exerciseDetailsSetChartRuleMark.exists, "A RuleMark showing the Exercise's goal should exist")
        XCTAssertTrue(helpers.exerciseInWorkoutDetailsViewCreateSetButton.exists, "The user should be able to create a set from this view")

        app.swipeUp()

        XCTAssertTrue(helpers.deleteExerciseButton.exists, "The user should be able to delete the Exercise from the Workout by using this view")
    }

    func test_OnDeleteExerciseTapped_DeleteConfirmationAlertAppears() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        app.swipeUp()
        helpers.deleteExerciseButton.tap()
        _ = helpers.deleteConfirmationAlertTitle.waitForExistence(timeout: 5)

        XCTAssertTrue(helpers.deleteConfirmationAlertTitle.exists, "The 'Are You Sure' title should be showing")
        XCTAssertTrue(helpers.deleteExerciseFromWorkoutConfirmationMessage.exists, "The user should see a message telling them what will happen when the Exercise is deleted")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The user should be able to cancel the delete")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The user should be able to confirm the delete")
    }

    func test_OnDeleteExerciseConfirmationCancelButtonTapped_ViewIsDismissed() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        app.swipeUp()
        helpers.deleteExerciseButton.tap()
        _ = helpers.deleteConfirmationAlertCancelButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertCancelButton.tap()

        let exerciseNameHeader = app.scrollViews.staticTexts["Test"]

        XCTAssertTrue(helpers.detailsNavigationTitle.exists, "ExerciseInWorkoutDetailsView should be shown when the delete is cancelled")
        XCTAssertTrue(exerciseNameHeader.exists, "ExerciseInWorkoutDetailsView should be shown when the delete is cancelled")
    }

    func test_OnDeleteExercise_ViewIsDismissed() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        app.swipeUp()
        helpers.deleteExerciseButton.tap()
        _ = helpers.deleteConfirmationAlertYesButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.workoutDetailsViewHeaderTextForWorkoutWithDefaultValues.waitForExistence(timeout: 5), "WorkoutDetailsView should be shown when an Exercise is delete from a Workout")
        XCTAssertTrue(helpers.detailsNavigationTitle.exists, "ExerciseInWorkoutDetailsView should be shown when the delete is cancelled")
    }

    func test_OnEditExercise_ExerciseDetailsHeaderUpdates() {
        helpers.createAndUpdateTestExercise()

        let updatedNameText = app.scrollViews.staticTexts["Test1"]

        XCTAssertTrue(updatedNameText.exists, "The Exercise's updated name should be displayed in the header")
    }
}
