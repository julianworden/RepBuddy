//
//  ExerciseDetailsViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class ExerciseDetailsViewUITests: XCTestCase {
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

    func test_OnCreateExercise_DetailsViewHeaderDisplaysCorrectValues() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()

        let detailsNavigationTitle = app.navigationBars.staticTexts["Details"]
        let exerciseNameText = app.scrollViews.staticTexts["Test"]

        // Attempted to also test for images in Label views, but Label views are recognized
        // as static text only and it doesn't appear that it's possible to reference their images
        let exerciseGoalText = app.scrollViews.staticTexts["Goal: 20 Pounds"]
        let exerciseSetsText = app.scrollViews.staticTexts["0 Sets"]
        let workoutsText = app.scrollViews.staticTexts["0 Workouts"]

        XCTAssertTrue(detailsNavigationTitle.exists, "The navigation title should be 'Details'")
        XCTAssertTrue(exerciseNameText.exists, "The name of the Exercise should be displayed")
        XCTAssertTrue(exerciseGoalText.exists, "The Exercise's goal should be displayed as '20 Pounds'")
        XCTAssertTrue(exerciseSetsText.exists, "The Exercise should have 0 sets")
        XCTAssertTrue(workoutsText.exists, "The Exercise should have 0 workouts")
    }

    func test_OnCreateExercise_SetsGroupBoxExists() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()

        XCTAssertTrue(helpers.exerciseDetailsSetsGroupBoxButton.exists, "A GroupBox labeled Sets should be displayed")
        XCTAssertTrue(helpers.exerciseDetailsSetChart.exists, "An ExerciseSetChart should be displayed in the Sets GroupBox")
        XCTAssertTrue(helpers.exerciseDetailsSetChartGoalText.exists, "The Exercise's Goal should be displayed on the chart")
    }

    func test_OnCreateExercise_YourProgressGroupBoxDoesNotExist() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()

        XCTAssertFalse(helpers.exerciseYourProgressGroupBox.exists, "The 'Your Progress' GroupBox shouldn't be displayed until an exercise has sets")
    }

    func test_OnEditExercise_ExerciseDetailsHeaderUpdates() {
        helpers.createAndUpdateTestExercise()

        let updatedNameText = app.scrollViews.staticTexts["Test1"]
        let updatedGoalText = app.scrollViews.staticTexts["Goal: 200 Pounds"]

        XCTAssertTrue(updatedNameText.exists, "The Exercise's updated name should be displayed in the header")
        XCTAssertTrue(updatedGoalText.exists, "The Exercise's updated goal should be displayed in the header")
    }

    func test_OnAddExerciseToWorkout_ExerciseDetailsHeaderUpdates() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.exercisesTabButton.tap()
        helpers.testExerciseListRowExercisesView.tap()

        let updatedWorkoutsText = app.scrollViews.staticTexts["1 Workout"]

        XCTAssertTrue(updatedWorkoutsText.exists, "The ExerciseDetailsViewHeader should say '1 Workout'")
    }

    func test_OnAddRepSetAboveGoalToExercise_ExerciseDetailsViewUpdates() {
        helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
        helpers.exercisesTabButton.tap()
        helpers.testExerciseListRowExercisesView.tap()

        let updatedSetNumberDescription = app.scrollViews.staticTexts["1 Set"]
        let yourProgressGroupBoxText = helpers
            .exerciseYourProgressGroupBox
            .children(matching: .staticText)
            .element(matching: .staticText, identifier: "Your Progress")
            .firstMatch
        let yourProgressProgressView = helpers
            .exerciseYourProgressGroupBox
            .children(matching: .progressIndicator)
            .element(matching: .progressIndicator, identifier: AccessibilityIdentifiers.exerciseDetailsAchievedGoalProgressView)
            .firstMatch

        XCTAssertTrue(updatedSetNumberDescription.exists, "The ExerciseDetailsViewHeader should include 1 set")
        XCTAssertTrue(helpers.exerciseYourProgressGroupBox.exists, "The Your Progress GroupBox should appear after a set is created")
        XCTAssertTrue(yourProgressGroupBoxText.exists, "The Your Progress GroupBox text should appear")
        XCTAssertTrue(yourProgressProgressView.exists, "A ProgressView depicting the user's progress should appear")
    }

    func test_OnAddRepSetBelowGoalToExercise_ExerciseDetailsViewUpdates() {
        helpers.createTestExerciseAndAddRepSetBelowExerciseGoal()
        helpers.exercisesTabButton.tap()
        helpers.testExerciseListRowExercisesView.tap()

        let updatedSetNumberDescription = app.scrollViews.staticTexts["1 Set"]
        let yourProgressGroupBoxText = helpers
            .exerciseYourProgressGroupBox
            .children(matching: .staticText)
            .element(matching: .staticText, identifier: "Your Progress")
            .firstMatch
        let yourProgressProgressView = helpers
            .exerciseYourProgressGroupBox
            .children(matching: .progressIndicator)
            .element(matching: .progressIndicator, identifier: AccessibilityIdentifiers.exerciseDetailsBelowGoalProgressView)
            .firstMatch

        XCTAssertTrue(updatedSetNumberDescription.exists, "The ExerciseDetailsViewHeader should include 1 set")
        XCTAssertTrue(helpers.exerciseYourProgressGroupBox.exists, "The Your Progress GroupBox should appear after a set is created")
        XCTAssertTrue(yourProgressGroupBoxText.exists, "The Your Progress GroupBox text should appear")
        XCTAssertTrue(yourProgressProgressView.exists, "A ProgressView depicting the user's progress should appear")
    }
}
