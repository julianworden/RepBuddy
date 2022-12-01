//
//  Workout+CoreDataProperties.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var exercises: NSSet?
    @NSManaged public var repSets: NSSet?

}

// MARK: Generated accessors for exercises
extension Workout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

// MARK: Generated accessors for repSets
extension Workout {

    @objc(addRepSetsObject:)
    @NSManaged public func addToRepSets(_ value: RepSet)

    @objc(removeRepSetsObject:)
    @NSManaged public func removeFromRepSets(_ value: RepSet)

    @objc(addRepSets:)
    @NSManaged public func addToRepSets(_ values: NSSet)

    @objc(removeRepSets:)
    @NSManaged public func removeFromRepSets(_ values: NSSet)

}

extension Workout : Identifiable {

}
