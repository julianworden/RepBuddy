//
//  ExerciseRepsInWorkoutDetailsViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class ExerciseRepsInWorkoutDetailsViewUITests: XCTestCase {
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

    func test_OnAppear_ExerciseRepsInWorkoutDetailsViewDisplaysNavigationTitle() {
            helpers.createTestExerciseAndAddToNewWorkout()
            helpers.workoutDetailsViewTestExerciseButton.tap()

            XCTAssertTrue(helpers.exerciseRepsViewNavigationTitle.exists, "The navigation title should read 'Sets'")
        }

        func test_CreatedExerciseRepSet_AppearsInExerciseRepsInWorkoutDetailsViewList() {
            helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
            helpers.workoutDetailsViewTestExerciseButton.tap()

            XCTAssertTrue(helpers.listItemForRepSetAboveTestWorkoutGoal.exists, "The created RepSet should be displayed")
        }

        func test_OnUpdateRepSet_ExerciseRepsInWorkoutDetailsViewUpdates() {
            helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
            helpers.workoutDetailsViewTestExerciseButton.tap()
            helpers.listItemForRepSetAboveTestWorkoutGoal.tap()
            helpers.addEditRepSetViewRepCountTextField.tap()
            app.typeText("0")
            helpers.addEditRepSetViewRepWeightTextField.tap()
            app.typeText("0")
            helpers.updateSetButton.tap()

            XCTAssertTrue(helpers.listItemForUpdatedRepSet.exists, "The updated value of 120 reps at 600 pounds should be shown in the list")
        }

        func test_ExerciseInWorkoutHasNoRepSets_ExerciseRepsInWorkoutDetailsViewDisplaysNoDataFoundText() {
            helpers.createTestExerciseAndAddToNewWorkout()
            helpers.workoutDetailsViewTestExerciseButton.tap()

            XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNoDataText.exists, "Text should be shown to tell the user that the exercise has no sets")
        }

        func test_OnSwipeToDeleteRepSet_RepSetIsDeleted() {
            helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
            helpers.workoutDetailsViewTestExerciseButton.tap()
            helpers.listItemForRepSetAboveTestWorkoutGoal.swipeLeft()
            helpers.rowDeleteButton.tap()

            XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNoDataText.exists, "The user should see text informing them that the exercise has no RepSets")
            XCTAssertEqual(app.collectionViews.count, 0, "The list of RepSets should no longer exist after deleting all RepSets")
        }

        func test_OnDeleteRepSetWithEditButton_RepSetIsDeleted() {
            helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
            helpers.workoutDetailsViewTestExerciseButton.tap()
            helpers.navigationBarEditButton.tap()
            // Minus button that appears when the Edit button is tapped
            helpers.minusButtonInEditMode.tap()
            helpers.rowDeleteButton.tap()

            XCTAssertTrue(helpers.exerciseRepsInWorkoutDetailsViewNoDataText.exists, "The user should see text informing them that the exercise has no RepSets")
            XCTAssertFalse(helpers.navigationBarEditButton.exists, "The Edit button should not be shown after all RepSets are deleted")
            XCTAssertEqual(app.collectionViews.count, 0, "The List of RepSets should no longer appear after all RepSets are deleted")
        }

        func test_AllRepSetsDeleted_EditModeIsDisabled() {
            helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
            helpers.workoutDetailsViewTestExerciseButton.tap()
            helpers.navigationBarEditButton.tap()
            // Minus button that appears when the Edit button is tapped
            helpers.minusButtonInEditMode.tap()
            helpers.rowDeleteButton.tap()
            helpers.navigationBarAddButton.tap()
            helpers.addEditRepSetViewRepCountTextField.tap()
            app.typeText("10")
            helpers.addEditRepSetViewRepWeightTextField.tap()
            app.typeText("75")
            helpers.createSetButton.tap()

            XCTAssertTrue(helpers.navigationBarEditButton.exists, "The Edit button should exist if the list is populated")
            XCTAssertFalse(helpers.minusButtonInEditMode.exists, "Edit mode should be disabled when an exercise is added after the exercises array was emptied")
        }
}
