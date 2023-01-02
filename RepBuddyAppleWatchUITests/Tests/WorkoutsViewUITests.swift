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

    func test_NoWorkoutsExist_NoDataTextAndCreateWorkoutButtonExist() {
        _ = helpers.exercisesNavigationTitle.waitForExistence(timeout: 5)
        app.swipeLeft()

        XCTAssertTrue(helpers.noWorkoutsFoundText.exists, "The no data found text should appear since no Workouts exist")
        XCTAssertTrue(helpers.createWorkoutNoDataFoundButton.exists, "A 'Create Workout' buttons should be shown when no Workouts exist")
    }

    func test_WorkoutCreated_DisplaysInWorkoutsListAndCreateWorkoutToolbarButtonExists() {
        helpers.createTestWorkoutWithDefaultValues()

        XCTAssertTrue(helpers.navigationBarCreateWorkoutButton.exists, "The user should be able to tap a toolbar button to create a Workout")
        XCTAssertTrue(app.collectionViews.staticTexts[Date.now.numericDateNoTime].exists, "The Workout's date should be displayed after it's been created")
        XCTAssertTrue(app.collectionViews.staticTexts["Arms Workout"].exists, "The Workout's type should be displayed after it's been created")
        XCTAssertFalse(helpers.noWorkoutsFoundText.exists, "The user should see a Workout, not a 'no data found' message")
    }

    func test_EditedWorkout_DisplaysCorrectValuesInWorkoutsList() {
        helpers.createAndUpdateTestWorkout()
        helpers.navigationBarBackButton.tap()

        XCTAssertTrue(app.collectionViews.staticTexts[Date.now.numericDateNoTime].exists, "The Workout's date should be displayed after it's been created")
        XCTAssertTrue(app.collectionViews.staticTexts["Legs Workout"].exists, "The Workout's edited type should be displayed after it's been created")
    }

    func test_OnWorkoutDelete_WorkoutIsDeletedAndNoDataTextDisplays() {
        helpers.createTestWorkoutWithDefaultValues()
        helpers.testWorkoutListRowWithDefaultValues.tap()
        helpers.detailsViewEditButton.tap()
        helpers.deleteWorkoutButton.tap()
        _ = helpers.deleteConfirmationAlertYesButton.waitForExistence(timeout: 5)
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.noWorkoutsFoundText.waitForExistence(timeout: 5), "The no data found text should display after all Exercises are deleted")
        XCTAssertTrue(helpers.createWorkoutNoDataFoundButton.exists, "The 'Create Exercise' Button should appear when no Exercises exist")
    }
}
