//
//  WorkoutUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddy

import XCTest

final class WorkoutUnitTests: BaseTestCase {
    func test_OnWorkoutDelete_RepSetsCascadeDeleteWorks() throws {
        try dataController.generateSampleData()

        let workoutsFetchRequest = Workout.fetchRequest()
        let fetchedWorkouts = try moc.fetch(workoutsFetchRequest)
        let workoutToDelete = fetchedWorkouts[0]
        moc.delete(workoutToDelete)

        XCTAssertEqual(dataController.count(for: Workout.fetchRequest()), 49, "There should be 49 Workouts left after deleting one")
        XCTAssertEqual(dataController.count(for: RepSet.fetchRequest()), 147, "There should be 147 RepSets left after deleting a Workout")
    }
}
