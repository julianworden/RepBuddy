//
//  ExercisesViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class ExercisesViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: ExercisesViewModel!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        sut = ExercisesViewModel(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnExercisesViewModelInit_ValuesAreCorrect() {
        XCTAssertEqual(sut.exercises, [], "The exercises array should be initialized to [] by default")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.addEditExerciseSheetIsShowing, "No sheet should be showing by default")
        XCTAssertFalse(sut.errorAlertIsShowing, "No error alert should be showing by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "No error alert text should be shown be set by default")
    }

    func test_OnExercisesViewModelSetupExercisesController_ControllerIsSetUp() {
        sut.setupExercisesController()

        XCTAssertNotNil(sut.exercisesController, "The exerciseController should've been set up")
    }

    func test_OnExercisesViewModelGetExercises_SetsViewStateWhenExercisesExist() throws {
        try dataController.generateSampleData()

        sut.setupExercisesController()
        sut.getExercises()

        XCTAssertEqual(sut.exercises.count, 5, "5 Exercises should be fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded, "The view state should be changed to .dataLoaded")
    }

    func test_OnExercisesViewModelGetExercises_SetsViewStateWhenNoExercisesExist() {
        sut.setupExercisesController()
        sut.getExercises()

        XCTAssertEqual(sut.viewState, .dataNotFound, "The view state should be .dataNotFound, as no sample data was generated")
    }

    func test_OnExercisesViewModelDeleteExercise_ExerciseIsDeleted() throws {
        try dataController.generateSampleData()
        sut.setupExercisesController()
        sut.getExercises()

        sut.deleteExercise(at: IndexSet(integer: 0))

        XCTAssertEqual(sut.exercises.count, 4, "The exercises array should now have 4 Exercises")
        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 4, "4 Exercises should now exist")
    }

    func test_OnExercisesViewModelErrorViewState_ChangesProperties() {
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnExercisesViewModelInvalidViewState_ChangesProperties() {
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
