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
