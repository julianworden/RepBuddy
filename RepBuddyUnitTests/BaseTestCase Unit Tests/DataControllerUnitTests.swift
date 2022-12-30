//
//  DataControllerUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/25/22.
//

@testable import RepBuddy

import XCTest

final class DataControllerUnitTests: BaseTestCase {

    // MARK: - Testing Methods

    func test_OnDataControllerGenerateSampleData_SuccessfullyCreatesSampleData() throws {
        try dataController.generateSampleData()

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 5, "generateSampleData() should generate 5 Exercises")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 50, "generateSampleData() should generate 50 Workouts")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 150, "generateSampleData() should generate 150 RepSets")
    }

    func test_OnDataControllerDeleteAllData_SuccessfullyDeletesAllDate() throws {
        try dataController.generateSampleData()

        dataController.deleteAllData()

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 0, "All Exercises should be deleted")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 0, "All Workouts should be deleted")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 0, "All RepSets should be deleted")
    }

    func test_OnDataControllerReturnFetchRequestCount_SuccessfullyFetchesCountForObject() {
        let (_, _) = helpers.createTestExerciseAndAddRepSets()

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 1, "1 Exercise should exist")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "1 Workout should exist")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 5, "5 RepSets should exist")
    }

    func test_OnDataControllerAddRepSetsToExerciseAndWorkout_WorkoutAndExerciseHaveRepSets() {
        let newExercise = helpers.createTestExercise()
        let newWorkout = helpers.createTestWorkout()
        newWorkout.addToExercises(newExercise)
        let (updatedExerciseWithRepSets, updatedWorkoutWithRepSets) = dataController.addTestRepSetsToExerciseAndWorkout(
            exercise: newExercise,
            workout: newWorkout
        )

        XCTAssertEqual(updatedExerciseWithRepSets.repSetsArray.count, 5, "5 RepSets should've been added to the Exercise")
        XCTAssertEqual(updatedWorkoutWithRepSets.repSetsArray.count, 5, "The same 5 RepSets should also exist in the Workout")
    }

    // MARK: - Exercise Methods

    func test_OnDataControllerGetAllExercises_ExercisesAreFetched() throws {
        try dataController.generateSampleData()

        let createdExercises = try dataController.getAllExercises()

        XCTAssertEqual(createdExercises.count, 5, "5 Exercises should've been fetched")
    }

    func test_OnDataControllerGetExerciseWithName_ExerciseIsFetched() throws {
        let testExercise = helpers.createTestExercise()

        XCTAssertNotNil(try dataController.getExercise(with: testExercise.unwrappedName))
        XCTAssertNil(try dataController.getExercise(with: "Gabeldy Gook"))
    }

    func test_OnDataControllerCreateExercise_ExerciseIsCreated() throws {
        _ = helpers.createTestExercise()

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 1, "1 Exercise should now exist")
        XCTAssertNotNil(try dataController.getExercise(with: "Test Exercise"), "This Exercise should now exist")
    }

    func test_OnDataControllerUpdateExercise_ExerciseIsUpdated() throws {
        let newExercise = helpers.createTestExercise()
        let updatedExercise = dataController.updateExercise(
            exerciseToEdit: newExercise,
            name: "Updated Exercise",
            goalWeight: 50,
            goalWeightUnit: WeightUnit.kilograms.rawValue
        )

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 1, "Only 1 Exercise should exist")
        XCTAssertEqual(try dataController.getExercise(with: "Updated Exercise"), updatedExercise, "The Exercise was not updated successfully")
        XCTAssertEqual(newExercise, updatedExercise, "The Exercise was not updated successfully")
    }

    func test_OnDataControllerDeleteExercise_ExerciseIsDeleted() throws {
        let newExercise = helpers.createTestExercise()
        try dataController.save()

        dataController.deleteExercise(newExercise)

        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 0, "No Exercises should exist")
        XCTAssertNil(try dataController.getExercise(with: "Test Exercise"), "There shouldn't be an Exercise to fetch")
    }

    // MARK: - Workout Methods

    func test_OnDataControllerCreateWorkout_WorkoutIsCreated() {
        _ = helpers.createTestWorkout()

        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "Only 1 Workout should exist")
    }

    func test_OnDataControllerUpdateWorkout_WorkoutIsUpdated() {
        let newWorkout = helpers.createTestWorkout()
        let updatedWorkout = dataController.updateWorkout(
            workoutToEdit: newWorkout,
            type: .legs,
            date: Date.now
        )

        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "Only 1 Workout should exist")
        XCTAssertEqual(newWorkout, updatedWorkout, "The Workout was not updated successfully")
    }

    func test_OnDataControllerDeleteWorkout_WorkoutIsDeleted() throws {
        let newWorkout = helpers.createTestWorkout()
        try dataController.save()

        dataController.deleteWorkout(newWorkout)

        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 0, "No Workouts should exist")
    }

    func test_OnDataControllerDeleteExerciseInWorkout_ExerciseAndRepSetsAreDeletedFromWorkout() throws {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddRepSets()

        try dataController.deleteExerciseInWorkout(delete: testExercise, in: testWorkout)

        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 0, "No RepSets should exist")
        XCTAssertEqual(dataController.count(for: Exercise.fetchRequest()), 1, "One Exercise should still exist")
        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 1, "One Workout should still exist")
        XCTAssertEqual(testWorkout.exercisesArray.count, 0, "The Workout shouldn't have any Exercises")
        XCTAssertEqual(testExercise.workoutsArray.count, 0, "The Exercise shouldn't have any Workouts")
        XCTAssertEqual(testExercise.repSetsArray.count, 0, "The Exercise shouldn't have any RepSets")
        XCTAssertEqual(testWorkout.repSetsArray.count, 0, "The Workout shouldn't have any RepSets")
    }

    // MARK: - RepSet Methods

    func test_OnDataControllerCreateRepSet_RepSetIsCreated() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()

        _ = dataController.createRepSet(
            date: Date.now,
            reps: 12,
            weight: 100,
            exercise: testExercise,
            workout: testWorkout
        )

        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 1, "1 RepSet should Exist")
        XCTAssertEqual(testExercise.repSetsArray.count, 1, "1 RepSet should belong to the Exercise")
        XCTAssertEqual(testWorkout.repSetsArray.count, 1, "1 RepSet should belong to the Workout")
    }

    func test_OnDataControllerUpdateRepSet_RepSetIsUpdated() {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddToNewWorkout()
        let newRepSet = dataController.createRepSet(
            date: Date.now,
            reps: 12,
            weight: 100,
            exercise: testExercise,
            workout: testWorkout
        )

        let updatedRepSet = dataController.updateRepSet(
            repSetToEdit: newRepSet,
            date: Date.now,
            reps: 50,
            weight: 25
        )

        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 1, "Only 1 RepSet should exist")
        XCTAssertEqual(updatedRepSet, newRepSet, "The RepSet wasn't updated")
    }

    func test_OnDataControllerDeleteRepSet_RepSetIsDeleted() throws {
        let (testExercise, _) = helpers.createTestExerciseAndAddRepSets()
        try dataController.save()

        for repSet in testExercise.repSetsArray {
            dataController.deleteRepSet(repSet)
        }

        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 0, "No RepSets should exist")
    }

    func test_OnDataControllerGetRepSets_FetchesRepSets() throws {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddRepSets()

        let testRepSets = try dataController.getRepSets(in: testExercise, and: testWorkout)

        XCTAssertEqual(testRepSets.count, 5, "5 RepSets should've been fetched")
    }

    func test_OnDataControllerCreateUpdatedRepSetDate_UpdatesRepSetDate() throws {
        let (testExercise, testWorkout) = helpers.createTestExerciseAndAddRepSets()
        let repSetToEdit = testExercise.repSetsArray.first!
        var dateComponents = DateComponents()
        dateComponents.year = 3
        dateComponents.month = 3
        dateComponents.day = 3
        dateComponents.hour = 3
        dateComponents.minute = 3
        dateComponents.second = 3
        guard let updatedWorkoutDate = Calendar.current.date(byAdding: dateComponents, to: testWorkout.unwrappedDate) else {
            XCTFail("The date should be generated successfully")
            return
        }

        guard let updatedRepSetDate = dataController.createUpdatedRepSetDate(
            for: repSetToEdit,
            with: updatedWorkoutDate
        ) else {
            XCTFail("The date should be generated successfully")
            return
        }
        let updatedRepSetDateYearMonthAndDay = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: updatedRepSetDate
        )
        let updatedRepSetDateHourMinuteAndSecond = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: updatedRepSetDate
        )

        XCTAssertEqual(
            updatedRepSetDateYearMonthAndDay,
            Calendar.current.dateComponents(
                [.year, .month, .day],
                from: updatedWorkoutDate
            )
        )
        XCTAssertEqual(
            updatedRepSetDateHourMinuteAndSecond,
            Calendar.current.dateComponents(
                [.hour, .minute, .second],
                from: repSetToEdit.unwrappedDate
            )
        )
    }
}
