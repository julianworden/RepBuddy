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

    func test_OnAppearWithNoRepSets_ViewAppearsCorrectly() {
        helpers.createTestExerciseWithDefaultValues()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.exerciseDetailsViewChartButton.tap()

        XCTAssertTrue(helpers.allExerciseRepSetsViewNavigationTitle.exists, "An 'All Sets' navigation title should be displayed")
        XCTAssertTrue(helpers.allExerciseRepSetsViewNoDataFoundText.exists, "A message should be shown to the user telling them that they don't have any RepSets for the Exercise")
    }

    func test_OnAddExerciseToWorkoutWithoutSet_NoSetsTextAndHeaderExist() {
        helpers.createTestExerciseAndAddToNewWorkout()
        app.swipeRight()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.exerciseDetailsViewChartButton.tap()

        let noSetsFoundText = app.collectionViews.staticTexts["No sets found for this workout."]

        XCTAssertTrue(helpers.allExerciseRepSetsViewWorkoutHeader.exists, "The workout title should be shown as a section header")
        XCTAssertTrue(noSetsFoundText.exists, "A cell stating that no sets were found for the workout should appear")
    }

    func test_OnAddExerciseToWorkoutWithSet_SetAndHeaderExistInList() {
        helpers.createTestExerciseAndAddRepSet()
        app.swipeRight()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.exerciseDetailsViewChartButton.tap()

        XCTAssertTrue(helpers.allExerciseRepSetsViewTestRepSetRow.exists, "The Exercise's set should be displayed")
        XCTAssertTrue(helpers.allExerciseRepSetsViewWorkoutHeader.exists, "The Exercise's set Workout should be shown as the section header")
    }

    func test_OnCreateExercise_AllExerciseRepSetsViewDisplaysNoDataFoundText() {
        helpers.createTestExerciseWithDefaultValues()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()
        helpers.exerciseDetailsViewChartButton.tap()

        XCTAssertTrue(helpers.allExerciseRepSetsViewNoDataFoundText.exists, "The Exercise should have no workouts and RepSets and the no data found text should be displayed")
    }
}
