//
//  UnitTestHelpers.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/25/22.
//

@testable import RepBuddy

import CoreData
import Foundation

struct UnitTestHelpers {
    let dataController: DataController

    func createTestExercise() -> Exercise {
        return dataController.createExercise(
            name: "Test Exercise",
            goalWeight: 100,
            goalWeightUnit: WeightUnit.pounds
        )
    }

    func createTestWorkout() -> Workout {
        return dataController.createWorkout(
            type: .arms,
            date: Date.now
        )
    }

    func createTestExerciseAndAddToNewWorkout() -> (Exercise, Workout) {
        let testExercise = createTestExercise()
        let testWorkout = createTestWorkout()
        testWorkout.addToExercises(testExercise)

        return (testExercise, testWorkout)
    }

    /// Creates a test Exercise and a test Workout . Then 5 RepSets are added to those test objects.
    func createTestExerciseAndAddRepSets() -> (Exercise, Workout) {
        let newExercise = createTestExercise()
        let newWorkout = createTestWorkout()
        newWorkout.addToExercises(newExercise)
        return dataController.addTestRepSetsToExerciseAndWorkout(
            exercise: newExercise,
            workout: newWorkout
        )
    }

    func createTestRepSet(with exercise: Exercise, and workout: Workout) -> RepSet {
        return dataController.createRepSet(date: Date.now, reps: 12, weight: 75, exercise: exercise, workout: workout)
    }
}
