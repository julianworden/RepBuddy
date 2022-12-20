//
//  WorkoutsViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class WorkoutsViewUITests: XCTestCase {
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

    func test_WorkoutsTabSelected_WorkoutsNavigationTitleExists() {
        helpers.workoutsTabButton.tap()
        XCTAssertTrue(helpers.workoutsNavigationTitle.exists, "'Workouts' should be displayed in the navigation bar")
    }

    func test_NoWorkoutsExist_NoDataTextExistsAndEditButtonIsHidden() {
        helpers.workoutsTabButton.tap()

        XCTAssertTrue(helpers.noWorkoutsFoundText.exists)
        XCTAssertFalse(helpers.navigationBarEditButton.exists)
    }

    func test_WorkoutCreated_WorkoutRowAndEditButtonExist() {
        helpers.workoutsTabButton.tap()
        helpers.createTestWorkout()

        XCTAssertEqual(app.collectionViews.buttons.count, 1, "There should be one row displayed after a Workout is created")
        XCTAssertTrue(app.collectionViews.staticTexts[Date.now.numericDateNoTime].exists, "The Workout's date should be displayed after it's been created")
        XCTAssertTrue(app.collectionViews.staticTexts["Arms Workout"].exists, "The Workout's type should be displayed after it's been created")
        XCTAssertTrue(helpers.navigationBarEditButton.exists, "The Edit button should be shown after a Workout is created")
        XCTAssertFalse(helpers.noWorkoutsFoundText.exists, "The user should see a Workout, not a 'no data found' message")
    }

    func test_EditedWorkoutType_DisplaysInWorkoutsList() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()
        app.collectionViews.staticTexts["Arms"].tap()
        app.collectionViews.buttons["Legs"].tap()
        helpers.saveWorkoutButton.tap()

        XCTAssertTrue(app.collectionViews.staticTexts[Date.now.numericDateNoTime].exists, "The Workout's date should be displayed after it's been created")
        XCTAssertTrue(app.collectionViews.staticTexts["Legs Workout"].exists, "The Workout's edited type should be displayed after it's been created")
    }

    func test_OnWorkoutDelete_WorkoutIsDeletedAndNoDataTextDisplays() {
        helpers.createTestWorkout()
        helpers.navigationBarEditButton.tap()
        // Minus button that appears when the Edit button is tapped
        helpers.minusButtonInEditMode.tap()
        helpers.rowDeleteButton.tap()

        XCTAssertTrue(helpers.noWorkoutsFoundText.exists, "The no data found text should display after all Workouts are deleted")
        XCTAssertFalse(helpers.navigationBarEditButton.exists, "The Edit button should not be shown after all Workouts are deleted")
        XCTAssertEqual(app.collectionViews.count, 0, "The WorkoutsList should no longer appear after all Workouts are deleted")
    }

    func test_OnSwipeToDeleteWorkout_WorkoutIsDeleted() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.swipeLeft()
        helpers.rowDeleteButton.tap()

        XCTAssertTrue(helpers.noWorkoutsFoundText.exists, "No workouts should appear after swipe to delete")
        XCTAssertEqual(app.collectionViews.count, 0, "WorkoutsList should no longer exist after deleting all workouts")
    }

    func test_AllWorkoutsDeleted_EditModeIsDisabled() {
        helpers.workoutsTabButton.tap()
        helpers.createTestWorkout()
        helpers.navigationBarEditButton.tap()
        helpers.minusButtonInEditMode.tap()
        helpers.rowDeleteButton.tap()
        helpers.createTestWorkout()

        XCTAssertTrue(helpers.navigationBarEditButton.exists, "The Edit button should exist if the list is populated")
        XCTAssertFalse(helpers.minusButtonInEditMode.exists, "Edit mode should be disabled when an exercise is added after the exercises array was emptied")
    }
}
