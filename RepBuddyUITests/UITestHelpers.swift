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

    var noWorkoutsFoundForExerciseText: XCUIElement {
        app.staticTexts[NoDataFoundConstants.noWorkoutsFoundForExercise]
    }

    // MARK: - List Elements

    var minusButtonInEditMode: XCUIElement {
        app.collectionViews.cells.otherElements.containing(.image, identifier:"remove").element
    }

    var rowDeleteButton: XCUIElement {
        app.collectionViews.buttons["Delete"]
    }

    var testExerciseListRowExercisesView: XCUIElement {
        app.collectionViews.buttons["Test, Goal: 20 Pounds, Progress"]
    }

    var testExerciseListRowAddExerciseToWorkoutView: XCUIElement {
        app.collectionViews.buttons["Test"]
    }

    var testWorkoutListRow: XCUIElement {
        app.collectionViews.buttons["\(Date.now.numericDateNoTime), Arms Workout"]
    }

    // MARK: - AddEditViews

    var addExerciseNavigationTitle: XCUIElement {
        app.navigationBars.staticTexts["Add Exercise"]
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

    var exerciseDetailsSetsGroupBox: XCUIElement {
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

    var navigationTitleWorkoutDetailsView: XCUIElement {
        app.navigationBars.staticTexts["Details"]
    }

    // MARK: - AddEditRepSetView

    var createSetButton: XCUIElement {
        app.collectionViews.buttons["Create Set"]
    }

    // MARK: - AllExerciseRepSetsView

    var allExerciseRepSetsViewWorkoutHeader: XCUIElement {
        app.collectionViews.staticTexts["WORKOUT ON \(Date.now.numericDateNoTime)"]
    }

    // MARK: - Methods

    func createTestExercise() {
        navigationBarAddButton.tap()
        typeTestExerciseName()
        saveExerciseButton.tap()
    }

    func createAndUpdateTestExercise() {
        createTestExercise()

        testExerciseListRowExercisesView.tap()
        navigationBarEditButton.tap()

        app.collectionViews.textFields["Name (required)"].tap()
        app.typeText("1")

        app.collectionViews.textFields["Weight goal"].tap()
        app.typeText("0")

        updateExerciseButton.tap()
    }

    func typeTestExerciseName() {
        app.collectionViews.textFields["Name (required)"].tap()
        app.typeText("Test")
    }

    func createTestWorkout() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()
        saveWorkoutButton.tap()
    }

    func createAndUpdateTestWorkout() {
        createTestWorkout()
        testWorkoutListRow.tap()
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
        createTestWorkout()
        testWorkoutListRow.tap()
        addExerciseToWorkoutButton.tap()
        testExerciseListRowAddExerciseToWorkoutView.tap()
    }

    func createTestExerciseAndAddRepSetAboveExerciseGoal() {
        createTestExerciseAndAddToNewWorkout()

        app
            .scrollViews
            .buttons["Test"]
            .children(matching: .button)
            .element(matching: .button, identifier: "Add Set")
            .firstMatch
            .tap()

        app.collectionViews.textFields["Rep count"].tap()
        app.typeText("12")

        app.collectionViews.textFields["Weight"].tap()
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

        app.collectionViews.textFields["Rep count"].tap()
        app.typeText("12")

        app.collectionViews.textFields["Weight"].tap()
        app.typeText("15")

        createSetButton.tap()
    }
}
