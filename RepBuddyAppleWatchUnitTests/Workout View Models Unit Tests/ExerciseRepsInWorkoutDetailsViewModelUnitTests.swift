//
//  ExerciseRepsInWorkoutDetailsViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/24/22.
//

@testable import RepBuddyAppleWatch

import CoreData
import XCTest

final class ExerciseRepsInWorkoutDetailsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: ExerciseRepsInWorkoutDetailsViewModel!
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
        sut = ExerciseRepsInWorkoutDetailsViewModel(dataController: dataController, workout: Workout.example, exercise: Exercise.example, repSets: [])

        XCTAssertEqual(sut.workout.unwrappedType, Workout.example.unwrappedType, "The Workout names should match")
        XCTAssertEqual(sut.workout.unwrappedDate.numericDateNoTime, Workout.example.unwrappedDate.numericDateNoTime, "The Workout dates should match")
        XCTAssertEqual(sut.exercise.unwrappedName, Exercise.example.unwrappedName, "The Exercise names should match")
        XCTAssertEqual(sut.exercise.unwrappedGoalWeightUnit, Exercise.example.unwrappedGoalWeightUnit, "The Exercise goal weight units should match")
        XCTAssertEqual(sut.exercise.goalWeight, Exercise.example.goalWeight, "The Exercise goal weights should match")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .dataLoaded, "The default view state should be .displayingView")
        XCTAssertFalse(sut.addEditRepSetSheetIsShowing, "No sheets should be showing by default")
    }

    func test_OnSetupExerciseController_ControllerIsSetUp() {
        sut = ExerciseRepsInWorkoutDetailsViewModel(
            dataController: dataController,
            workout: Workout.example,
            exercise: Exercise.example,
            repSets: []
        )

        sut.setUpExerciseController()

        XCTAssertNotNil(sut.exerciseController, "The exerciseController can't be nil")
    }

    func test_OnFetchRepSetsWithNoResults_PropertiesAreSet() {
        let testExercise = helpers.createTestExercise()
        let testWorkout = helpers.createTestWorkout()
        sut = ExerciseRepsInWorkoutDetailsViewModel(
            dataController: dataController,
            workout: testWorkout,
            exercise: testExercise,
            repSets: []
        )

        sut.fetchRepSets(in: testExercise, and: testWorkout)

        XCTAssertTrue(sut.repSets.isEmpty, "No RepSets should have been fetched, as none were created")
        XCTAssertEqual(sut.viewState, .dataNotFound, "No data should've been found")
    }

    func test_OnFetchRepSetsWithResults_PropertiesAreSet() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddRepSets()
        sut = ExerciseRepsInWorkoutDetailsViewModel(
            dataController: dataController,
            workout: testWorkout,
            exercise: testExercise,
            repSets: []
        )

        sut.fetchRepSets(in: testExercise, and: testWorkout)

        XCTAssertEqual(sut.repSets.count, 5, "5 RepSets should've been fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded, "Data should've been found")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut = ExerciseRepsInWorkoutDetailsViewModel(
            dataController: dataController,
            workout: Workout.example,
            exercise: Exercise.example,
            repSets: []
        )

        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut = ExerciseRepsInWorkoutDetailsViewModel(
            dataController: dataController,
            workout: Workout.example,
            exercise: Exercise.example,
            repSets: []
        )

        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
