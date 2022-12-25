//
//  ExerciseDetailsViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/21/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class ExerciseDetailsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: ExerciseDetailsViewModel!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        sut = ExerciseDetailsViewModel(dataController: dataController, exercise: Exercise.example)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnExerciseDetailsViewModelInit_ValuesAreCorrect() {
        XCTAssertEqual(sut.exercise.unwrappedName, Exercise.example.unwrappedName, "The Exercise names should match")
        XCTAssertEqual(sut.exercise.unwrappedGoalWeightUnit, Exercise.example.unwrappedGoalWeightUnit, "The Exercise weight units should match")
        XCTAssertEqual(sut.exercise.goalWeight, Exercise.example.goalWeight, "The Exercise goal weights should match")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertFalse(sut.dismissView, "dismissView should be false by default")
        XCTAssertFalse(sut.addEditExerciseSheetIsShowing, "No sheet should be showing by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
    }

    func test_OnExerciseDetailsViewModelSetupExerciseController_ControllerIsSetUp() {
        sut.setupExerciseController()

        XCTAssertNotNil(sut.exerciseController, "The exerciseController can't be nil")
    }

    func test_ExerciseDetailsViewModelInvalidViewState_ChangesProperties() {
        sut.viewState = .dataLoaded

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_ExerciseDetailsViewModelErrorViewState_ChangesProperties() {
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_ExerciseDetailsViewModelDataDeletedViewState_AltersDismissViewProperty() {
        sut.viewState = .dataDeleted

        XCTAssertTrue(sut.dismissView, "dismissView should be true when .dataDeleted is the ViewState")
    }
}
