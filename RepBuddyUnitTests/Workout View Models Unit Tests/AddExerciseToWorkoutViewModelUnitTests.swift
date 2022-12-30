//
//  AddExerciseToWorkoutViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/28/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class AddExerciseToWorkoutViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: AddExerciseToWorkoutViewModel!
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

    func test_OnAddExerciseToWorkoutViewModelInit_ValuesAreCorrect() {
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: Workout.example)

        XCTAssertEqual(sut.workout.unwrappedType, Workout.example.unwrappedType, "The Workout names should match")
        XCTAssertEqual(sut.workout.unwrappedDate.numericDateNoTime, Workout.example.unwrappedDate.numericDateNoTime, "The Workout dates should match")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .dataLoading, "The default view state should be .displayingView")
        XCTAssertFalse(sut.dismissView, "The view shouldn't dismiss itself by default")
        XCTAssertTrue(sut.allUserExercises.isEmpty, "There shouldn't be any Exercises by default")
    }

    func test_OnAddExerciseToWorkoutViewModelExerciseIsSelectable_IsTrueWhenWorkoutDoesNotContainExercise() {
        let testExercise = helpers.createTestExercise()
        let (_, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: testWorkout)

        XCTAssertTrue(sut.exerciseIsSelectable(testExercise), "The Exercise should be selectable because it's not part of the Workout")
    }

    func test_OnAddExerciseToWorkoutViewModelExerciseIsSelectable_IsFalseWhenWorkoutDoesContainExercise() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: testWorkout)

        XCTAssertFalse(sut.exerciseIsSelectable(testExercise), "The Exercise should not be selectable because it's already part of the Workout")
    }

    func test_OnAddExerciseToWorkoutViewModelFetchAllUserExercises_FetchesDataWhenExercisesExist() throws {
        try dataController.generateSampleData()
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: Workout.example)

        sut.fetchAllUserExercises()

        XCTAssertEqual(sut.allUserExercises.count, 5, "5 Exercises should've been fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded)
    }

    func test_OnAddExerciseToWorkoutViewModelFetchAllUserExercises_SetsPropertiesWhenNoExercisesExist() throws {
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: Workout.example)

        sut.fetchAllUserExercises()

        XCTAssertTrue(sut.allUserExercises.isEmpty, "No Exercises should've been fetched, as none exist")
        XCTAssertEqual(sut.viewState, .dataNotFound, "No data should've been fetched")
    }

    func test_OnAddExerciseToWorkoutViewModelExerciseSelected_ExerciseIsAddedToWorkout() throws {
        let testExercise = helpers.createTestExercise()
        let testWorkout = helpers.createTestWorkout()
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: testWorkout)

        sut.exerciseSelected(testExercise)

        XCTAssertTrue(sut.dismissView, "The view should be dismissed after an Exercise is selected")
        XCTAssertEqual(testWorkout.exercisesArray.count, 1, "The Exercise should've been added to the Workout")
        XCTAssertEqual(testWorkout.exercisesArray.first!, testExercise, "The testExercise should've been added to the Workout")
    }

    func test_OnAddExerciseToWorkotuViewModelErrorViewState_ChangesProperties() {
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnAddExerciseToWorkotuViewModelInvalidViewState_ChangesProperties() {
        sut = AddExerciseToWorkoutViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
