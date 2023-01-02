//
//  AddEditWorkoutViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/29/22.
//

@testable import RepBuddy

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
        XCTAssertEqual(sut.workoutDate, workoutToEdit.unwrappedDate, "The Workout dates should match")
        XCTAssertEqual(sut.workoutType, WorkoutType(rawValue: workoutToEdit.unwrappedType)!, "The Workout types should match")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
        XCTAssertFalse(sut.dismissView, "The view shouldn't dismiss itself by default")
        XCTAssertFalse(sut.deleteWorkoutAlertIsShowing, "The view shouldn't have any alerts showing by default")
    }

    func test_OnInitWithNoWorkoutToEdit_ValuesAreCorrect() {
        sut = AddEditWorkoutViewModel(dataController: dataController)

        XCTAssertNil(sut.workoutToEdit, "No workoutToEdit should exist")
        // Need to compare the dates as strings instead of as Date.now or this test won't pass
        XCTAssertEqual(sut.workoutDate.completeDateAndTime, Date.now.completeDateAndTime, "The date should be now be default")
        XCTAssertEqual(sut.workoutType, .arms, "The default workout type should be arms")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
        XCTAssertFalse(sut.dismissView, "The view shouldn't dismiss itself by default")
        XCTAssertFalse(sut.deleteWorkoutAlertIsShowing, "The view shouldn't have any alerts showing by default")
    }

    func test_OnInitWithWorkoutToEdit_ComputedPropertiesAreCorrect() {
        sut = AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: Workout.example)

        XCTAssertEqual(sut.navigationTitle, "Edit Workout", "The view should be updating the workout")
        XCTAssertEqual(sut.saveButtonText, "Update Workout", "The view should be updating the Workout")
    }

    func test_OnInitWithNoWorkoutToEdit_ComputedPropertiesAreCorrect() {
        sut = AddEditWorkoutViewModel(dataController: dataController)

        XCTAssertEqual(sut.navigationTitle, "Add Workout", "The view should be updating the workout")
        XCTAssertEqual(sut.saveButtonText, "Save Workout", "The view should be updating the Workout")
    }

    func test_OnSaveButtonTappedWithWorkoutToEdit_WorkoutIsUpdated() throws {
        let testWorkout = helpers.createTestWorkout()
        sut = AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: testWorkout)
        sut.workoutDate = Date.now + 5
        sut.workoutType = WorkoutType.fullBody

        sut.saveButtonTapped()
        guard let updatedWorkout = try dataController.getAllWorkouts().first else {
            XCTFail("The updated workout should've been fetched")
            return
        }

        XCTAssertEqual(updatedWorkout.unwrappedType, WorkoutType.fullBody.rawValue, "The Workout type was not updated")
        XCTAssertEqual(updatedWorkout.unwrappedDate.completeDateAndTime, (Date.now + 5).completeDateAndTime)
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "Only one Workout should exist")
        XCTAssertTrue(sut.dismissView, "The view should be dismissed after the save button is tapped")
    }

    func test_OnSaveButtonTappedWithNoWorkoutToEdit_WorkoutIsSaved() throws {
        sut = AddEditWorkoutViewModel(dataController: dataController)
        sut.workoutDate = Date.now + 5
        sut.workoutType = WorkoutType.fullBody

        sut.saveButtonTapped()
        guard let createdWorkout = try dataController.getAllWorkouts().first else {
            XCTFail("The created workout should've been fetched")
            return
        }

        XCTAssertEqual(createdWorkout.unwrappedType, WorkoutType.fullBody.rawValue, "The Workout type was not updated")
        XCTAssertEqual(createdWorkout.unwrappedDate.completeDateAndTime, (Date.now + 5).completeDateAndTime)
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "Only one Workout should exist")
        XCTAssertTrue(sut.dismissView, "The view should be dismissed after the save button is tapped")
    }

    func test_OnDeleteWorkout_WorkoutIsDeleted() {
        let testWorkout = helpers.createTestWorkout()
        sut = AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: testWorkout)

        sut.deleteWorkout()

        XCTAssertTrue(sut.dismissView, "The view should get dismissed when the Workout is dismissed")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 0, "No Workouts should exist")
    }
}
