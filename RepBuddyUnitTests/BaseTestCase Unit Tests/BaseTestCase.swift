//
//  RepBuddyUnitTests.swift
//  RepBuddyUnitTests
//
//  Created by Julian Worden on 12/20/22.
//

@testable import RepBuddy

import CoreData
import XCTest

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    var helpers: UnitTestHelpers!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.container.viewContext
        helpers = UnitTestHelpers(dataController: dataController)
    }

    override func tearDownWithError() throws {
        dataController.deleteAllData()
    }
}
