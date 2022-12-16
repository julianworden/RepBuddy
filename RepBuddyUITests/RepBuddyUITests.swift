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

    func test_EditedExerciseGoal_DisplaysInExercisesList() {
        helpers.navigationBarAddButton.tap()

        helpers.typeTestExerciseName()

        app.collectionViews.textFields["Weight goal"].tap()

        app.keys["delete"].tap()
        app.keys["more"].tap()
        app.keys["5"].tap()

        app.collectionViews.buttons["Kilograms"].tap()
        helpers.saveExerciseButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 25 Kilograms"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "The updated Exercise goal should update in the UI")
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

    func test_OnAppear_AddEditExerciseFormContainsFiveCells() {
        helpers.navigationBarAddButton.tap()

        // Section header counts as a cell, hence 5
        XCTAssertEqual(app.collectionViews.cells.count, 5, "There should be 4 rows in the Form")
    }

    func test_AddEditExerciseViewCancelButtonWorks() {
        helpers.navigationBarAddButton.tap()
        helpers.navigationBarCancelButton.tap()

        XCTAssertTrue(helpers.exercisesNavigationTitle.exists, "ExercisesView should be presented after pressing AddEditExerciseView's Cancel button")
    }

    func test_OnCreateExercise_NavigationTitleIsAddExercise() {
        helpers.navigationBarAddButton.tap()
        let addExerciseNavigationTitle = app.navigationBars.staticTexts["Add Exercise"]

        XCTAssertTrue(addExerciseNavigationTitle.exists, "The navigation title should be 'Add Exercise' when an Exercise is being created")
    }

    func test_OnUpdateExercise_NavigationTitleIsEditExercise() {
        helpers.createTestExercise()
        helpers.testExerciseListRow.tap()
        helpers.navigationBarEditButton.tap()

        let editExerciseNavigationTitle = app.navigationBars.staticTexts["Edit Exercise"]

        XCTAssertTrue(editExerciseNavigationTitle.exists, "The navigation title should be 'Edit Exercise' when an Exercise is being edited")
    }

    func test_OnDeleteExerciseTapped_ConfirmationAlertExists() {
        helpers.createTestExercise()
        helpers.testExerciseListRow.tap()
        helpers.navigationBarEditButton.tap()

        helpers.deleteExerciseButton.tap()

        XCTAssertTrue(helpers.deleteConfirmationAlert.exists, "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(helpers.deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(helpers.deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    func test_OnDeleteExercise_ExercisesViewIsPresented() {
        helpers.createTestExercise()
        helpers.testExerciseListRow.tap()
        helpers.navigationBarEditButton.tap()
        helpers.deleteExerciseButton.tap()
        helpers.deleteConfirmationAlertYesButton.tap()

        XCTAssertTrue(helpers.exercisesNavigationTitle.waitForExistence(timeout: 2), "ExercisesView should be presented after an Exercise is deleted")
    }

    // MARK: - AddEditWorkoutView

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

    func test_OnCreateWorkout_NavigationTitleIsAddWorkout() {
        helpers.workoutsTabButton.tap()
        helpers.navigationBarAddButton.tap()

        let addWorkoutNavigationTitle = app.navigationBars.staticTexts["Add Workout"]

        XCTAssertTrue(addWorkoutNavigationTitle.exists, "The navigation title should be 'Add Workout' when a Workout is being created")
    }

    func test_OnEditWorkout_NavigationTitleIsAddWorkout() {
        helpers.workoutsTabButton.tap()
        helpers.createTestWorkout()
        helpers.testWorkoutListRow.tap()
        helpers.navigationBarEditButton.tap()

        let editWorkoutNavigationTitle = app.navigationBars.staticTexts["Edit Workout"]

        XCTAssertTrue(editWorkoutNavigationTitle.exists, "The navigation title should be 'Edit Workout' when a Workout is being edited")
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
        helpers.testExerciseListRow.tap()

        let detailsNavigationTitle = app.navigationBars.staticTexts["Details"]
        let exerciseNameText = app.staticTexts["Test"]
        let exerciseGoalText = app.staticTexts["Goal: 20 Pounds"]
        let exerciseSetsText = app.staticTexts["0 Sets"]
        let workoutsText = app.staticTexts["0 Workouts"]

        XCTAssertTrue(detailsNavigationTitle.exists, "The navigation title should be 'Details'")
        XCTAssertTrue(exerciseNameText.exists, "The name of the Exercise should be displayed")
        XCTAssertTrue(exerciseGoalText.exists, "The Exercise's goal should be displayed as '20 Pounds'")
        XCTAssertTrue(exerciseSetsText.exists, "The Exercise should have 0 sets")
        XCTAssertTrue(workoutsText.exists, "The Exercise should have 0 workouts")
    }

    func test_OnCreateExercise_SetsGroupBoxExists() {
        helpers.createTestExercise()
        helpers.testExerciseListRow.tap()

        XCTAssertTrue(helpers.exerciseDetailsSetsGroupBox.exists, "A GroupBox containing the exercise's goal in a chart and a 'Sets' header should be displayed")
    }
}
