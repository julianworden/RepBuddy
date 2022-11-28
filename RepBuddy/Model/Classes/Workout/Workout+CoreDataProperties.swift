//
//  Workout+CoreDataProperties.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
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
    @NSManaged public var repSet: NSSet?

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

// MARK: Generated accessors for repSet
extension Workout {

    @objc(addRepSetObject:)
    @NSManaged public func addToRepSet(_ value: RepSet)

    @objc(removeRepSetObject:)
    @NSManaged public func removeFromRepSet(_ value: RepSet)

    @objc(addRepSet:)
    @NSManaged public func addToRepSet(_ values: NSSet)

    @objc(removeRepSet:)
    @NSManaged public func removeFromRepSet(_ values: NSSet)

}

extension Workout : Identifiable {

}
