//
//  AllExerciseRepSetsViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/21/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class AllExerciseRepSetsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: AllExerciseRepSetsViewModel!
    var exerciseForTesting: Exercise!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnInit_AllExerciseRepSetsViewModelValuesAreCorrect() throws {
        try dataController.generateSampleData()
        let allSampleExercises = try dataController.getAllExercises()
        exerciseForTesting = allSampleExercises.first!
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: exerciseForTesting)

        XCTAssertEqual(sut.exercise.unwrappedName, exerciseForTesting.unwrappedName, "The Exercise names should match")
        XCTAssertEqual(sut.exercise.unwrappedGoalWeightUnit, exerciseForTesting.unwrappedGoalWeightUnit, "The Exercise weight units should match")
        XCTAssertEqual(sut.exercise.goalWeight, exerciseForTesting.goalWeight, "The Exercise goal weights should match")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertEqual(sut.errorAlertText, "", "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .dataLoading, "The default view state should be .dataLoading")
    }

    func test_GetWorkouts_SetsAllExerciseRepSetsViewModelViewStateWhenWorkoutsExist() throws {
        try dataController.generateSampleData()
        let allSampleExercises = try dataController.getAllExercises()
        exerciseForTesting = allSampleExercises.first!
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: exerciseForTesting)
        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.workouts.count, 10, "10 Workouts should be fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded, "The view state should be changed to .dataLoaded because Workouts were loaded")
    }

    func test_GetWorkouts_SetsAllExerciseRepSetsViewModelViewStateWhenNoWorkoutsExist() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.viewState, .dataNotFound, "The view state should be .dataNotFound, as the example Exercise does not exist in any Workouts")
    }

    func test_AllExerciseRepSetsViewModelInvalidViewState_ChangesProperties() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_AllExerciseRepSetsViewModelErrorViewState_ChangesProperties() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_AllExerciseRepSetsViewModel_WorkoutsControllerGetsSet() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.setupWorkoutsController()

        XCTAssertNotNil(sut.workoutsController, "workoutsController shouldn't be nil")
    }
}
