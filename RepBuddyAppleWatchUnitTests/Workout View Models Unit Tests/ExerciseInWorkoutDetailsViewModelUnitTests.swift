//
//  WorkoutDetailsViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/22/22.
//

@testable import RepBuddyAppleWatch

import CoreData
import XCTest

final class ExerciseInWorkoutDetailsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: ExerciseInWorkoutDetailsViewModel!
    var helpers: UnitTestHelpers!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        helpers = UnitTestHelpers.init(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnInit_ValuesAreCorrect() {
        let testExercise = helpers.createTestExercise()
        let testWorkout = helpers.createTestWorkout()
        sut = ExerciseInWorkoutDetailsViewModel(dataController: dataController, exercise: testExercise, workout: testWorkout)

        XCTAssertEqual(sut.workout, testWorkout, "The Workout was not passed in properly")
        XCTAssertEqual(sut.exercise, testExercise, "The Exercise was not passed in properly")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.addEditRepSetSheetIsShowing, "No sheets should be showing by default")
        XCTAssertFalse(sut.deleteExerciseAlertIsShowing, "No sheets should be showing by default")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .dataLoading, "The default view state should be .dataLoading")
    }

    func test_OnSetupExerciseController_ControllerIsSetUp() {
        sut = ExerciseInWorkoutDetailsViewModel(dataController: dataController, exercise: Exercise.example, workout: Workout.example)

        sut.setupExerciseController()

        XCTAssertNotNil(sut.exerciseController, "The exerciseController can't be nil")
    }

    func test_OnFetchRepSetsWithNoResults_PropertiesAreSet() {
        let testExercise = helpers.createTestExercise()
        let testWorkout = helpers.createTestWorkout()
        sut = ExerciseInWorkoutDetailsViewModel(
            dataController: dataController,
            exercise: testExercise,
            workout: testWorkout
        )

        sut.fetchRepSets(in: testExercise, and: testWorkout)

        XCTAssertTrue(sut.exerciseRepSets.isEmpty, "No RepSets should have been fetched, as none were created")
    }

    func test_OnFetchRepSetsWithResults_PropertiesAreSet() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddRepSets()
        sut = ExerciseInWorkoutDetailsViewModel(
            dataController: dataController,
            exercise: testExercise,
            workout: testWorkout
        )

        sut.fetchRepSets(in: testExercise, and: testWorkout)

        XCTAssertEqual(sut.exerciseRepSets.count, 5, "5 RepSets should've been fetched")
    }

    func test_OnDeleteExercise_ExerciseIsDeletedFromWorkout() {
        let newWorkout = helpers.createTestWorkout()
        let newExercise = dataController.createExercise(
            name: "Test Exercise",
            goalWeight: 100,
            goalWeightUnit: WeightUnit.kilograms
        )
        let (newExerciseWithNewRepSets, newWorkoutWithNewRepSets) = dataController.addTestRepSetsToExerciseAndWorkout(
            exercise: newExercise,
            workout: newWorkout
        )
        newWorkoutWithNewRepSets.addToExercises(newExerciseWithNewRepSets)
        sut = ExerciseInWorkoutDetailsViewModel(dataController: dataController, exercise: newExerciseWithNewRepSets, workout: newWorkoutWithNewRepSets)

        sut.deleteExercise()

        XCTAssertTrue(newExerciseWithNewRepSets.repSetsArray.isEmpty, "All the Exercise's RepSets should've been deleted")
        XCTAssertTrue(sut.workout.exercisesArray.isEmpty, "All the Workout's Exercises should've been deleted")
        XCTAssertTrue(newExerciseWithNewRepSets.workoutsArray.isEmpty, "All the Exercise's Workouts should've been deleted")
        XCTAssertNotNil(newExerciseWithNewRepSets, "The Exercise itself shouldn't have been deleted")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut = ExerciseInWorkoutDetailsViewModel(dataController: dataController, exercise: Exercise.example, workout: Workout.example)

        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut = ExerciseInWorkoutDetailsViewModel(dataController: dataController, exercise: Exercise.example, workout: Workout.example)

        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
