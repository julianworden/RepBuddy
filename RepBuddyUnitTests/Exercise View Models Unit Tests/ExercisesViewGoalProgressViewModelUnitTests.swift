//
//  ExercisesViewGoalProgressViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class ExercisesViewGoalProgressViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: ExercisesViewGoalProgressViewModel!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        sut = ExercisesViewGoalProgressViewModel(dataController: dataController, exercise: Exercise.example)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnExercisesViewGoalProgressViewModelInit_ValuesAreCorrect() {
        XCTAssertEqual(sut.exercise.unwrappedName, Exercise.example.unwrappedName, "The Exercise names should match")
        XCTAssertEqual(sut.exercise.unwrappedGoalWeightUnit, Exercise.example.unwrappedGoalWeightUnit, "The Exercise weight units should match")
        XCTAssertEqual(sut.exercise.goalWeight, Exercise.example.goalWeight, "The Exercise goal weights should match")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
    }

    func test_OnExercisesViewGoalProgressViewModelSetupExerciseController_ExerciseControllerIsNotNil() {
        sut.setupExerciseController()

        XCTAssertNotNil(sut.exerciseController, "The exerciseController property cannot be nil")
    }

    func test_ExercisesViewGoalProgressViewModelErrorViewState_ChangesProperties() {
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_ExercisesViewGoalProgressViewModelInvalidViewState_ChangesProperties() {
        sut.viewState = .dataLoaded

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
