//
//  RepSetUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/30/22.
//

@testable import RepBuddy

import XCTest

final class RepSetUnitTests: BaseTestCase {
    func test_RepSetUnwrappedHelperProperties_ValuesAreCorrect() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let testRepSet = helpers.createTestRepSet(with: testExercise, and: testWorkout)

        XCTAssertEqual(testRepSet.unwrappedDate, testRepSet.date!)
    }

    func test_RepSetFormattedWeightWithExercise_ReturnsCorrectValue() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let testRepSet = helpers.createTestRepSet(with: testExercise, and: testWorkout)

        XCTAssertEqual(testRepSet.formattedWeight, "75 pounds", "A value should be returned as long as the RepSet has a value for its exercise property")
    }

    func test_RepSetFormattedWeightWithNoExercise_ReturnsNil() {
        let testRepSet = RepSet(context: moc)
        testRepSet.id = UUID()
        testRepSet.date = Date.now
        testRepSet.weight = 67
        testRepSet.reps = 1

        XCTAssertTrue(testRepSet.formattedWeight.isEmpty, "The formattedWeight must be an empty string if the RepSet doesn't have a value for its exercise property")
    }

    func test_RepSetFormattedDescriptionWithMultipleReps_ReturnsCorrectValue() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let testRepSet = helpers.createTestRepSet(with: testExercise, and: testWorkout)

        XCTAssertEqual(testRepSet.formattedDescription, "12 reps at 75 pounds", "The description should adjust to the plural form of 'Rep'")
    }

    func test_RepSetFormattedDescriptionWithOneRep_ReturnsCorrectValue() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let testRepSet = RepSet(context: moc)
        testRepSet.id = UUID()
        testRepSet.date = Date.now
        testRepSet.weight = 67
        testRepSet.reps = 1
        testRepSet.workout = testWorkout
        testRepSet.exercise = testExercise

        XCTAssertEqual(testRepSet.formattedDescription, "1 rep at 67 pounds", "The description should adjust to the singular form of 'Reps'")
    }

    func test_OnDeleteRepSet_AssociatedExerciseAndWorkoutAreNotDeleted() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let testRepSet = helpers.createTestRepSet(with: testExercise, and: testWorkout)

        dataController.deleteRepSet(testRepSet)

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 1, "1 Exercise should still exist")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "1 Workout should still exist")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 0, "No RepSets should exist")
    }
}
