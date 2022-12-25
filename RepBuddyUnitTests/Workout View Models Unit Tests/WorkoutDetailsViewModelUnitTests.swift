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

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
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

    func test_OnWorkoutDetailsViewModelDeleteExercise_ExerciseIsDeletedFromWorkout() throws {
        let newWorkout = try dataController.createWorkout(with: .core)
        let newExercise = try dataController.createExercise(with: "Test Exercise")
        let newExerciseWithNewRepSets = try dataController.addRepSetsToExerciseAndWorkout(exercise: newExercise, workout: newWorkout)
        let newWorkoutWithNewExercise = try dataController.addExerciseToWorkout(add: newExerciseWithNewRepSets, to: newWorkout)
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: newWorkoutWithNewExercise)

        sut.deleteExercise(newExerciseWithNewRepSets)

        XCTAssertTrue(newExerciseWithNewRepSets.repSetArray.isEmpty, "All the Exercise's RepSets should've been deleted")
        XCTAssertTrue(sut.workout.exercisesArray.isEmpty, "All the Workout's Exercises should've been deleted")
        XCTAssertTrue(newExerciseWithNewRepSets.workoutsArray.isEmpty, "All the Exercise's Workouts should've been deleted")
        XCTAssertNotNil(newExerciseWithNewRepSets, "The Exercise itself shouldn't have been deleted")
    }

    func test_WorkoutDetailsViewModelErrorViewState_ChangesProperties() throws {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_WorkoutDetailsViewModelInvalidViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_WorkoutDetailsViewModeldDataDeletedViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .dataDeleted

        XCTAssertTrue(sut.dismissView, "The view should get dismissed when the workout gets deleted")
    }
}
