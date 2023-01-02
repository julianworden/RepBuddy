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

    func test_OnCreateWorkout_ViewDisplaysCorrectValues() {
        helpers.createTestWorkoutWithDefaultValues()
        helpers.testWorkoutListRowWithDefaultValues.tap()

        XCTAssertTrue(helpers.workoutDetailsViewHeaderTextForWorkoutWithDefaultValues.exists, "The Workout's type and date should be displayed at the top of th e view")
        XCTAssertTrue(helpers.workoutDetailsViewNoExercisesAddedNoDataFoundText.exists, "The user should see a message telling them that there are no Exercises in the workout")
        XCTAssertFalse(helpers.workoutDetailsViewExercisesSectionHeader.exists, "The 'Exercises' section title shouldn't exist until Exercises are added to the Workout")
        XCTAssertTrue(helpers.workoutDetailsViewAddExerciseButton.exists, "There should be a button prompting the user to add an Exercise to the Workout")
    }

    func test_OnEditWorkout_WorkoutDetailsHeaderDisplaysCorrectValues() {
        helpers.createAndUpdateTestWorkout()

        let headerText = app.scrollViews.staticTexts["Legs Workout on \(Date.now.numericDateNoTime)"]

        XCTAssertTrue(headerText.exists, "The Workout's updated type should be displayed at the top of the view")
    }

    func test_OnAddExerciseToWorkout_ViewUpdatesAccordingly() {
        helpers.createTestExerciseAndAddToNewWorkout()

        XCTAssertTrue(helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.exists, "The newly added Exercise should be shown in the Exercises section")
        XCTAssertTrue(helpers.workoutDetailsViewExercisesSectionHeader.exists, "The 'Exercises' section title should exist now that an Exercise has been added")
        XCTAssertTrue(helpers.workoutDetailsViewAddExerciseButton.exists, "The user should still be able to add other Exercises to the Workout")
    }

    func test_OnExerciseInWorkoutDeleted_ViewUpdatesAccordingly() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        app.swipeUp()
        helpers.exerciseInWorkoutDetailsViewDeleteExerciseButton.tap()
        _ = helpers.deleteConfirmationAlertYesButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.workoutDetailsViewHeaderTextForWorkoutWithDefaultValues.waitForExistence(timeout: 5), "The Workout's type and date should be displayed at the top of th e view")
        XCTAssertTrue(helpers.workoutDetailsViewNoExercisesAddedNoDataFoundText.exists, "The user should see a message telling them that there are no Exercises in the workout")
        XCTAssertFalse(helpers.workoutDetailsViewExercisesSectionHeader.exists, "The 'Exercises' section title shouldn't exist until Exercises are added to the Workout")
        XCTAssertTrue(helpers.workoutDetailsViewAddExerciseButton.exists, "There should be a button prompting the user to add an Exercise to the Workout")
    }
}
