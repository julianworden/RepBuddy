//
//  AddExerciseToWorkoutViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class AddExerciseToWorkoutViewUITests: XCTestCase {
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

    func test_OnCancelButtonTapped_AddExerciseToWorkoutViewIsDismissed() {
        helpers.createTestWorkoutWithDefaultValues()
        helpers.testWorkoutListRowWithDefaultValues.tap()
        helpers.workoutDetailsViewAddExerciseButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.detailsNavigationTitle.exists, "The user should be able to tap Cancel to dismiss the view")
    }

    func test_NoExercisesCreated_AddExerciseToWorkoutViewDisplaysNoDataFoundText() {
        helpers.createTestWorkoutWithDefaultValues()
        helpers.testWorkoutListRowWithDefaultValues.tap()
        helpers.workoutDetailsViewAddExerciseButton.tap()

        XCTAssertTrue(helpers.addExerciseToWorkoutViewNoDataFoundText.exists, "The user should see a message that tells them no Exercises have been created")
    }

    func test_ExerciseIsAlreadyInWorkout_ExerciseCannotBeAddedToWorkoutAgain() {
        helpers.createTestExerciseAndAddToNewWorkout()
        app.swipeUp()
        helpers.workoutDetailsViewAddExerciseButton.tap()

        XCTAssertFalse(helpers.testExerciseListRowAddExerciseToWorkoutView.isEnabled, "The Exercise's list row should be disabled because it cannot be selected again")
    }
}
