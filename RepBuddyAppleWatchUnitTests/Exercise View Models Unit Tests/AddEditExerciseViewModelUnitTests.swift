//
//  AddEditExerciseViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/21/22.
//

@testable import RepBuddyAppleWatch

import CoreData
import XCTest

final class AddEditExerciseViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: AddEditExerciseViewModel!
    var helpers: UnitTestHelpers!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        helpers = UnitTestHelpers(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnInitWithNoExerciseToEdit_DefaultValuesAreCorrect() {
        sut = AddEditExerciseViewModel(dataController: dataController)

        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertEqual("", sut.errorAlertText, "There should be no error alert text by default")
        XCTAssertFalse(sut.deleteExerciseAlertIsShowing, "No delete confirmation error alert should be shown by default")
        XCTAssertFalse(sut.dismissView, "dismissView should be false by default")
        XCTAssertFalse(sut.errorAlertIsShowing, "No error alert should be showing by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
        XCTAssertEqual(sut.exerciseWeightGoalUnit, .pounds, "The default weight goal unit should be pounds")
        XCTAssertEqual(sut.exerciseWeightGoal, 60, "The default weight goal should be 60")
        XCTAssertTrue(sut.exerciseName.isEmpty, "There should be no name entered by default")
        XCTAssertNil(sut.exerciseToEdit, "The default value of exerciseToEdit is nil")
    }

    func test_OnInitWithExerciseToEdit_DefaultValuesAreCorrect() {
        let testExercise = helpers.createTestExercise()
        sut = AddEditExerciseViewModel(dataController: dataController, exerciseToEdit: testExercise)

        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertNotNil(sut.exerciseToEdit, "exerciseToEdit shouldn't be nil")
        XCTAssertEqual(sut.exerciseToEdit, testExercise, "The exerciseToEdit wasn't passed in properly")
        XCTAssertEqual(sut.exerciseName, testExercise.name, "The exercise name value should be updated with the exerciseToEdit's name")
        XCTAssertEqual(sut.exerciseWeightGoal, Int(testExercise.goalWeight), "The exercise name value should be updated with the exerciseToEdit's name")
        XCTAssertEqual(sut.exerciseWeightGoalUnit.rawValue, testExercise.unwrappedGoalWeightUnit, "The exercise name value should be updated with the exerciseToEdit's name")
        XCTAssertEqual("", sut.errorAlertText, "There should be no error alert text by default")
        XCTAssertFalse(sut.deleteExerciseAlertIsShowing, "No delete confirmation error alert should be shown by default")
        XCTAssertFalse(sut.dismissView, "dismissView should be false by default")
        XCTAssertFalse(sut.errorAlertIsShowing, "No error alert should be showing by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
    }

    func test_OnInitWithExerciseToEdit_ComputedPropertiesAreCorrect() {
        sut = AddEditExerciseViewModel(dataController: dataController, exerciseToEdit: Exercise.example)

        XCTAssertEqual(sut.saveButtonText, "Update Exercise", "The save button should say 'Update Exercise'")
    }

    func test_OnInitWithNoExerciseToEdit_ComputedPropertiesAreCorrect() {
        sut = AddEditExerciseViewModel(dataController: dataController)

        XCTAssertEqual(sut.saveButtonText, "Save Exercise", "The save button should say 'Save Exercise'")
    }

    func test_OnInitWithNoExerciseToEdit_SavesNewExercise() throws {
        sut = AddEditExerciseViewModel(dataController: dataController)
        sut.exerciseName = "Test Exercise"
        sut.exerciseWeightGoal = 100
        sut.exerciseWeightGoalUnit = .kilograms

        sut.saveButtonTapped()

        XCTAssertNotNil(try dataController.getExercise(with: "Test Exercise"), "The Test Exercise should've been saved")
        XCTAssertTrue(sut.dismissView, "dismissView should be true after an Exercise is saved")
    }

    func test_OnUpdateExercise_UpdatesNewExercise() throws {
        let newExercise = dataController.createExercise(
            name: "Test Exercise",
            goalWeight: 100,
            goalWeightUnit: WeightUnit.kilograms
        )
        sut = AddEditExerciseViewModel(dataController: dataController, exerciseToEdit: newExercise)
        sut.exerciseName = "Updated Exercise"

        sut.saveButtonTapped()

        XCTAssertNotNil(try dataController.getExercise(with: "Updated Exercise"), "The title of the Exercise should've been updated")
        XCTAssertNil(try dataController.getExercise(with: "Test Exercise"), "The old Exercise should no longer exist")
        XCTAssertTrue(sut.dismissView, "dismissView should be true after an Exercise is updated")
    }

    func test_OnDeleteExercise_DeletesExercise() throws {
        let createdExercise = dataController.createExercise(
            name: "Test Exercise",
            goalWeight: 100,
            goalWeightUnit: WeightUnit.kilograms
        )
        sut = AddEditExerciseViewModel(dataController: dataController, exerciseToEdit: createdExercise)

        sut.deleteExercise()

        XCTAssertNil(try dataController.getExercise(with: "Test Exercise"), "The exercise should've been deleted")
        XCTAssertTrue(sut.dismissView, "dismissView should be true after an Exercise is deleted")
    }

    func test_OnInitWithEmptyNameProperty_FormIsIncomplete() {
        sut = AddEditExerciseViewModel(dataController: dataController)

        XCTAssertFalse(sut.formIsCompleted, "The form should be incomplete if there is no name entered")
    }

    func test_OnNameTextFieldFilled_FormIsComplete() {
        sut = AddEditExerciseViewModel(dataController: dataController)
        sut.exerciseName = "Bicep Curls"

        XCTAssertTrue(sut.formIsCompleted, "The form should be complete if a name was entered")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut = AddEditExerciseViewModel(dataController: dataController)
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut = AddEditExerciseViewModel(dataController: dataController)
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }
}
