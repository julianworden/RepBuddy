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

    func test_OnInit_ValuesAreCorrect() throws {
        try dataController.generateSampleData()
        let allSampleExercises = try dataController.getAllExercises()
        exerciseForTesting = allSampleExercises.first!
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: exerciseForTesting)

        XCTAssertEqual(sut.exercise.unwrappedName, exerciseForTesting.unwrappedName, "The Exercise names should match")
        XCTAssertEqual(sut.exercise.unwrappedGoalWeightUnit, exerciseForTesting.unwrappedGoalWeightUnit, "The Exercise weight units should match")
        XCTAssertEqual(sut.exercise.goalWeight, exerciseForTesting.goalWeight, "The Exercise goal weights should match")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .dataLoading, "The default view state should be .dataLoading")
    }

    func test_OnSetupWorkoutsController_WorkoutsControllerGetsSet() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.setupWorkoutsController()

        XCTAssertNotNil(sut.workoutsController, "workoutsController shouldn't be nil")
    }

    func test_OnGetWorkoutsWhenWorkoutsExist_SetsViewState() throws {
        try dataController.generateSampleData()
        let allSampleExercises = try dataController.getAllExercises()
        exerciseForTesting = allSampleExercises.first!
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: exerciseForTesting)
        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.workouts.count, 10, "10 Workouts should be fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded, "The view state should be changed to .dataLoaded because Workouts were loaded")
    }

    func test_OnGetWorkoutsWhenNoWorkoutsExist_SetsViewState() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.viewState, .dataNotFound, "The view state should be .dataNotFound, as the example Exercise does not exist in any Workouts")
    }

    func test_OnGetRepSets_RepSetsAreFetched() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddRepSets()
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: testExercise)

        let fetchedRepSets = sut.getRepSets(in: testExercise, and: testWorkout)

        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 5, "5 RepSets should exist")
        XCTAssertEqual(fetchedRepSets.count, 5, "5 RepSets should've been fetched")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut = AllExerciseRepSetsViewModel(dataController: dataController, exercise: Exercise.example)
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }
}
