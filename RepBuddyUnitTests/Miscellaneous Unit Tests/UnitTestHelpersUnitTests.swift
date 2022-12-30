//
//  UnitTestHelpersUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/30/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class UnitTestHelpersUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: UnitTestHelpers!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
        sut = UnitTestHelpers(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }

    func test_OnUnitTestHelpersCreateTestExercise_TestExerciseValuesAreCorrect() {
        let testExercise = sut.createTestExercise()

        XCTAssertEqual(testExercise.name, "Test Exercise")
        XCTAssertEqual(testExercise.goalWeight, 100)
        XCTAssertEqual(testExercise.goalWeightUnit, WeightUnit.pounds.rawValue)
    }

    func test_OnUnitTestHelpersCreateTestWorkout_TestWorkoutValuesAreCorrect() {
        let testWorkout = sut.createTestWorkout()

        XCTAssertEqual(testWorkout.type, WorkoutType.arms.rawValue)
        XCTAssertEqual(testWorkout.unwrappedDate.completeDateAndTime, Date.now.completeDateAndTime)
    }
}
