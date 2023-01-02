//
//  AddEditRepSetViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/29/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class AddEditRepSetViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: AddEditRepSetViewModel!
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

    func test_OnInitWithRepSetToEdit_ValuesAreCorrect() {
        let testExercise = helpers.createTestExercise()
        let testWorkout = helpers.createTestWorkout()
        let repSetToEdit = helpers.createTestRepSet(with: testExercise, and: testWorkout)
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise, repSetToEdit: repSetToEdit)

        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertEqual(sut.exercise, testExercise, "The two Exercise objects should be equal")
        XCTAssertEqual(sut.workout, testWorkout, "The two Workout objects should be equal")
        XCTAssertNotNil(sut.repSetToEdit, "The repSetToEdit was passed in")
        XCTAssertEqual(sut.repSetToEdit, repSetToEdit, "The repSetToEdit was not passed in properly")
        XCTAssertEqual(String(sut.repSetToEdit!.reps), sut.repSetCount, "The repSetToEdit's reps count should've been updated")
        XCTAssertEqual(String(sut.repSetToEdit!.weight), sut.repSetWeight, "The repSetToEdit's weight should've been updated")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
        XCTAssertFalse(sut.dismissView, "The view shouldn't dismiss itself by default")
        XCTAssertFalse(sut.deleteRepSetAlertIsShowing, "The delete confirmation alert shouldn't be showing")
    }

    func test_OnInitWithNoRepSetToEdit_ValuesAreCorrect() {
        sut = AddEditRepSetViewModel(dataController: dataController, workout: Workout.example, exercise: Exercise.example)

        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
        XCTAssertFalse(sut.dismissView, "The view shouldn't dismiss itself by default")
        XCTAssertTrue(sut.repSetCount.isEmpty, "There should be no default repSetCount")
        XCTAssertTrue(sut.repSetWeight.isEmpty, "There should be no default repSetWeight")
        XCTAssertFalse(sut.deleteRepSetAlertIsShowing, "The delete confirmation alert shouldn't be showing")
    }

    func test_OnInitWithRepSetToEdit_ComputedPropertiesAreCorrect() {
        let testExercise = helpers.createTestExercise()
        let testWorkout = helpers.createTestWorkout()
        let repSetToEdit = helpers.createTestRepSet(with: testExercise, and: testWorkout)
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise, repSetToEdit: repSetToEdit)

        XCTAssertEqual(sut.navigationBarTitleText, "Update Set", "The navigation title should be 'Create Set'")
        XCTAssertEqual(sut.saveButtonText, "Update Set", "The save button should be 'Create Set'")
    }

    func test_OnInitWithNoRepSetToEdit_ComputedPropertiesAreCorrect() {
        let testWorkout = helpers.createTestWorkout()
        let testExercise = helpers.createTestExercise()
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise)

        XCTAssertEqual(sut.navigationBarTitleText, "Create Set", "The navigation title should be 'Create Set'")
        XCTAssertEqual(sut.saveButtonText, "Create Set", "The save button should be 'Create Set'")
    }

    func test_RepSetCreationDate_ValueIsCorrect() {
        let testWorkout = helpers.createTestWorkout()
        let testExercise = helpers.createTestExercise()
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise)

        XCTAssertNotNil(sut.repSetCreationDate, "repSetCreationDate should have a value")
        XCTAssertEqual(
            Calendar.current.dateComponents(
                [.year, .month, .day],
                from: testWorkout.unwrappedDate),
            Calendar.current.dateComponents(
                [.year, .month, .day],
                from: sut.repSetCreationDate!),
            "The values should match"
        )
        XCTAssertEqual(
            Calendar.current.dateComponents(
                [.hour, .minute, .second],
                from: Date.now
            ),
            Calendar.current.dateComponents(
                [.hour, .minute, .second],
                from: sut.repSetCreationDate!
            ),
            "The values should match"
        )
    }

    func test_OnConfirmButtonTappedWithNoRepSetCount_FormIsIncomplete() {
        sut = AddEditRepSetViewModel(dataController: dataController, workout: Workout.example, exercise: Exercise.example)
        sut.repSetWeight = "50"

        XCTAssertFalse(sut.formIsCompleted, "The form isn't complete")
    }

    func test_OnConfirmButtonTappedWithNoRepSetWeight_FormIsIncomplete() {
        sut = AddEditRepSetViewModel(dataController: dataController, workout: Workout.example, exercise: Exercise.example)
        sut.repSetCount = "9"

        XCTAssertFalse(sut.formIsCompleted, "The form isn't complete")
    }

    func test_OnConfirmButtonTappedWithWeightAndRepCountValues_FormIsComplete() {
        let testWorkout = helpers.createTestWorkout()
        let testExercise = helpers.createTestExercise()
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise)
        sut.repSetCount = "12"
        sut.repSetWeight = "99"

        XCTAssertTrue(sut.formIsCompleted, "The form is complete")
    }

    func test_OnConfirmButtonTappedWithNoRepSetToEdit_RepSetIsCreated() {
        let testWorkout = helpers.createTestWorkout()
        let testExercise = helpers.createTestExercise()
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise)
        sut.repSetCount = "12"
        sut.repSetWeight = "99"

        sut.confirmButtonTapped()

        XCTAssertTrue(sut.formIsCompleted, "The form is complete")
        XCTAssertTrue(sut.dismissView, "The view should be dismissed when a RepSet is created or updated")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 1, "One RepSet should've been created")
    }

    func test_OnConfirmButtonTappedWithRepSetToEdit_RepSetIsUpdated() throws {
        let testWorkout = helpers.createTestWorkout()
        let testExercise = helpers.createTestExercise()
        let repSetToEdit = helpers.createTestRepSet(with: testExercise, and: testWorkout)
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise, repSetToEdit: repSetToEdit)

        sut.repSetWeight = "500"
        sut.repSetCount = "60"
        sut.confirmButtonTapped()
        let updatedRepSets = try dataController.getRepSets(in: testExercise, and: testWorkout)
        guard let updatedRepSet = updatedRepSets.first else {
            XCTFail("The updated RepSet should've been fetched")
            return
        }

        XCTAssertNotNil(sut.repSetToEdit, "repSetToEdit should have a value")
        XCTAssertTrue(sut.dismissView, "The view should be dismissed when a RepSet is created or updated")
        XCTAssertEqual(updatedRepSet.reps, 60, "The new rep count should be 60")
        XCTAssertEqual(updatedRepSet.weight, 500, "The new weight should be 500")
    }

    func test_OnConfirmButtonTappedWithIncompleteForm_ViewStateIsCorrect() {
        sut = AddEditRepSetViewModel(dataController: dataController, workout: Workout.example, exercise: Exercise.example)

        sut.confirmButtonTapped()

        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert is showing because the form is incomplete")
        XCTAssertEqual(sut.errorAlertText, FormValidationError.emptyFields.localizedDescription)
    }

    func test_OnDeleteRepSet_RepSetIsDeleted() {
        let testWorkout = helpers.createTestWorkout()
        let testExercise = helpers.createTestExercise()
        let repSetToEdit = helpers.createTestRepSet(with: testExercise, and: testWorkout)
        sut = AddEditRepSetViewModel(dataController: dataController, workout: testWorkout, exercise: testExercise, repSetToEdit: repSetToEdit)

        sut.deleteRepSet()

        XCTAssertNotNil(sut.repSetToEdit, "repSetToEdit should have a value")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 0, "No RepSets should exist")
        XCTAssertTrue(sut.dismissView, "The view should be dismissed when a RepSet is deleted")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut = AddEditRepSetViewModel(dataController: dataController, workout: Workout.example, exercise: Exercise.example)
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut = AddEditRepSetViewModel(dataController: dataController, workout: Workout.example, exercise: Exercise.example)
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }
}
