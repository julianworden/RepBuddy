//
//  WorkoutsViewModel.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/22/22.
//

@testable import RepBuddyAppleWatch

import CoreData
import XCTest

final class WorkoutsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: WorkoutsViewModel!
    var helpers: UnitTestHelpers!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        sut = WorkoutsViewModel(dataController: dataController)
        helpers = UnitTestHelpers(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnInit_DefaultValuesAreCorrect() {
        XCTAssertEqual(sut.workouts, [], "The workouts array should be initialized to [] by default")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.addWorkoutSheetIsShowing, "No sheet should be showing by default")
        XCTAssertFalse(sut.errorAlertIsShowing, "No error alert should be showing by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "No error alert text should be shown be set by default")
    }

    func test_OnSetupWorkoutsController_ControllerIsSetUp() {
        sut.setupWorkoutsController()

        XCTAssertNotNil(sut.workoutsController, "The workoutsController should've been set up")
    }

    func test_WorkoutsArray_IsSortedByDate() {
        let workoutWithEarlierDate = Workout(context: moc)
        workoutWithEarlierDate.id = UUID()
        workoutWithEarlierDate.type = WorkoutType.core.rawValue
        workoutWithEarlierDate.date = Date.now
        let workoutWithLaterDate = Workout(context: moc)
        workoutWithLaterDate.id = UUID()
        workoutWithLaterDate.type = WorkoutType.arms.rawValue
        workoutWithLaterDate.date = Date.now + 5
        let testExercise = helpers.createTestExercise()
        testExercise.addToWorkouts(workoutWithEarlierDate)
        testExercise.addToWorkouts(workoutWithLaterDate)

        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.workouts, [workoutWithLaterDate, workoutWithEarlierDate], "The latest workout should be listed first")
        XCTAssertEqual(sut.workouts.count, 2, "2 Workouts should've been fetched")
    }

    func test_OnGetWorkouts_SetsViewStateWhenWorkoutsExist() throws {
        try dataController.generateSampleData()

        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.workouts.count, 50, "50 Workouts should be fetched")
        XCTAssertEqual(sut.viewState, .dataLoaded, "The view state should be changed to .dataLoaded")
    }

    func test_OnGetWorkouts_SetsViewStateWhenNoWorkoutsExist() {
        sut.setupWorkoutsController()
        sut.getWorkouts()

        XCTAssertEqual(sut.viewState, .dataNotFound, "The view state should be .dataNotFound, as no sample data was generated")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut.viewState = .displayingView

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }
}
