//
//  ExerciseRepsInWorkoutDetailsViewModelUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/24/22.
//

@testable import RepBuddy

import CoreData
import XCTest

final class ExerciseRepsInWorkoutDetailsViewModelUnitTests: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var sut: ExerciseRepsInWorkoutDetailsViewModel!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.moc
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController.deleteAllData()
    }
}
