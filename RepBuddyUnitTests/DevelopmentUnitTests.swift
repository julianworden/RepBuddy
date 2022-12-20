//
//  DevelopmentUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class DevelopmentUnitTests: BaseTestCase {
    func test_GenerateSampleData_SuccessfullyCreatesSampleData() throws {
        try dataController.generateSampleData()

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 5, "generateSampleData() should generate 5 Exercises")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 50, "generateSampleData() should generate 10 Workouts")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 150, "generateSampleData() should generate 3 RepSets")
    }

    func test_DeleteAllData_SuccessfullyDeletesAllDate() throws {
        try dataController.generateSampleData()

        dataController.deleteAllData()

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 0, "All Exercises should be deleted")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 0, "All Workouts should be deleted")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 0, "All RepSets should be deleted")
    }

    func test_ExampleExercise_HasExpectedValues() {
        let exampleExercise = Exercise.example

        XCTAssertEqual(exampleExercise.name, "Decline Press", "The example Exercise's name should be Decline Press")
        XCTAssertEqual(exampleExercise.goalWeight, 100, "The example Exercise's goal weight should be 100")
        XCTAssertEqual(exampleExercise.goalWeightUnit, WeightUnit.pounds.rawValue, "The example Exercise's goal weight unit should be pounds")
    }

    func test_ExampleWorkout_HasExpectedValues() {
        let exampleWorkout = Workout.example

        XCTAssertEqual(exampleWorkout.unwrappedDate.numericDateNoTime, Date.now.numericDateNoTime, "The example Workout's date should be the same as today's date")
        XCTAssertEqual(exampleWorkout.type, WorkoutType.arms.rawValue, "The example Workout's type should be Arms")
    }
}
