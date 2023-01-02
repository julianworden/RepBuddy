//
//  WorkoutDetailsViewSheetNavigatorUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/29/22.
//

@testable import RepBuddyAppleWatch

import CoreData
import XCTest

final class WorkoutDetailsViewSheetNavigatorUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: WorkoutDetailsViewSheetNavigator!
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

    func test_OnInit_DefaultValuesAreCorrect() {
        let testWorkout = helpers.createTestWorkout()
        sut = WorkoutDetailsViewSheetNavigator(dataController: dataController, workout: testWorkout)

        XCTAssertFalse(sut.presentSheet, "No sheets should be presented by default")
        XCTAssertEqual(sut.dataController, dataController, "The dataController wasn't passed in properly")
        XCTAssertEqual(sut.sheetDestination, .none, "There should be no sheet destination by default")
        XCTAssertEqual(sut.workout, testWorkout, "The test workout wasn't passed in correctly")
    }

    func test_OnSheetDestinationDidSet_PresentSheetIsToggled() {
        sut = WorkoutDetailsViewSheetNavigator(dataController: dataController, workout: Workout.example)

        sut.sheetDestination = .addExerciseView

        XCTAssertTrue(sut.presentSheet, "The presentSheet property should've been toggled by sheetDestination's didSet")
    }

    func test_OnAddExerciseButtonTapped_PropertiesAreModifiedProperly() {
        sut = WorkoutDetailsViewSheetNavigator(dataController: dataController, workout: Workout.example)

        sut.addExerciseButtonTapped()

        XCTAssertEqual(sut.sheetDestination, .addExerciseView, "AddEditExerciseView should've been presented")
        XCTAssertTrue(sut.presentSheet, "The sheet should've been presented")
    }

    func test_OnEditWorkoutButtonTapped_PropertiesAreModifiedProperly() {
        let testWorkout = helpers.createTestWorkout()
        sut = WorkoutDetailsViewSheetNavigator(dataController: dataController, workout: testWorkout)

        sut.editWorkoutButtonTapped()

        XCTAssertEqual(sut.sheetDestination, .addEditWorkoutView(workoutToEdit: testWorkout), "AddEditWorkoutView should've been presented")
        XCTAssertTrue(sut.presentSheet, "The sheet should've been presented")
    }
}
