//
//  UITestHelpers.swift
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

    var navigationBarCancelButton: XCUIElement {
        app.navigationBars.buttons["Cancel"]
    }

    var navigationBarDoneButton: XCUIElement {
        app.navigationBars.buttons["Done"]
    }

    var navigationBarBackButton: XCUIElement {
        app.navigationBars.buttons["BackButton"]
    }

    var navigationBarCreateExerciseButton: XCUIElement {
        app.navigationBars.buttons["Create Exercise"]
    }

    var navigationBarCreateWorkoutButton: XCUIElement {
        app.navigationBars.buttons["Create Workout"]
    }

    // MARK: - ExercisesView

    var exercisesNavigationTitle: XCUIElement {
        app.navigationBars["Exercises"]
    }

    var testExerciseWithDefaultValuesListRowExercisesView: XCUIElement {
        app.collectionViews.buttons["Test, Goal: 60 Pounds"]
    }

    var testExerciseWithNonDefaultValuesListRowExercisesView: XCUIElement {
        app.collectionViews.buttons["Test, Goal: 60 Kilograms"]
    }

    var createExerciseNoDataFoundButton: XCUIElement {
        app.buttons["Create Exercise"]
    }

    // MARK: - WorkoutsView

    var workoutsNavigationTitle: XCUIElement {
        app.navigationBars["Workouts"]
    }

    var createWorkoutNoDataFoundButton: XCUIElement {
        app.buttons["Create Workout"]
    }

    /// WorkoutsView list row for test Workout created with createTestWorkoutWithDefaultValues()
    var testWorkoutListRowWithDefaultValues: XCUIElement {
        app.collectionViews.buttons["\(Date.now.numericDateNoTime), Arms Workout"]
    }

    /// WorkoutsView list row for test Workout created with createTestWorkoutWithoutDefaultValues()
    var testWorkoutListRowWithNonDefaultValues: XCUIElement {
        app.collectionViews.buttons["\(Date.now.numericDateNoTime), Legs Workout"]
    }

    // MARK: - No Data Found Text

    var noExercisesFoundText: XCUIElement {
        app.staticTexts["You haven't created any exercises."]
    }

    var noWorkoutsFoundText: XCUIElement {
        app.staticTexts["You haven't created any workouts."]
    }

    var allExerciseRepSetsViewNoDataFoundText: XCUIElement {
        app.staticTexts[NoDataFoundConstants.noWorkoutsFoundForExercise]
    }

    var exerciseRepsInWorkoutDetailsViewNoDataText: XCUIElement {
        app.staticTexts["You haven't created any sets."]
    }

    var addExerciseToWorkoutViewNoDataFoundText: XCUIElement {
        app.staticTexts[NoDataFoundConstants.addExerciseToWorkoutViewEmptyExercisesList]
    }

    var workoutDetailsViewNoExercisesAddedNoDataFoundText: XCUIElement {
        app.staticTexts["No exercises selected."]
    }

    // MARK: - AddEditExerciseView

    var addEditExerciseNameTextField: XCUIElement {
        app.collectionViews.textFields[AccessibilityIdentifiers.addEditExerciseNameTextField]
    }

    var addEditExerciseWeightGoalTextField: XCUIElement {
        app.collectionViews.textFields[AccessibilityIdentifiers.addEditExerciseViewGoalTextField]
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

    var addEditExercisePoundsButton: XCUIElement {
        app.collectionViews.switches["Pounds"]
    }

    var addEditExerciseKilogramsButton: XCUIElement {
        app.collectionViews.switches["Kilograms"]
    }

    // MARK: - AddEditWorkoutView

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

    var addEditRepSetViewCreateSetButton: XCUIElement {
        app.collectionViews.buttons["Create Set"]
    }

    var updateSetButton: XCUIElement {
        app.collectionViews.buttons["Update Set"]
    }

    var deleteSetButton: XCUIElement {
        app.collectionViews.buttons["Delete Set"]
    }

    // MARK: - ExerciseInWorkoutDetailsView

    var exerciseInWorkoutDetailsViewCreateSetButton: XCUIElement {
        app.scrollViews.buttons["Create Set"]
    }

    var exerciseInWorkoutDetailsViewDeleteExerciseButton: XCUIElement {
        app.scrollViews.buttons["Delete Exercise"]
    }

    var exerciseInWorkoutDetailsViewChartButton: XCUIElement {
        app.scrollViews.buttons["Forward"]
    }

    // MARK: - Alerts

    var deleteConfirmationAlertTitle: XCUIElement {
        app.staticTexts["Are You Sure?"]
    }

    var deleteExerciseConfirmationAlertMessage: XCUIElement {
        app.staticTexts[AlertConstants.deleteExerciseMessage]
    }

    var deleteWorkoutConfirmationAlertMessage: XCUIElement {
        app.staticTexts[AlertConstants.deleteWorkoutMessage]
    }

    var deleteRepSetConfirmationAlertMessage: XCUIElement {
        app.staticTexts[AlertConstants.deleteRepSetMessage]
    }

    var deleteExerciseFromWorkoutConfirmationMessage: XCUIElement {
        app.staticTexts[AlertConstants.deleteExerciseInWorkoutMessage]
    }

    var deleteConfirmationAlertCancelButton: XCUIElement {
        app.buttons["Cancel"]
    }

    var deleteConfirmationAlertYesButton: XCUIElement {
        app.buttons["Yes"]
    }

    // MARK: - DetailViews

    var detailsNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Details"]
    }

    var detailsViewEditButton: XCUIElement {
        app.scrollViews.buttons["Compose"]
    }

    // MARK: - ExerciseDetailsView

    var exerciseDetailsViewChartButton: XCUIElement {
        app.scrollViews.buttons["Forward"]
    }

    // MARK: - WorkoutDetailsView

    var workoutDetailsViewTestExerciseWithDefaultValuesListRow: XCUIElement {
        app.scrollViews.buttons["Test"]
    }

    var workoutDetailsViewAddExerciseButton: XCUIElement {
        app.scrollViews.buttons["Add Exercise"]
    }

    var workoutDetailsViewHeaderTextForWorkoutWithDefaultValues: XCUIElement {
        app.scrollViews.staticTexts["Arms Workout on \(Date.now.numericDateNoTime)"]
    }

    var workoutDetailsViewExercisesSectionHeader: XCUIElement {
        app.scrollViews.staticTexts["Exercises"]
    }

    // MARK: - AddExerciseToWorkoutView

    var testExerciseListRowAddExerciseToWorkoutView: XCUIElement {
        app.collectionViews.buttons["Test"]
    }

    // MARK: - ExerciseRepsInWorkoutDetailsView

    var exerciseRepsInWorkoutDetailsViewNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Sets"]
    }

    var exerciseRepsInWorkoutDetailsViewNoDataFoundCreateSetButton: XCUIElement {
        app.buttons["Create Set"]
    }

    var exerciseRepsInWorkoutDetailsViewTestRepSetListRow: XCUIElement {
        app.collectionViews.buttons["10 reps at 60 pounds"]
    }

    // MARK: - AllExerciseRepSetsView

    var allExerciseRepSetsViewNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["All Sets"]
    }

    var allExerciseRepSetsViewWorkoutHeader: XCUIElement {
        app.collectionViews.staticTexts[Date.now.numericDateNoTime]
    }

    var allExerciseRepSetsViewTestRepSetRow: XCUIElement {
        app.collectionViews.staticTexts["10 reps at 60 pounds"]
    }

    // MARK: - Charts

    var exerciseDetailsSetChart: XCUIElement {
        exerciseDetailsViewChartButton
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.exerciseSetChart)
            .firstMatch
    }

    var exerciseDetailsSetChartRuleMark: XCUIElement {
        exerciseDetailsSetChart
            .children(matching: .other)
            .element(matching: .other, identifier: AccessibilityIdentifiers.setChartGoalRuleMark)
            .firstMatch
    }

    // MARK: - Methods

    func createTestExerciseWithDefaultValues() {
        _ = createExerciseNoDataFoundButton.waitForExistence(timeout: 5)
        createExerciseNoDataFoundButton.tap()
        typeTestExerciseName()
        app.swipeUp()
        saveExerciseButton.tap()
    }

    func createTestExerciseWithNonDefaultValues() {
        _ = createExerciseNoDataFoundButton.waitForExistence(timeout: 5)
        createExerciseNoDataFoundButton.tap()
        typeTestExerciseName()
        app.swipeUp()
        addEditExerciseKilogramsButton.tap()
        saveExerciseButton.tap()
    }

    /// Changes the test Exercise's name to Test1 and goal to 200
    func createAndUpdateTestExercise() {
        createTestExerciseWithDefaultValues()
        testExerciseWithDefaultValuesListRowExercisesView.tap()
        detailsViewEditButton.tap()
        addEditExerciseNameTextField.tap()
        app.typeText("1")
        navigationBarDoneButton.tap()
        app.swipeUp()
        addEditExerciseKilogramsButton.tap()
        updateExerciseButton.tap()
    }

    func typeTestExerciseName() {
        _ = addEditExerciseNameTextField.waitForExistence(timeout: 5)
        addEditExerciseNameTextField.tap()
        app.typeText("Test")
        navigationBarDoneButton.tap()
    }

    func navigateToWorkoutsTab() {
        _ = exercisesNavigationTitle.waitForExistence(timeout: 5)
        app.swipeLeft()
    }

    func createTestWorkoutWithDefaultValues() {
        navigateToWorkoutsTab()
        _ = createWorkoutNoDataFoundButton.waitForExistence(timeout: 5)
        createWorkoutNoDataFoundButton.tap()
        saveWorkoutButton.tap()
    }

    func createTestWorkoutWithNonDefaultValues() {
        navigateToWorkoutsTab()
        createWorkoutNoDataFoundButton.tap()
        addEditWorkoutTypePicker.tap()
        app.switches["Legs"].tap()
        saveWorkoutButton.tap()
    }

    /// Changes the test Workout's type from the default Arms to Legs
    func createAndUpdateTestWorkout() {
        createTestWorkoutWithDefaultValues()
        testWorkoutListRowWithDefaultValues.tap()
        detailsViewEditButton.tap()
        addEditWorkoutTypePicker.tap()
        app.switches["Legs"].tap()
        updateWorkoutButton.tap()
    }

    /// Creates a new Exercise, creates a new Workout, then adds the new Exercise
    /// to the new Workout.
    func createTestExerciseAndAddToNewWorkout() {
        createTestExerciseWithDefaultValues()
        createTestWorkoutWithDefaultValues()
        testWorkoutListRowWithDefaultValues.tap()
        workoutDetailsViewAddExerciseButton.tap()
        testExerciseListRowAddExerciseToWorkoutView.tap()
    }

    func createTestExerciseAndAddRepSet() {
        createTestExerciseAndAddToNewWorkout()
        workoutDetailsViewTestExerciseWithDefaultValuesListRow.tap()
        exerciseInWorkoutDetailsViewCreateSetButton.tap()
        app.swipeUp()
        addEditRepSetViewCreateSetButton.tap()
    }
}
