//
//  WorkoutDetailsViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class WorkoutDetailsViewUITests: XCTestCase {
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

    func test_OnCreateWorkout_WorkoutDetailsHeaderDisplaysCorrectValues() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()

        let workoutTypeHeaderText = app.scrollViews.staticTexts["Arms Workout"]
        let workoutDate = app.scrollViews.staticTexts[Date.now.numericDateNoTime]
        let armsWorkoutImage = app.scrollViews.images["Arms"]

        XCTAssertTrue(workoutTypeHeaderText.exists, "The type of workout should be displayed")
        XCTAssertTrue(workoutDate.exists, "The date of the workout should exist")
        XCTAssertTrue(armsWorkoutImage.exists, "An image corresponding to the workout type should be displayed")
        XCTAssertTrue(helpers.workoutDetailsViewNavigationTitle.exists, "'Details' should be displayed in the navigation bar")
    }

    func test_OnEditWorkout_WorkoutDetailsHeaderDisplaysCorrectValues() {
        helpers.createAndUpdateTestWorkout()

        let legsWorkoutHeader = app.scrollViews.staticTexts["Legs Workout"]
        let legImage = app.scrollViews.images["Legs"]

        XCTAssertTrue(legsWorkoutHeader.exists, "'Legs Workout' is the updated workout type and it should be displayed")
        XCTAssertTrue(legImage.exists, "The Legs image should be displayed for the updated workout type")
    }

    func test_OnAddExerciseToWorkout_WorkoutDetailsViewShowsWorkoutGroupBox() {
        helpers.createTestExerciseAndAddToNewWorkout()

        XCTAssertTrue(helpers.workoutDetailsViewTestExerciseButton.exists, "The Test workout should be displayed in WorkoutDetailsView after being added to the Workout")
        XCTAssertTrue(helpers.workoutDetailsExerciseSetChart.exists, "The GroupBox in WorkoutDetailsView should contain a chart for the exercise's sets")
        XCTAssertTrue(helpers.workoutDetailsExerciseSetChartGoalText.exists, "The exercise set chart should display the exercise's goal")
    }

    func test_OnWorkoutDetailsViewDeleteExerciseButtonTapped_ConfirmationAlertAppears() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewDeleteTestExerciseButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlert.exists, "A confirmation alert should be shown when the delete button is pressed for an exercise.")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The delete confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The delete confirmation alert should have a Yes button")
    }

    func test_OnWorkoutDetailsViewDeleteExercise_ExerciseIsDeletedFromWorkout() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewDeleteTestExerciseButton.tap()
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertFalse(helpers.deleteConfirmationAlert.exists, "The confirmation alert should no longer show after pressing Yes")
        XCTAssertFalse(helpers.workoutDetailsViewTestExerciseButton.exists, "The Test Exercise should no longer show in WorkoutDetailsView after it's been deleted")
    }

    func test_OnCancelButtonTap_WorkoutDetailsDeleteConfirmationAlertDismisses() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewDeleteTestExerciseButton.tap()
        helpers.deleteConfirmationAlertCancelButton.tap()

        XCTAssertFalse(helpers.deleteConfirmationAlert.exists, "The confirmation alert should no longer show after pressing Cancel")
    }

}
