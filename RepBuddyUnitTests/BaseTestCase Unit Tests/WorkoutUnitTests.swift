//
//  WorkoutUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddy

import XCTest

final class WorkoutUnitTests: BaseTestCase {
    func test_WorkoutUnwrappedHelperProperties_ReturnCorrectValues() {
        let testWorkout = helpers.createTestWorkout()

        XCTAssertEqual(testWorkout.id!, testWorkout.unwrappedId)
        XCTAssertEqual(testWorkout.type, testWorkout.unwrappedType)
        XCTAssertEqual(testWorkout.date!, testWorkout.unwrappedDate)
    }

    func test_WorkoutExercisesArray_IsSortedAlphabetically() {
        let testWorkout = helpers.createTestWorkout()
        let exerciseStartingWithA = Exercise(context: moc)
        exerciseStartingWithA.id = UUID()
        exerciseStartingWithA.name = "AAA"
        exerciseStartingWithA.goalWeight = 450
        exerciseStartingWithA.goalWeightUnit = WeightUnit.kilograms.rawValue
        let exerciseStartingWithZ = Exercise(context: moc)
        exerciseStartingWithZ.id = UUID()
        exerciseStartingWithZ.name = "ZZZ"
        exerciseStartingWithZ.goalWeight = 300
        exerciseStartingWithZ.goalWeightUnit = WeightUnit.pounds.rawValue

        testWorkout.addToExercises(exerciseStartingWithZ)
        testWorkout.addToExercises(exerciseStartingWithA)

        XCTAssertEqual(testWorkout.exercisesArray.count, 2, "Two Exercises should belong in the Workout")
        XCTAssertEqual(testWorkout.exercisesArray, [exerciseStartingWithA, exerciseStartingWithZ], "The Exercise starting with A should come before the one starting with Z")
    }

    func test_WorkoutRepSetsArray_IsSortedByDate() {
        let testWorkout = helpers.createTestWorkout()
        let repSetWithEarlierDate = RepSet(context: moc)
        repSetWithEarlierDate.id = UUID()
        repSetWithEarlierDate.date = Date.now
        repSetWithEarlierDate.weight = 76
        repSetWithEarlierDate.reps = 15
        let repSetWithLaterDate = RepSet(context: moc)
        repSetWithLaterDate.id = UUID()
        repSetWithLaterDate.date = Date.now + 5
        repSetWithLaterDate.weight = 95
        repSetWithLaterDate.reps = 20

        testWorkout.addToRepSets(repSetWithLaterDate)
        testWorkout.addToRepSets(repSetWithEarlierDate)

        XCTAssertEqual(testWorkout.repSetsArray.count, 2, "The Workout should have 2 RepSets")
        XCTAssertEqual(testWorkout.repSetsArray, [repSetWithEarlierDate, repSetWithLaterDate], "The RepSet with the earlier date should come first")
    }

    func test_ExampleWorkout_HasExpectedValues() {
        let exampleWorkout = Workout.example

        XCTAssertEqual(exampleWorkout.unwrappedDate.numericDateNoTime, Date.now.numericDateNoTime, "The example Workout's date should be the same as today's date")
        XCTAssertEqual(exampleWorkout.type, WorkoutType.arms.rawValue, "The example Workout's type should be Arms")
    }

    func test_OnWorkoutDelete_RepSetsCascadeDeleteWorks() throws {
        try dataController.generateSampleData()

        let workoutsFetchRequest = Workout.fetchRequest()
        let fetchedWorkouts = try moc.fetch(workoutsFetchRequest)
        let workoutToDelete = fetchedWorkouts[0]
        moc.delete(workoutToDelete)

        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 49, "There should be 49 Workouts left after deleting one")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 147, "There should be 147 RepSets left after deleting a Workout")
    }

    func test_OnWorkoutDelete_AssociatedExerciseIsNotDeleted() throws {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        try dataController.save()

        dataController.deleteWorkout(testWorkout)

        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 0, "No Workouts should exist")
        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 1, "1 Exercise should still exist")
        XCTAssertEqual(testExercise.workoutsArray.count, 0, "The Exercise shouldn't have any Workouts")
        XCTAssertNotNil(try dataController.getExercise(with: testExercise.unwrappedName), "The created exercise should still exist")
    }
}
