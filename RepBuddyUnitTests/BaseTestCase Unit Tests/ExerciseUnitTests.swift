//
//  ExerciseUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class ExerciseUnitTests: BaseTestCase {
    func test_ExerciseUnwrappedHelperProperties_ReturnCorrectValues() {
        let testExercise = helpers.createTestExercise()

        XCTAssertEqual(testExercise.name!, testExercise.unwrappedName)
        XCTAssertEqual(testExercise.id!, testExercise.unwrappedId)
        XCTAssertEqual(testExercise.unwrappedGoalWeightUnit, testExercise.unwrappedGoalWeightUnit)
    }

    func test_ExerciseFormattedGoalWeight_ReturnsExpectedValue() {
        let testExercise = helpers.createTestExercise()

        XCTAssertEqual(testExercise.formattedGoalWeight, "\(testExercise.goalWeight) \(testExercise.unwrappedGoalWeightUnit.capitalized)")
    }

    func test_ExerciseWorkoutsArray_IsSortedByDate() {
        let workoutWithEarlierDate = Workout(context: moc)
        workoutWithEarlierDate.id = UUID()
        workoutWithEarlierDate.type = WorkoutType.core.rawValue
        workoutWithEarlierDate.date = Date.now
        let workoutWithLaterDate = Workout(context: moc)
        workoutWithLaterDate.id = UUID()
        workoutWithLaterDate.type = WorkoutType.arms.rawValue
        workoutWithLaterDate.date = Date.now + 5
        let testExercise = helpers.createTestExercise()
        testExercise.addToWorkouts(workoutWithLaterDate)
        testExercise.addToWorkouts(workoutWithEarlierDate)

        XCTAssertEqual(testExercise.workoutsArray.count, 2, "The Exercise should have 2 Workouts")
        XCTAssertEqual(testExercise.workoutsArray, [workoutWithEarlierDate, workoutWithLaterDate], "The Workout with the earlier date should come first")
    }

    func test_ExerciseWorkoutNamesArray_HasExpectedElements() {
        let workoutWithEarlierDate = Workout(context: moc)
        workoutWithEarlierDate.id = UUID()
        workoutWithEarlierDate.type = WorkoutType.core.rawValue
        workoutWithEarlierDate.date = Date.now
        let workoutWithLaterDate = Workout(context: moc)
        workoutWithLaterDate.id = UUID()
        workoutWithLaterDate.type = WorkoutType.arms.rawValue
        workoutWithLaterDate.date = Date.now + 5
        let testExercise = helpers.createTestExercise()

        testExercise.addToWorkouts(workoutWithLaterDate)
        testExercise.addToWorkouts(workoutWithEarlierDate)

        XCTAssertEqual(testExercise.workoutNamesArray.count, 2, "The Exercise should have 2 Workouts")
        XCTAssertEqual(
            [
                workoutWithEarlierDate.formattedNumericDateTimeOmitted,
                workoutWithLaterDate.formattedNumericDateTimeOmitted
            ],
            testExercise.workoutNamesArray
        )
    }

    func test_ExerciseCountDescriptionsWithMultipleWorkoutsAndRepSets_ReturnCorrectValues() throws {
        try dataController.generateSampleData()

        let testExercise = try dataController.getAllExercises().first!

        XCTAssertEqual(testExercise.workoutsCountDescription, "10 Workouts", "The description should show the amount of Workouts with the correct plural or singular form of 'Workout'")
        XCTAssertEqual(testExercise.repSetsCountDescription, "30 Sets", "The description should show the amount of repSets with the correct plural form of 'Set'")
    }

    func test_ExerciseCountDescriptionsWithOneWorkoutsAndOneRepSet_ReturnCorrectValues() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let _ = helpers.createTestRepSet(with: testExercise, and: testWorkout)

        XCTAssertEqual(testExercise.workoutsCountDescription, "1 Workout", "The description should show the amount of workouts with the correct plural or singular form of 'Workout'")
        XCTAssertEqual(testExercise.repSetsCountDescription, "1 Set", "The description should show the amount of repSets with the correct singular form of 'Set'")
    }

    func test_ExerciseRepSetsArray_IsSortedProperly() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let laterTestRepSet = dataController.createRepSet(
            date: Date.now + 5,
            reps: 12,
            weight: 78,
            exercise: testExercise,
            workout: testWorkout
        )
        let earlierTestRepSet = dataController.createRepSet(
            date: Date.now,
            reps: 9,
            weight: 100,
            exercise: testExercise,
            workout: testWorkout
        )

        XCTAssertEqual(testExercise.repSetsArray.count, 2, "Two RepSets should've been added to the Exercise")
        XCTAssertEqual(testExercise.repSetsArray, [earlierTestRepSet, laterTestRepSet])
    }

    func test_ExerciseHighestRepSetWeightWithExerciseThatHasRepSets_ReturnsCorrectValue() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let _ = dataController.createRepSet(
            date: Date.now,
            reps: 12,
            weight: 50,
            exercise: testExercise,
            workout: testWorkout
        )
        let _ = dataController.createRepSet(
            date: Date.now,
            reps: 9,
            weight: 100,
            exercise: testExercise,
            workout: testWorkout
        )

        XCTAssertNotNil(testExercise.highestRepSetWeight, "Two RepSets have been added to the Exercise, so this shouldn't be nil")
        XCTAssertEqual(testExercise.highestRepSetWeight, 100, "The highest RepSet weight should be 100")
    }

    func test_ExerciseHighestRepSetWeightWithExerciseThatHasNoRepSets_ReturnsNil() {
        let testExercise = helpers.createTestExercise()

        XCTAssertNil(testExercise.highestRepSetWeight, "The Exercise has no RepSets, so it can't return a maximum RepSet weight value")
    }

    func test_ExerciseDistanceFromGoalWeightWithExerciseThatHasRepSet_ReturnsCorrectValue() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let _ = dataController.createRepSet(
            date: Date.now,
            reps: 12,
            weight: 50,
            exercise: testExercise,
            workout: testWorkout
        )

        XCTAssertNotNil(testExercise.distanceFromGoalWeight, "The value shouldn't be nil because the Exercise has a RepSet")
        XCTAssertEqual(testExercise.distanceFromGoalWeight, 50, "The RepSet that was created has a value that is 50 lower than the Exercise's goal weight")
    }

    func test_ExerciseDistanceFromGoalWeightWithExerciseThatHasRepSetAboveGoal_ReturnsNil() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let _ = dataController.createRepSet(
            date: Date.now,
            reps: 12,
            weight: 150,
            exercise: testExercise,
            workout: testWorkout
        )

        XCTAssertNil(testExercise.distanceFromGoalWeight, "The value shouldn be nil because the Exercise has a RepSet that is above its goal weight")
    }

    func test_ExerciseDistanceFromGoalWeightWithExerciseThatHasNoRepSet_ReturnsNil() {
        let testExercise = helpers.createTestExercise()

        XCTAssertNil(testExercise.distanceFromGoalWeight, "The value shouldn be nil because the Exercise has no RepSets")
    }

    func test_ExampleExercise_HasExpectedValues() {
        let exampleExercise = Exercise.example

        XCTAssertEqual(exampleExercise.name, "Decline Press", "The example Exercise's name should be Decline Press")
        XCTAssertEqual(exampleExercise.goalWeight, 100, "The example Exercise's goal weight should be 100")
        XCTAssertEqual(exampleExercise.goalWeightUnit, WeightUnit.kilograms.rawValue, "The example Exercise's goal weight unit should be pounds")
    }

    func test_OnExerciseDelete_RepSetCascadeDeleteWorks() throws {
        try dataController.generateSampleData()

        let exerciseFetchRequest = Exercise.fetchRequest()
        let fetchedExercises = try moc.fetch(exerciseFetchRequest)
        let exerciseToDelete = fetchedExercises[0]
        moc.delete(exerciseToDelete)

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 4, "There should only be 4 Exercises remaining after one is deleted)")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 120, "There should only be 120 RepSets remaining after an Exercise is deleted")
    }
}
