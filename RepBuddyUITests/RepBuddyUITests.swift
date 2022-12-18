//
//  LaunchAppUiTests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/15/22.
//

import XCTest

final class LaunchAppUITests: XCTestCase {
    // MARK: - Computed Properties

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

    // MARK: - Launch App

    func test_LaunchApp_ExercisesTabNavigationTitleExists() {
        XCTAssertTrue(helpers.exercisesNavigationTitle.exists)
    }

    func test_LaunchApp_TabViewExists() {
        let tabBar = app.tabBars["Tab Bar"]
        let exercisesTabButton = app.tabBars["Tab Bar"].buttons["Exercises"]
        let workoutsTabButton = app.tabBars["Tab Bar"].buttons["Workouts"]

        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(exercisesTabButton.exists)
        XCTAssertTrue(workoutsTabButton.exists)
    }

    func test_LaunchApp_TabViewHasTwoTabs() {
        let tabBar = app.tabBars["Tab Bar"]

        XCTAssertEqual(tabBar.buttons.count, 2, "There should be two tab bars in RootView's TabView")
    }

    func test_LaunchApp_ExercisesTabIsSelected() {
        let exercisesTabButton = app.tabBars["Tab Bar"].buttons["Exercises"]

        XCTAssertTrue(exercisesTabButton.isSelected)
    }

    func test_LaunchApp_PlusNavigationBarButtonExists() {
        let plusNavigationBarButton = app.navigationBars["Exercises"].buttons["Add"]

        XCTAssertTrue(plusNavigationBarButton.exists)
    }

    // MARK: - ExercisesView

    func test_NoExercisesExist_TextIsShownAndEditButtonIsHidden() {
        let noDataFoundText = app.staticTexts["You haven't created any exercises. Use the plus button to create one!"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertTrue(noDataFoundText.exists)
        XCTAssertFalse(editButton.exists)
    }

    func test_ExerciseCreated_RowAndEditButtonExist() {
        helpers.createTestExercise()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let testExerciseRowDescription = app.collectionViews.staticTexts["Goal: 20 Pounds"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertEqual(app.collectionViews.activityIndicators.count, 1, "One exercise should be shown")
        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(testExerciseRowDescription.exists, "The exercise's goal should be displayed")
        XCTAssertTrue(editButton.exists, "The EditButton should be shown")
        XCTAssertFalse(helpers.noExercisesFoundText.exists, "The user should see an Exercise, not a 'no data found' message")
    }

    func test_ExerciseCreatedWithNonDefaultValues_DisplaysCorrectValueInExercisesList() {
        helpers.navigationBarAddButton.tap()

        helpers.typeTestExerciseName()

        app.collectionViews.textFields["Weight goal"].tap()

        app.typeText("0")

        app.collectionViews.buttons["Kilograms"].tap()
        helpers.saveExerciseButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 200 Kilograms"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "'200 Kilograms' should be displayed")
    }

    func test_EditedExercise_DisplaysUpdatedValuesInExercisesList() {
        helpers.createAndUpdateTestExercise()

        helpers.exerciseDetailsViewBackButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test1"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 200 Pounds"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test1' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "The updated Exercise goal should update to '200 Pounds' in the UI")
    }

    func test_OnExerciseDelete_ExerciseIsDeletedAndNoDataTextDisplays() {
        helpers.createTestExercise()
        helpers.navigationBarEditButton.tap()
        helpers.minusButtonInEditMode.tap()
        helpers.rowDeleteButton.tap()

        XCTAssertTrue(helpers.noExercisesFoundText.exists, "The no data found text should display after all Exercises are deleted")
        XCTAssertFalse(helpers.navigationBarEditButton.exists, "The Edit button should not be shown after all Exercises are deleted")
        XCTAssertEqual(app.collectionViews.count, 0, "The ExercisesList should no longer appear after all Exercises are deleted")
    }

    func test_OnSwipeToDeleteExercise_WorkoutIsDeleted() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.swipeLeft()
        helpers.rowDeleteButton.tap()

        XCTAssertTrue(helpers.noExercisesFoundText.exists, "No Exercises should appear after swipe to delete")
        XCTAssertEqual(app.collectionViews.count, 0, "ExercisesList should no longer exist after deleting all workouts")
    }

    /// If all exercises are deleted by using the EditButton, by default editMode == .active,
    /// even when no exercises are visible. This tests that this is not happening, as
    /// editMode should equal .inactive when adding an Exercise to an empty list.
    func test_AllExercisesDeleted_EditModeIsDisabled() {
        helpers.createTestExercise()
        helpers.navigationBarEditButton.tap()
        helpers.minusButtonInEditMode.tap()
        helpers.rowDeleteButton.tap()
        helpers.createTestExercise()

        XCTAssertFalse(helpers.minusButtonInEditMode.exists, "Edit mode should be disabled when an exercise is added after the exercises array was emptied")
    }

    // MARK: - WorkoutsView

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
        helpers.workoutsTabButton.tap()
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

        XCTAssertFalse(helpers.minusButtonInEditMode.exists, "Edit mode should be disabled when an exercise is added after the exercises array was emptied")
    }

    // MARK: - AddEditExerciseView

    func test_OnSwipeDown_ExerciseDetailsViewIsDismissed() {
        helpers.navigationBarAddButton.tap()
        helpers.addExerciseNavigationTitle.swipeDown()

        XCTAssertTrue(helpers.exercisesNavigationTitle.exists, "The user should be able to swipe down to dismiss AddEditExerciseView")
    }

    func test_OnAppear_AddEditExerciseFormContainsFiveCells() {
        helpers.navigationBarAddButton.tap()

        // Section header counts as a cell, hence 5
        XCTAssertEqual(app.collectionViews.cells.count, 5, "There should be 4 rows in the Form")
    }

    func test_OnCancelButtonTap_AddEditExerciseViewIsDismissed() {
        helpers.navigationBarAddButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.exercisesNavigationTitle.exists, "ExercisesView should be presented after pressing AddEditExerciseView's Cancel button")
    }

    func test_OnCreateExercise_NavigationTitleAndSaveButtonsAreCorrect() {
        helpers.navigationBarAddButton.tap()

        XCTAssertTrue(helpers.addExerciseNavigationTitle.exists, "The navigation title should be 'Add Exercise' when an Exercise is being created")
        XCTAssertTrue(helpers.saveExerciseButton.exists, "The button should read 'Save Exercise'")
    }

    func test_OnEditExercise_NavigationTitleAndSaveButtonsAreCorrect() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.navigationBarEditButton.tap()

        XCTAssertTrue(helpers.editExerciseNavigationTitle.exists, "The navigation title should be 'Edit Exercise' when an Exercise is being edited")
        XCTAssertTrue(helpers.updateExerciseButton.exists, "The button should read 'Update Exercise'")
    }

    func test_OnDeleteExerciseTapped_ConfirmationAlertExists() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.navigationBarEditButton.tap()

        helpers.deleteExerciseButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlert.exists, "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    func test_OnDeleteExercise_ExercisesViewIsPresented() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteExerciseButton.tap()
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.exercisesNavigationTitle.waitForExistence(timeout: 2), "ExercisesView should be presented after an Exercise is deleted")
    }

    // MARK: - AddEditWorkoutView

    func test_OnSwipeDown_WorkoutDetailsViewIsDismissed() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()
        helpers.addWorkoutNavigationTitle.swipeDown()

        XCTAssertTrue(helpers.workoutsNavigationTitle.exists, "The user should be able to swipe down to dismiss AddEditWorkoutView")
    }

    func test_OnAppear_AddEditWorkoutViewContainsThreeCells() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()

        XCTAssertEqual(app.collectionViews.cells.count, 3, "AddEditWorkoutView's Form should have 3 cells")
    }

    func test_OnAppear_AddEditWorkoutFormContainsThreeCells() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()

        XCTAssertEqual(app.collectionViews.cells.count, 3, "There should be 3 rows in the Form")
    }

    func test_AddEditWorkoutViewCancelButtonWorks() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.workoutsNavigationTitle.exists, "WorkoutsView should be presented after pressing AddEditWorkoutView's Cancel button")
    }

    func test_OnCreateWorkout_NavigationTitleAndSaveButtonAreCorrect() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()

        XCTAssertTrue(helpers.addWorkoutNavigationTitle.exists, "The navigation title should be 'Add Workout' when a Workout is being created")
        XCTAssertTrue(helpers.saveWorkoutButton.exists, "The button should read 'Save Workout'")
    }

    func test_OnEditWorkout_NavigationTitleAndSaveButtonAreCorrect() {
        helpers.workoutsTabButton.tap()
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()

        XCTAssertTrue(helpers.editWorkoutNavigationTitle.exists, "The navigation title should be 'Edit Workout' when a Workout is being edited")
        XCTAssertTrue(helpers.updateWorkoutButton.exists, "The button should say 'Update Workout'")
    }

    func test_OnDeleteWorkoutTapped_ConfirmationAlertExists() {
        helpers.workoutsTabButton.tap()
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteWorkoutButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlert.exists, "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    func test_OnDeleteWorkout_WorkoutsViewIsPresented() {
        helpers.workoutsTabButton.tap()
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteWorkoutButton.tap()
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.workoutsNavigationTitle.waitForExistence(timeout: 2), "WorkoutsView should be presented after a Workout is deleted")
    }

    // MARK: - ExerciseDetailsView

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

        let exerciseDetailsViewSetChart = helpers
            .exerciseDetailsSetsGroupBox
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.exerciseSetChart)
            .firstMatch
        let setChartGoalText = exerciseDetailsViewSetChart
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.setChartGoalRuleMark)
            .firstMatch

        XCTAssertTrue(helpers.exerciseDetailsSetsGroupBox.exists, "A GroupBox labeled Sets should be displayed")
        XCTAssertTrue(exerciseDetailsViewSetChart.exists, "An ExerciseSetChart should be displayed in the Sets GroupBox")
        XCTAssertTrue(setChartGoalText.exists, "The Exercise's Goal should be displayed on the chart")
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

    // MARK: - WorkoutDetailsView

    func test_OnCreateWorkout_WorkoutDetailsHeaderDisplaysCorrectValues() {
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()

        let workoutTypeHeaderText = app.scrollViews.staticTexts["Arms Workout"]
        let workoutDate = app.scrollViews.staticTexts[Date.now.numericDateNoTime]
        let armsWorkoutImage = app.scrollViews.images["Arms"]

        XCTAssertTrue(workoutTypeHeaderText.exists, "The type of workout should be displayed")
        XCTAssertTrue(workoutDate.exists, "The date of the workout should exist")
        XCTAssertTrue(armsWorkoutImage.exists, "An image corresponding to the workout type should be displayed")
        XCTAssertTrue(helpers.navigationTitleWorkoutDetailsView.exists, "'Details' should be displayed in the navigation bar")
    }

    func test_OnEditWorkout_WorkoutDetailsHeaderDisplaysCorrectValues() {
        helpers.createAndUpdateTestWorkout()

        let legsWorkoutHeader = app.scrollViews.staticTexts["Legs Workout"]
        let legImage = app.scrollViews.images["Legs"]

        XCTAssertTrue(legsWorkoutHeader.exists, "'Legs Workout' is the updated workout type and it should be displayed")
        XCTAssertTrue(legImage.exists, "The Legs image should be displayed for the updated workout type")
    }

    // MARK: - AllExerciseRepSetsView

    func test_OnAppear_NavigationTitleExists() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBox.tap()

        let navigationTitle = app.navigationBars.staticTexts["All Sets"]

        XCTAssertTrue(navigationTitle.exists, "An 'All Sets' navigation title should be displayed")
    }

    func test_OnAddExerciseToWorkoutWithoutSet_NoSetsTextAndHeaderExist() {
        helpers.createTestExerciseAndAddToNewWorkout()
        helpers.exercisesTabButton.tap()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBox.tap()

        let noSetsFoundText = app.collectionViews.staticTexts["No sets found for this workout."]

        XCTAssertEqual(app.collectionViews.cells.count, 2, "There should be 2 cells displayed (including section header text)")
        XCTAssertTrue(helpers.allExerciseRepSetsViewWorkoutHeader.exists, "The workout title should be shown as a section header")
        XCTAssertTrue(noSetsFoundText.exists, "A cell stating that no sets were found for the workout should appear")
    }

    func test_OnAddExerciseToWorkoutWithSet_SetAndHeaderExistInList() {
        helpers.createTestExerciseAndAddRepSetAboveExerciseGoal()
        helpers.exercisesTabButton.tap()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBox.tap()

        let rowText = app.collectionViews.staticTexts["12 reps at 60 pounds"]

        XCTAssertTrue(rowText.exists, "The Exercise's set should be displayed")
        XCTAssertTrue(helpers.allExerciseRepSetsViewWorkoutHeader.exists, "The Exercise's set Workout should be shown as the section header")
    }

    func test_OnCreateExercise_AllExerciseRepSetsViewDisplaysNoDataFoundText() {
        helpers.createTestExercise()
        helpers.testExerciseListRowExercisesView.tap()
        helpers.exerciseDetailsSetsGroupBox.tap()

        XCTAssertTrue(helpers.noWorkoutsFoundForExerciseText.exists, "The Exercise should have no workouts and the no data found text should be displayed")
    }
}
