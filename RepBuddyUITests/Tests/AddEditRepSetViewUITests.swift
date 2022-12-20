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

    func test_OnSwipeDown_AddEditRepSetViewIsDismissed() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewAddSetToExerciseButton.tap()
        helpers.navigationBar.swipeDown()

        XCTAssertFalse(helpers.createSetNavigationTitle.exists, "WorkoutDetailsView should be visible after AddEditRepSetView is dismissed")
    }

    func test_OnCancelButtonTapped_AddEditRepSetViewIsDismissed() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewAddSetToExerciseButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertFalse(helpers.createSetNavigationTitle.exists, "WorkoutDetailsView should be visible after AddEditRepSetView is dismissed")
    }

    func test_OnWorkoutDetailsViewAddSetButtonTapped_AddEditRepSetViewNavigationTitleAndButtonAreCorrect() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewAddSetToExerciseButton.tap()

        XCTAssertTrue(helpers.createSetNavigationTitle.exists, "The navigation title should read 'Create Set'")
        XCTAssertTrue(helpers.createSetButton.exists, "A button that reads 'Create Set' should exist'")
    }

    func test_OnExerciseRepsViewPlusButtonTapped_AddEditRepSetViewNavigationTitleAndButtonAreCorrect() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.workoutDetailsViewTestExerciseButton.tap()
        helpers.navigationBarAddButton.tap()

        XCTAssertTrue(helpers.createSetNavigationTitle.exists, "The navigation title should read 'Create Set'")
        XCTAssertTrue(helpers.createSetButton.exists, "A button that reads 'Create Set' should exist'")
    }

    func test_OnEditRepSet_AddEditRepSetViewValuesAreCorrect() {
        helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
        helpers.workoutDetailsViewTestExerciseButton.tap()
        helpers.listItemForRepSetAboveTestWorkoutGoal.tap()

        let repSetCountTextFieldWithValue = app.collectionViews.textFields["12"]
        let repSetWeightTextFieldWithValue = app.collectionViews.textFields["60"]

        XCTAssertTrue(helpers.updateSetNavigationTitle.exists, "The navigation title should read 'Update Set'")
        XCTAssertTrue(helpers.updateSetButton.exists, "The button should read 'Update Set'")
        XCTAssertTrue(repSetCountTextFieldWithValue.exists, "The value for the RepSet's count should be 12")
        XCTAssertTrue(repSetWeightTextFieldWithValue.exists, "The value for the RepSet's weight should be 60")
    }
}
