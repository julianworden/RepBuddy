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

    func test_OnSwipeDown_AddExerciseToWorkoutViewIsDismissed() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.workoutDetailsViewAddExerciseButton.tap()
        helpers.navigationBar.swipeDown()

        XCTAssertFalse(helpers.addExerciseToWorkoutViewNavigationTitle.exists, "The user should be able to swipe down to dismiss the view")
    }

    func test_OnCancelButtonTapped_AddExerciseToWorkoutViewIsDismissed() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.workoutDetailsViewAddExerciseButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertFalse(helpers.addExerciseToWorkoutViewNavigationTitle.exists, "The user should be able to tap Cancel to dismiss the view")
    }

    func test_OnAppear_AddExerciseToWorkoutViewNavigationTitleExists() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.workoutDetailsViewAddExerciseButton.tap()

        XCTAssertTrue(helpers.addExerciseToWorkoutViewNavigationTitle.exists, "An 'Add Exercise' navigation title should exist")
    }

    func test_NoExercisesCreated_AddExerciseToWorkoutViewDisplaysNoDataFoundText() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.workoutDetailsViewAddExerciseButton.tap()

        XCTAssertTrue(helpers.addExerciseToWorkoutViewNoDataFoundText.exists, "The user should see a message that tells them no Exercises have been created")
    }
}
