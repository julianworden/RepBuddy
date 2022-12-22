//
//  Exercise+CoreDataProperties.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/20/22.
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
    @NSManaged public var name: String?
    @NSManaged public var repSets: NSSet?
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for repSets
extension Exercise {

    @objc(addRepSetsObject:)
    @NSManaged public func addToRepSets(_ value: RepSet)

    @objc(removeRepSetsObject:)
    @NSManaged public func removeFromRepSets(_ value: RepSet)

    @objc(addRepSets:)
    @NSManaged public func addToRepSets(_ values: NSSet)

    @objc(removeRepSets:)
    @NSManaged public func removeFromRepSets(_ values: NSSet)

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

extension Exercise : Identifiable {

}
