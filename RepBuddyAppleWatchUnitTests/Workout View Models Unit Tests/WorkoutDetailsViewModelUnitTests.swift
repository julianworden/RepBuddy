//
//  WorkoutDetailsViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/22/22.
//

@testable import RepBuddyAppleWatch

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

    func test_OnInit_ValuesAreCorrect() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        XCTAssertEqual(sut.workout.unwrappedType, Workout.example.unwrappedType, "The Workout names should match")
        XCTAssertEqual(sut.workout.unwrappedDate.numericDateNoTime, Workout.example.unwrappedDate.numericDateNoTime, "The Workout dates should match")
        XCTAssertEqual(sut.workoutExercises.count, Workout.example.exercisesArray.count, "The example Workout's exercisesArray should get assigned to the workoutExercises property")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertFalse(sut.errorAlertIsShowing, "The error alert should not be shown by default")
        XCTAssertTrue(sut.errorAlertText.isEmpty, "There should be no error alert text by default")
        XCTAssertFalse(sut.dismissView, "dismissView should be false by default")
        XCTAssertEqual(sut.viewState, .displayingView, "The default view state should be .displayingView")
    }

    func test_OnSetupWorkoutController_ControllerIsSetUp() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.setupWorkoutController()

        XCTAssertNotNil(sut.workoutController, "The workoutController can't be nil")
    }

    func test_OnErrorViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .error(message: "Test Error")

        XCTAssertEqual(sut.errorAlertText, "Test Error", "The errorAlertText property should be set with an error message when the .error view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when the .error view state is set")
    }

    func test_OnInvalidViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .dataNotFound

        XCTAssertEqual(sut.errorAlertText, "Invalid ViewState", "The errorAlertText property should be set with an error message when an invalid view state is set")
        XCTAssertTrue(sut.errorAlertIsShowing, "The error alert should be showing when an invalid view state is set")
    }

    func test_OnDataDeletedViewState_ChangesProperties() {
        sut = WorkoutDetailsViewModel(dataController: dataController, workout: Workout.example)

        sut.viewState = .dataDeleted

        XCTAssertTrue(sut.dismissView, "The view should get dismissed when the workout gets deleted")
    }
}
