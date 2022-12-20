//
//  AllExerciseRepSetsViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class AllExerciseRepSetsViewUITests: XCTestCase {
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

    func test_OnAppear_NavigationTitleExists() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBoxButton.tap()

        let navigationTitle = app.navigationBars.staticTexts["All Sets"]

        XCTAssertTrue(navigationTitle.exists, "An 'All Sets' navigation title should be displayed")
    }

    func test_OnAddExerciseToWorkoutWithoutSet_NoSetsTextAndHeaderExist() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.exercisesTabButton.tap()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBoxButton.tap()

        let noSetsFoundText = app.collectionViews.staticTexts["No sets found for this workout."]

        XCTAssertEqual(app.collectionViews.cells.count, 2, "There should be 2 cells displayed (including section header text)")
        XCTAssertTrue(helpers.allExerciseRepSetsViewWorkoutHeader.exists, "The workout title should be shown as a section header")
        XCTAssertTrue(noSetsFoundText.exists, "A cell stating that no sets were found for the workout should appear")
    }

    func test_OnAddExerciseToWorkoutWithSet_SetAndHeaderExistInList() {
        helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
        helpers.exercisesTabButton.tap()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBoxButton.tap()

        let rowText = app.collectionViews.staticTexts["12 reps at 60 pounds"]

        XCTAssertTrue(rowText.exists, "The Exercise's set should be displayed")
        XCTAssertTrue(helpers.allExerciseRepSetsViewWorkoutHeader.exists, "The Exercise's set Workout should be shown as the section header")
    }

    func test_OnCreateExercise_AllExerciseRepSetsViewDisplaysNoDataFoundText() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBoxButton.tap()

        XCTAssertTrue(helpers.allExerciseRepSetsViewNoDataFoundText.exists, "The Exercise should have no workouts and the no data found text should be displayed")
    }
}
