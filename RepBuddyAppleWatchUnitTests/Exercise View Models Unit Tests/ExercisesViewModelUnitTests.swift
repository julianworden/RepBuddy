//
//  ExercisesViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddyAppleWatch

import CoreData
import XCTest

final class ExercisesViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: ExercisesViewModel!
    var helpers: UnitTestHelpers!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        sut = ExercisesViewModel(dataController: dataController)
        helpers = UnitTestHelpers(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnInit_ValuesAreCorrect() {
        XCTAssertEqual(sut.exercises, [], "The exercises array should be initialized to [] by default")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.addEditExerciseSheetIsShowing, "No sheet should be showing by default")
        XCTAssertFalse(sut.errorAlertIsShowing, "No error alert should be showing by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "No error alert text should be shown be set by default")
    }

    func test_OnSetupExercisesController_ControllerIsSetUp() {
        sut.setupExercisesController()

        XCTAssertNotNil(sut.exercisesController, "The exerciseController should've been set up")
    }

    func test_ExercisesArray_IsSortedAlphabetically() {
        let testWorkout = helpers.createTestWorkout()
        let exerciseStartingWithA = Exercise(context: moc)
        exerciseStartingWithA.id = UUID()
        exerciseStartingWithA.name = "AAA"
        exerciseStartingWithA.goalWeight = 450
        exerciseStartingWithA.goalWeightUnit = WeightUnit.kilograms.rawValue
        let exerciseStartingWithZ = Exercise(context: moc)
        exerciseStartingWithZ.id = UUID()
        exerciseStartingWithZ.name = "ZZZ"
        exerciseStartingWithZ.goalWeight = 300
        exerciseStartingWithZ.goalWeightUnit = WeightUnit.pounds.rawValue
        testWorkout.addToExercises(exerciseStartingWithZ)
        testWorkout.addToExercises(exerciseStartingWithA)

        sut.setupExercisesController()
        sut.getExercises()

        XCTAssertEqual(sut.exercises.count, 2, "Two Exercises should belong in the Workout")
        XCTAssertEqual(sut.exercises, [exerciseStartingWithA, exerciseStartingWithZ], "The Exercise starting with A should come before the one starting with Z")
    }

    func test_OnGetExercisesWhenExercisesExist_SetsViewState() throws {
        try dataController.generateSampleData()

        sut.setupExercisesController()
        sut.getExercises()

        XCTAssertEqual(sut.exercises.count, 5, "5 Exercises should be fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded, "The view state should be changed to .dataLoaded")
    }

    func test_OnGetExercisesWhenNoExercisesExist_SetsViewState() {
        sut.setupExercisesController()
        sut.getExercises()

        XCTAssertEqual(sut.viewState, .dataNotFound, "The view state should be .dataNotFound, as no sample data was generated")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
