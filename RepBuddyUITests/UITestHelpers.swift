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

    // MARK: - List Elements

    var minusButtonInEditMode: XCUIElement {
        app.collectionViews.cells.otherElements.containing(.image, identifier:"remove").element
    }

    var rowDeleteButton: XCUIElement {
        app.collectionViews.buttons["Delete"]
    }

    var testExerciseListRow: XCUIElement {
        app.collectionViews.buttons["Test, Goal: 20 Pounds, Progress"]
    }

    var testWorkoutListRow: XCUIElement {
        app.collectionViews.buttons["\(Date.now.numericDateNoTime), Arms Workout"]
    }

    // MARK: - AddEditViews

    var saveExerciseButton: XCUIElement {
        app.collectionViews.buttons["Save Exercise"]
    }

    var deleteExerciseButton: XCUIElement {
        app.collectionViews.buttons["Delete Exercise"]
    }

    var saveWorkoutButton: XCUIElement {
        app.collectionViews.buttons["Save Workout"]
    }

    var deleteWorkoutButton: XCUIElement {
        app.collectionViews.buttons["Delete Workout"]
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

    // MARK: - ExerciseDetailsView

    var exerciseDetailsSetsGroupBox: XCUIElement {
        app.buttons["Sets"]
    }

    // MARK: - Methods

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

    func createTestWorkout() {
        workoutsTabButton.tap()
        navigationBarAddButton.tap()
        saveWorkoutButton.tap()
    }
}
