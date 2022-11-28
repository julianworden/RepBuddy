//
//  Exercise+CoreDataProperties.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var goalWeight: Int16
    @NSManaged public var goalWeightUnit: String?
    @NSManaged public var id: UUID?
    @NSManaged public var muscles: [String]?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var workouts: NSSet?
    @NSManaged public var repSet: NSSet?

}

// MARK: Generated accessors for workouts
extension Exercise {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}

// MARK: Generated accessors for repSet
extension Exercise {

    @objc(addRepSetObject:)
    @NSManaged public func addToRepSet(_ value: RepSet)

    @objc(removeRepSetObject:)
    @NSManaged public func removeFromRepSet(_ value: RepSet)

    @objc(addRepSet:)
    @NSManaged public func addToRepSet(_ values: NSSet)

    @objc(removeRepSet:)
    @NSManaged public func removeFromRepSet(_ values: NSSet)

}

extension Exercise : Identifiable {

}
