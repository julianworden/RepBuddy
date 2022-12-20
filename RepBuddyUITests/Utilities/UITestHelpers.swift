//
//  XCUIElementReferences.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/16/22.
//

import Foundation
import XCTest

struct UITestHelpers {
    let app: XCUIApplication

    // MARK: - Navigation Bar Elements

    var navigationBar: XCUIElement {
        app.navigationBars.firstMatch
    }

    var navigationBarAddButton: XCUIElement {
        app.navigationBars.buttons["Add"]
    }

    var navigationBarEditButton: XCUIElement {
        app.navigationBars.buttons["Edit"]
    }

    var navigationBarCancelButton: XCUIElement {
        app.navigationBars.buttons["Cancel"]
    }

    // MARK: - ExercisesView

    var exercisesNavigationTitle: XCUIElement {
        app.navigationBars["Exercises"]
    }

    var testExerciseListRowExercisesView: XCUIElement {
        app.collectionViews.buttons["Test, Goal: 20 Pounds, Progress"]
    }

    // MARK: - WorkoutsView

    var workoutsNavigationTitle: XCUIElement {
        app.navigationBars["Workouts"]
    }

    /// WorkoutsView list row for test Workout created with createTestWorkoutWithDefaultValues()
    var testWorkoutListRowWithDefaultValues: XCUIElement {
        app.collectionViews.buttons["\(Date.now.numericDateNoTime), Arms Workout"]
    }

    /// WorkoutsView list row for test Workout created with createTestWorkoutWithoutDefaultValues()
    var testWorkoutListRowWithoutDefaultValues: XCUIElement {
        app.collectionViews.buttons["\(Date.now.numericDateNoTime), Legs Workout"]
    }

    // MARK: - Root TabView

    var exercisesTabButton: XCUIElement {
        app.tabBars["Tab Bar"].buttons["Exercises"]
    }

    var workoutsTabButton: XCUIElement {
        app.tabBars["Tab Bar"].buttons["Workouts"]
    }

    // MARK: - No Data Found Text

    var noExercisesFoundText: XCUIElement {
        app.staticTexts["You haven't created any exercises. Use the plus button to create one!"]
    }

    var noWorkoutsFoundText: XCUIElement {
        app.staticTexts["You haven't created any workouts. Use the plus button to create one!"]
    }

    var allExerciseRepSetsViewNoDataFoundText: XCUIElement {
        app.staticTexts[NoDataFoundConstants.noWorkoutsFoundForExercise]
    }

    var exerciseRepsInWorkoutDetailsViewNoDataText: XCUIElement {
        app.staticTexts["You haven't added any sets to this exercise. Use the plus button to add one!"]
    }

    var addExerciseToWorkoutViewNoDataFoundText: XCUIElement {
        app.staticTexts[NoDataFoundConstants.addExerciseToWorkoutViewEmptyExercisesList]
    }

    // MARK: - List Elements

    var minusButtonInEditMode: XCUIElement {
        app.collectionViews.cells.otherElements.containing(.image, identifier:"remove").element
    }

    var rowDeleteButton: XCUIElement {
        app.collectionViews.buttons["Delete"]
    }

    // MARK: - AddEditExerciseView

    var addEditExerciseNameTextField: XCUIElement {
        app.collectionViews.textFields["Name (required)"]
    }

    var addEditExerciseWeightGoalTextField: XCUIElement {
        app.collectionViews.textFields["Name (required)"]
    }

    var editExerciseNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Edit Exercise"]
    }

    var saveExerciseButton: XCUIElement {
        app.collectionViews.buttons["Save Exercise"]
    }

    var updateExerciseButton: XCUIElement {
        app.collectionViews.buttons["Update Exercise"]
    }

    var deleteExerciseButton: XCUIElement {
        app.collectionViews.buttons["Delete Exercise"]
    }

    // MARK: - AddEditWorkoutView

    var addWorkoutNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Add Workout"]
    }

    var editWorkoutNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Edit Workout"]
    }

    var saveWorkoutButton: XCUIElement {
        app.collectionViews.buttons["Save Workout"]
    }

    var updateWorkoutButton: XCUIElement {
        app.collectionViews.buttons["Update Workout"]
    }

    var deleteWorkoutButton: XCUIElement {
        app.collectionViews.buttons["Delete Workout"]
    }

    var addEditWorkoutTypePicker: XCUIElement {
        app.collectionViews.buttons[AccessibilityIdentifiers.addEditWorkoutTypePicker]
    }

    // MARK: - AddEditRepSetView

    var createSetNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Create Set"]
    }

    var updateSetNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Update Set"]
    }

    var createSetButton: XCUIElement {
        app.collectionViews.buttons["Create Set"]
    }

    var updateSetButton: XCUIElement {
        app.collectionViews.buttons["Update Set"]
    }

    // MARK: - Alerts

    var deleteConfirmationAlert: XCUIElement {
        app.alerts["Are You Sure?"]
    }

    var deleteConfirmationAlertCancelButton: XCUIElement {
        app.alerts.buttons["Cancel"]
    }

    var deleteConfirmationAlertYesButton: XCUIElement {
        app.alerts.buttons["Yes"]
    }

    // MARK: - DetailViews

    var detailsNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Details"]
    }

    var exerciseDetailsSetsGroupBoxButton: XCUIElement {
        app.scrollViews.buttons["Sets"]
    }

    var exerciseYourProgressGroupBox: XCUIElement {
        app.scrollViews.otherElements[AccessibilityIdentifiers.exerciseDetailsYourProgressGroupBox]
    }

    var exerciseDetailsViewBackButton: XCUIElement {
        app.navigationBars.buttons["Exercises"]
    }

    var addExerciseToWorkoutButton: XCUIElement {
        app.buttons["Add Exercise"]
    }

    var workoutDetailsViewNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Details"]
    }

    var workoutDetailsViewTestExerciseButton: XCUIElement {
        app.scrollViews.buttons["Test"]
    }

    var workoutDetailsViewAddSetToExerciseButton: XCUIElement {
        workoutDetailsViewTestExerciseButton
            .children(matching: .button)
            .element(matching: .button, identifier: "Add Set")
            .firstMatch
    }

    var workoutDetailsViewDeleteTestExerciseButton: XCUIElement {
        workoutDetailsViewTestExerciseButton
            .children(matching: .button)
            .element(matching: .button, identifier: "Trash")
    }

    var workoutDetailsViewAddExerciseButton: XCUIElement {
        app.scrollViews.buttons["Add"]
    }

    // MARK: - AddExerciseToWorkoutView

    var addExerciseToWorkoutViewNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Add Exercise"]
    }

    var testExerciseListRowAddExerciseToWorkoutView: XCUIElement {
        app.collectionViews.buttons["Test"]
    }

    // MARK: - AddEditRepSetView

    var addEditRepSetViewRepCountTextField: XCUIElement {
        app.collectionViews.textFields["Rep count"]
    }

    var addEditRepSetViewRepWeightTextField: XCUIElement {
        app.collectionViews.textFields["Weight"]
    }

    // MARK: - ExerciseRepsInWorkoutDetailsView

    var exerciseRepsViewNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Sets"]
    }

    /// The label for this value is predicated on the values set in createTestExerciseAndAddRepSetAboveExerciseGoal()
    var listItemForRepSetAboveTestWorkoutGoal: XCUIElement {
        app.collectionViews.buttons["12 reps at 60 pounds"]
    }

    var listItemForUpdatedRepSet: XCUIElement {
        app.collectionViews.buttons["120 reps at 600 pounds"]
    }

    // MARK: - AllExerciseRepSetsView

    var allExerciseRepSetsViewWorkoutHeader: XCUIElement {
        app.collectionViews.staticTexts["WORKOUT ON \(Date.now.numericDateNoTime)"]
    }

    // MARK: - Charts

    var exerciseDetailsSetChart: XCUIElement {
        exerciseDetailsSetsGroupBoxButton
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.exerciseSetChart)
            .firstMatch
    }

    var exerciseDetailsSetChartGoalText: XCUIElement {
        exerciseDetailsSetChart
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.setChartGoalRuleMark)
            .firstMatch
    }

    var workoutDetailsExerciseSetChart: XCUIElement {
        workoutDetailsViewTestExerciseButton
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.exerciseSetChart)
            .firstMatch
    }

    var workoutDetailsExerciseSetChartGoalText: XCUIElement {
        workoutDetailsExerciseSetChart
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.setChartGoalRuleMark)
            .firstMatch
    }

    // MARK: - Methods

    func createTestExercise() {
        navigationBarAddButton.tap()
        typeTestExerciseName()
        saveExerciseButton.tap()
    }

    /// Changes the test Exercise's name to Test1 and goal to 200
    func createAndUpdateTestExercise() {
        createTestExercise()

        testExerciseListRowExercisesView.tap()
        navigationBarEditButton.tap()

        addEditExerciseNameTextField.tap()
        app.typeText("1")

        addEditExerciseWeightGoalTextField.tap()
        app.typeText("0")

        updateExerciseButton.tap()
    }

    func typeTestExerciseName() {
        addEditExerciseNameTextField.tap()
        app.typeText("Test")
    }

    func createTestWorkoutWithDefaultValues() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()
        saveWorkoutButton.tap()
    }

    func createTestWorkoutWithoutDefaultValues() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()
        addEditWorkoutTypePicker.tap()
        app.buttons["Legs"].tap()
        saveWorkoutButton.tap()
    }

    /// Changes the test Workout's type from the default Arms to Legs
    func createAndUpdateTestWorkout() {
        createTestWorkoutWithDefaultValues()
        testWorkoutListRowWithDefaultValues.tap()
        navigationBarEditButton.tap()
        addEditWorkoutTypePicker.tap()
        app.buttons["Legs"].tap()
        updateWorkoutButton.tap()
    }

    /// Creates a new Exercise, creates a new Workout, then adds the new Exercise
    /// to the new Workout.
    func createTestExerciseAndAddToNewWorkout() {
        createTestExercise()
        workoutsTabButton.tap()
        createTestWorkoutWithDefaultValues()
        testWorkoutListRowWithDefaultValues.tap()
        addExerciseToWorkoutButton.tap()
        testExerciseListRowAddExerciseToWorkoutView.tap()
    }

    func createTestExerciseAndAddRepSetAboveExerciseGoal() {
        createTestExerciseAndAddToNewWorkout()
        workoutDetailsViewAddSetToExerciseButton.tap()

        addEditRepSetViewRepCountTextField.tap()
        app.typeText("12")

        addEditRepSetViewRepWeightTextField.tap()
        app.typeText("60")

        createSetButton.tap()
    }

    func createTestExerciseAndAddRepSetBelowExerciseGoal() {
        createTestExerciseAndAddToNewWorkout()

        app
            .scrollViews
            .buttons["Test"]
            .children(matching: .button)
            .element(matching: .button, identifier: "Add Set")
            .firstMatch
            .tap()

        addEditRepSetViewRepCountTextField.tap()
        app.typeText("12")

        addEditRepSetViewRepWeightTextField.tap()
        app.typeText("15")

        createSetButton.tap()
    }
}
