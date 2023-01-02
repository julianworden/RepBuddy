//
//  WorkoutDetailsExerciseSetChartViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/24/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class WorkoutDetailsExerciseSetChartViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: WorkoutDetailsExerciseSetChartViewModel!
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

    func test_OnInit_ValuesAreCorrect() {
        sut = WorkoutDetailsExerciseSetChartViewModel(dataController: dataController, exercise: Exercise.example, workout: Workout.example)

        XCTAssertEqual(sut.workout.unwrappedType, Workout.example.unwrappedType, "The Workout names should match")
        XCTAssertEqual(sut.workout.unwrappedDate.numericDateNoTime, Workout.example.unwrappedDate.numericDateNoTime, "The Workout dates should match")
        XCTAssertEqual(sut.exercise.unwrappedName, Exercise.example.unwrappedName, "The Exercise names should match")
        XCTAssertEqual(sut.exercise.unwrappedGoalWeightUnit, Exercise.example.unwrappedGoalWeightUnit, "The Exercise goal weight units should match")
        XCTAssertEqual(sut.exercise.goalWeight, Exercise.example.goalWeight, "The Exercise goal weights should match")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
    }

    func test_OnSetupExerciseController_ControllerIsSetUp() {
        sut = WorkoutDetailsExerciseSetChartViewModel(dataController: dataController, exercise: Exercise.example, workout: Workout.example)

        sut.setupExerciseController()

        XCTAssertNotNil(sut.exerciseController, "The exerciseController can't be nil")
    }

    func test_OnFetchRepSets_RepSetsAreFetched() {
        let (testExerciseWithNewRepSets, testWorkoutWithNewRepSets) = helpers.createTestExerciseAndAddRepSets()
        sut = WorkoutDetailsExerciseSetChartViewModel(
            dataController: dataController,
            exercise: testExerciseWithNewRepSets,
            workout: testWorkoutWithNewRepSets
        )

        let fetchedRepSets = sut.fetchRepSets(in: testExerciseWithNewRepSets, and: testWorkoutWithNewRepSets)

        XCTAssertEqual(fetchedRepSets.count, 5, "5 RepSets should've been fetched")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut = WorkoutDetailsExerciseSetChartViewModel(dataController: dataController, exercise: Exercise.example, workout: Workout.example)

        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut = WorkoutDetailsExerciseSetChartViewModel(dataController: dataController, exercise: Exercise.example, workout: Workout.example)

        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
