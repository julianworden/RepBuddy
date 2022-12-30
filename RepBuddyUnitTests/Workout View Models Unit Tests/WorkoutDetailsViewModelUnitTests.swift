//
//  WorkoutDetailsViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/22/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class WorkoutDetailsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: WorkoutDetailsViewModel!
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

    func test_OnWorkoutDetailsViewModelInit_ValuesAreCorrect() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        XCTAssertEqual(sut.workout.unwrappedType, Workout.example.unwrappedType, "The Workout names should match")
        XCTAssertEqual(sut.workout.unwrappedDate.numericDateNoTime, Workout.example.unwrappedDate.numericDateNoTime, "The Workout dates should match")
        XCTAssertEqual(sut.workoutExercises.count, Workout.example.exercisesArray.count, "The example Workout's exercisesArray should get assigned to the workoutExercises property")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertFalse(sut.dismissView, "dismissView should be false by default")
        XCTAssertFalse(sut.deleteExerciseInWorkoutAlertIsShowing, "No delete confirmation alert should be showing by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
    }

    func test_OnWorkoutDetailsViewModelSetupWorkoutController_ControllerIsSetUp() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.setupWorkoutController()

        XCTAssertNotNil(sut.workoutController, "The workoutController can't be nil")
    }

    func test_OnWorkoutDetailsViewModelDeleteExercise_ExerciseIsDeletedFromWorkout() {
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
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: newWorkoutWithNewRepSets)

        sut.deleteExercise(newExerciseWithNewRepSets)

        XCTAssertTrue(newExerciseWithNewRepSets.repSetsArray.isEmpty, "All the Exercise's RepSets should've been deleted")
        XCTAssertTrue(sut.workout.exercisesArray.isEmpty, "All the Workout's Exercises should've been deleted")
        XCTAssertTrue(newExerciseWithNewRepSets.workoutsArray.isEmpty, "All the Exercise's Workouts should've been deleted")
        XCTAssertNotNil(newExerciseWithNewRepSets, "The Exercise itself shouldn't have been deleted")
    }

    func test_OnWorkoutDetailsViewModelErrorViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnWorkoutDetailsViewModelInvalidViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_OnWorkoutDetailsViewModeldDataDeletedViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .dataDeleted

        XCTAssertTrue(sut.dismissView, "The view should get dismissed when the workout gets deleted")
    }
}
