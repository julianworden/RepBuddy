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

    var navigationBarAddButton: XCUIElement {
        app.navigationBars.buttons["Add"]
    }

    var navigationBarEditButton: XCUIElement {
        app.navigationBars.buttons["Edit"]
    }

    var navigationBarCancelButton: XCUIElement {
        app.navigationBars.buttons["Cancel"]
    }

    var exercisesNavigationTitle: XCUIElement {
        app.navigationBars["Exercises"]
    }

    var workoutsNavigationTitle: XCUIElement {
        app.navigationBars["Workouts"]
    }

    var noExercisesFoundText: XCUIElement {
        app.staticTexts["You haven't created any exercises. Use the plus button to create one!"]
    }

    var noWorkoutsFoundText: XCUIElement {
        app.staticTexts["You haven't created any workouts. Use the plus button to create one!"]
    }

    var saveExerciseButton: XCUIElement {
        app.collectionViews.buttons["Save Exercise"]
    }

    var minusButtonInEditMode: XCUIElement {
        app.collectionViews.cells.otherElements.containing(.image, identifier:"remove").element
    }

    var rowDeleteButton: XCUIElement {
        app.collectionViews.buttons["Delete"]
    }

    var saveWorkoutButton: XCUIElement {
        app.collectionViews.buttons["Save Workout"]
    }

    var workoutsTabButton: XCUIElement {
        app.tabBars["Tab Bar"].buttons["Workouts"]
    }

    var testExerciseListRow: XCUIElement {
        app.collectionViews.buttons["Test, Goal: 20 Pounds, Progress"]
    }

    var testWorkoutListRow: XCUIElement {
        app.collectionViews.buttons["\(Date.now.numericDateNoTime), Arms Workout"]
    }

    var deleteExerciseButton: XCUIElement {
        app.collectionViews.buttons["Delete Exercise"]
    }

    var deleteWorkoutButton: XCUIElement {
        app.collectionViews.buttons["Delete Workout"]
    }

    var deleteConfirmationAlert: XCUIElement {
        app.alerts["Are You Sure?"]
    }

    var deleteConfirmationAlertCancelButton: XCUIElement {
        app.alerts.buttons["Cancel"]
    }

    var deleteConfirmationAlertYesButton: XCUIElement {
        app.alerts.buttons["Yes"]
    }

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }

    override func tearDownWithError() throws {

    }

    // MARK: - Launch App

    func test_LaunchApp_ExercisesTabNavigationTitleExists() {
        XCTAssertTrue(exercisesNavigationTitle.exists)
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

    func createTestExercise() {
        navigationBarAddButton.tap()
        typeTestExerciseName()
        saveExerciseButton.tap()
    }

    func typeTestExerciseName() {
        app.collectionViews.textFields["Name (required)"].tap()

        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
    }

    func test_NoExercisesExist_TextIsShownAndEditButtonIsHidden() {
        let noDataFoundText = app.staticTexts["You haven't created any exercises. Use the plus button to create one!"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertTrue(noDataFoundText.exists)
        XCTAssertFalse(editButton.exists)
    }

    func test_ExerciseCreated_RowAndEditButtonExist() {
        createTestExercise()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let testExerciseRowDescription = app.collectionViews.staticTexts["Goal: 20 Pounds"]
        let editButton = app.navigationBars["Exercises"].buttons["Edit"]

        XCTAssertEqual(app.collectionViews.activityIndicators.count, 1, "One exercise should be shown")
        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(testExerciseRowDescription.exists, "The exercise's goal should be displayed")
        XCTAssertTrue(editButton.exists, "The EditButton should be shown")
        XCTAssertFalse(noExercisesFoundText.exists, "The user should see an Exercise, not a 'no data found' message")
    }

    func test_EditedExerciseGoal_DisplaysInExercisesList() {
        navigationBarAddButton.tap()

        typeTestExerciseName()

        app.collectionViews.textFields["Weight goal"].tap()

        app.keys["delete"].tap()
        app.keys["more"].tap()
        app.keys["5"].tap()

        app.collectionViews.buttons["Kilograms"].tap()
        saveExerciseButton.tap()

        let testExerciseRowName = app.collectionViews.staticTexts["Test"]
        let editedExerciseRowDescription = app.collectionViews.staticTexts["Goal: 25 Kilograms"]

        XCTAssertTrue(testExerciseRowName.exists, "An exercise named 'Test' should be displayed")
        XCTAssertTrue(editedExerciseRowDescription.exists, "The updated Exercise goal should update in the UI")
    }

    func test_OnExerciseDelete_ExerciseIsDeletedAndNoDataTextDisplays() {
        createTestExercise()
        navigationBarEditButton.tap()
        minusButtonInEditMode.tap()
        rowDeleteButton.tap()

        XCTAssertTrue(noExercisesFoundText.exists, "The no data found text should display after all Exercises are deleted")
        XCTAssertFalse(navigationBarEditButton.exists, "The Edit button should not be shown after all Exercises are deleted")
        XCTAssertEqual(app.collectionViews.count, 0, "The ExercisesList should no longer appear after all Exercises are deleted")
    }

    /// If all exercises are deleted by using the EditButton, by default editMode == .active,
    /// even when no exercises are visible. This tests that this is not happening, as
    /// editMode should equal .inactive when adding an Exercise to an empty list.
    func test_AllExercisesDeleted_EditModeIsDisabled() {
        createTestExercise()
        navigationBarEditButton.tap()
        minusButtonInEditMode.tap()
        rowDeleteButton.tap()
        createTestExercise()

        XCTAssertFalse(minusButtonInEditMode.exists, "Edit mode should be disabled when an exercise is added after the exercises array was emptied")
    }

    // MARK: - WorkoutsView

    func test_WorkoutsTabSelected_WorkoutsNavigationTitleExists() {
        workoutsTabButton.tap()
        XCTAssertTrue(workoutsNavigationTitle.exists, "'Workouts' should be displayed in the navigation bar")
    }

    func test_NoWorkoutsExist_NoDataTextExistsAndEditButtonIsHidden() {
        workoutsTabButton.tap()

        XCTAssertTrue(noWorkoutsFoundText.exists)
        XCTAssertFalse(navigationBarEditButton.exists)
    }

    func test_WorkoutCreated_WorkoutRowAndEditButtonExist() {
        workoutsTabButton.tap()
        createTestWorkout()

        XCTAssertEqual(app.collectionViews.buttons.count, 1, "There should be one row displayed after a Workout is created")
        XCTAssertTrue(app.collectionViews.staticTexts[Date.now.numericDateNoTime].exists, "The Workout's date should be displayed after it's been created")
        XCTAssertTrue(app.collectionViews.staticTexts["Arms Workout"].exists, "The Workout's type should be displayed after it's been created")
        XCTAssertTrue(navigationBarEditButton.exists, "The Edit button should be shown after a Workout is created")
        XCTAssertFalse(noWorkoutsFoundText.exists, "The user should see a Workout, not a 'no data found' message")
    }

    func test_EditedWorkoutType_DisplaysInWorkoutsList() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()
        app.collectionViews.staticTexts["Arms"].tap()
        app.collectionViews.buttons["Legs"].tap()
        saveWorkoutButton.tap()

        XCTAssertTrue(app.collectionViews.staticTexts[Date.now.numericDateNoTime].exists, "The Workout's date should be displayed after it's been created")
        XCTAssertTrue(app.collectionViews.staticTexts["Legs Workout"].exists, "The Workout's edited type should be displayed after it's been created")
    }

    func test_OnWorkoutDelete_WorkoutIsDeletedAndNoDataTextDisplays() {
        workoutsTabButton.tap()
        createTestWorkout()
        navigationBarEditButton.tap()
        // Minus button that appears when the Edit button is tapped
        minusButtonInEditMode.tap()
        rowDeleteButton.tap()

        XCTAssertTrue(noWorkoutsFoundText.exists, "The no data found text should display after all Workouts are deleted")
        XCTAssertFalse(navigationBarEditButton.exists, "The Edit button should not be shown after all Workouts are deleted")
        XCTAssertEqual(app.collectionViews.count, 0, "The WorkoutsList should no longer appear after all Workouts are deleted")
    }

    func test_AllWorkoutsDeleted_EditModeIsDisabled() {
        workoutsTabButton.tap()
        createTestWorkout()
        navigationBarEditButton.tap()
        minusButtonInEditMode.tap()
        rowDeleteButton.tap()
        createTestWorkout()

        XCTAssertFalse(minusButtonInEditMode.exists, "Edit mode should be disabled when an exercise is added after the exercises array was emptied")
    }

    // MARK: - AddEditExerciseView

    func test_OnAppear_AddEditExerciseFormContainsFiveCells() {
        navigationBarAddButton.tap()

        // Section header counts as a cell, hence 5
        XCTAssertEqual(app.collectionViews.cells.count, 5, "There should be 4 rows in the Form")
    }

    func test_AddEditExerciseViewCancelButtonWorks() {
        navigationBarAddButton.tap()
        navigationBarCancelButton.tap()

        XCTAssertTrue(exercisesNavigationTitle.exists, "ExercisesView should be presented after pressing AddEditExerciseView's Cancel button")
    }

    func test_OnCreateExercise_NavigationTitleIsAddExercise() {
        navigationBarAddButton.tap()
        let addExerciseNavigationTitle = app.navigationBars.staticTexts["Add Exercise"]

        XCTAssertTrue(addExerciseNavigationTitle.exists, "The navigation title should be 'Add Exercise' when an Exercise is being created")
    }

    func test_OnUpdateExercise_NavigationTitleIsEditExercise() {
        createTestExercise()
        testExerciseListRow.tap()
        navigationBarEditButton.tap()

        let editExerciseNavigationTitle = app.navigationBars.staticTexts["Edit Exercise"]

        XCTAssertTrue(editExerciseNavigationTitle.exists, "The navigation title should be 'Edit Exercise' when an Exercise is being edited")
    }

    func test_OnDeleteExercise_ConfirmationAlertExists() {
        createTestExercise()
        testExerciseListRow.tap()
        navigationBarEditButton.tap()

        deleteExerciseButton.tap()

        XCTAssertTrue(deleteConfirmationAlert.exists, "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }

    // MARK: - AddEditWorkoutView

    func createTestWorkout() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()
        saveWorkoutButton.tap()
    }

    func test_OnAppear_AddEditWorkoutFormContainsThreeCells() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()

        XCTAssertEqual(app.collectionViews.cells.count, 3, "There should be 3 rows in the Form")
    }

    func test_AddEditWorkoutViewCancelButtonWorks() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()
        navigationBarCancelButton.tap()

        XCTAssertTrue(workoutsNavigationTitle.exists, "WorkoutsView should be presented after pressing AddEditWorkoutView's Cancel button")
    }

    func test_OnCreateWorkout_NavigationTitleIsAddWorkout() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()

        let addWorkoutNavigationTitle = app.navigationBars.staticTexts["Add Workout"]

        XCTAssertTrue(addWorkoutNavigationTitle.exists, "The navigation title should be 'Add Workout' when a Workout is being created")
    }

    func test_OnEditWorkout_NavigationTitleIsAddWorkout() {
        workoutsTabButton.tap()
        createTestWorkout()
        testWorkoutListRow.tap()
        navigationBarEditButton.tap()

        let editWorkoutNavigationTitle = app.navigationBars.staticTexts["Edit Workout"]

        XCTAssertTrue(editWorkoutNavigationTitle.exists, "The navigation title should be 'Edit Workout' when a Workout is being edited")
    }

    func test_OnDeleteWorkout_ConfirmationAlertExists() {
        workoutsTabButton.tap()
        createTestWorkout()
        testWorkoutListRow.tap()
        navigationBarEditButton.tap()
        deleteWorkoutButton.tap()

        XCTAssertTrue(deleteConfirmationAlert.exists, "A confirmation alert should be shown before an Exercise is deleted")
        XCTAssertTrue(deleteConfirmationAlertCancelButton.exists, "The confirmation alert should have a Cancel button")
        XCTAssertTrue(deleteConfirmationAlertYesButton.exists, "The confirmation alert should have a Yes button")
    }
}
