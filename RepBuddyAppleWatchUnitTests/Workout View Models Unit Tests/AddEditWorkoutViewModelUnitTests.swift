//
//  AddEditWorkoutViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/29/22.
//

@testable import RepBuddyAppleWatch

import CoreData
import XCTest

final class AddEditWorkoutViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: AddEditWorkoutViewModel!
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

    func test_OnInitWithWorkoutToEdit_ValuesAreCorrect() {
        let workoutToEdit = helpers.createTestWorkout()
        sut = AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: workoutToEdit)

        XCTAssertEqual(sut.workoutToEdit, workoutToEdit, "The Workouts should match")
        XCTAssertEqual(sut.workoutType, WorkoutType(rawValue: workoutToEdit.unwrappedType)!, "The Workout types should match")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .dataLoading, "The default view state should be .displayingView")
        XCTAssertFalse(sut.deleteWorkoutAlertIsShowing, "The view shouldn't have any alerts showing by default")
    }

    func test_OnInitWithNoWorkoutToEdit_ValuesAreCorrect() {
        sut = AddEditWorkoutViewModel(dataController: dataController)

        XCTAssertNil(sut.workoutToEdit, "No workoutToEdit should exist")
        XCTAssertEqual(sut.workoutType, .arms, "The default workout type should be arms")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .dataLoading, "The default view state should be .displayingView")
        XCTAssertFalse(sut.deleteWorkoutAlertIsShowing, "The view shouldn't have any alerts showing by default")
    }

    func test_OnInitWithWorkoutToEdit_ComputedPropertiesAreCorrect() {
        sut = AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: Workout.example)

        XCTAssertEqual(sut.saveButtonText, "Update Workout", "The view should be updating the Workout")
    }

    func test_OnInitWithNoWorkoutToEdit_ComputedPropertiesAreCorrect() {
        sut = AddEditWorkoutViewModel(dataController: dataController)

        XCTAssertEqual(sut.saveButtonText, "Save Workout", "The view should be updating the Workout")
    }

    func test_OnSaveButtonTappedWithWorkoutToEdit_WorkoutIsUpdated() throws {
        let testWorkout = helpers.createTestWorkout()
        sut = AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: testWorkout)
        sut.workoutType = WorkoutType.fullBody

        sut.saveButtonTapped()
        guard let updatedWorkout = try dataController.getAllWorkouts().first else {
            XCTFail("The updated workout should've been fetched")
            return
        }

        XCTAssertEqual(updatedWorkout.unwrappedType, WorkoutType.fullBody.rawValue, "The Workout type was not updated")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "Only one Workout should exist")
    }

    func test_OnSaveButtonTappedWithNoWorkoutToEdit_WorkoutIsSaved() throws {
        sut = AddEditWorkoutViewModel(dataController: dataController)
        sut.workoutType = WorkoutType.fullBody

        sut.saveButtonTapped()
        guard let createdWorkout = try dataController.getAllWorkouts().first else {
            XCTFail("The created workout should've been fetched")
            return
        }

        XCTAssertEqual(createdWorkout.unwrappedType, WorkoutType.fullBody.rawValue, "The Workout type was not updated")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "Only one Workout should exist")
    }

    func test_OnDeleteWorkout_WorkoutIsDeleted() {
        let testWorkout = helpers.createTestWorkout()
        sut = AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: testWorkout)

        sut.deleteWorkout()

        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 0, "No Workouts should exist")
    }
}
