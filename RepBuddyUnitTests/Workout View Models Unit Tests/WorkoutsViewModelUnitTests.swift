//
//  WorkoutsViewModel.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/22/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class WorkoutsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: WorkoutsViewModel!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        sut = WorkoutsViewModel(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnWorkoutsViewModelInit_DefaultValuesAreCorrect() {
        XCTAssertEqual(sut.workouts, [], "The workouts array should be initialized to [] by default")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.addEditWorkoutSheetIsShowing, "No sheet should be showing by default")
        XCTAssertFalse(sut.errorAlertIsShowing, "No error alert should be showing by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "No error alert text should be shown be set by default")
    }

    func test_OnWorkoutsViewModelSetupWorkoutsController_ControllerIsSetUp() {
        sut.setupWorkoutsController()

        XCTAssertNotNil(sut.workoutsController, "The workoutsController should've been set up")
    }

    func test_OnWorkoutsViewModelGetWorkouts_SetsViewStateWhenWorkoutsExist() throws {
        try dataController.generateSampleData()

        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.workouts.count, 50, "50 Workouts should be fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded, "The view state should be changed to .dataLoaded")
    }

    func test_OnWorkoutsViewModelGetWorkouts_SetsViewStateWhenNoWorkoutsExist() {
        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.viewState, .dataNotFound, "The view state should be .dataNotFound, as no sample data was generated")
    }

    func test_OnWorkoutsViewModelDeleteWorkout_WorkoutIsDeleted() throws {
        try dataController.generateSampleData()
        sut.setupWorkoutsController()
        sut.getWorkouts()

        sut.deleteWorkout(at: IndexSet(integer: 0))

        XCTAssertEqual(sut.workouts.count, 49, "The workouts array should now have 49 Workouts")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 49, "49 Workouts should now exist")
    }

    func test_OnWorkoutsViewModelErrorViewState_ChangesProperties() {
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnWorkoutsViewModelInvalidViewState_ChangesProperties() {
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
