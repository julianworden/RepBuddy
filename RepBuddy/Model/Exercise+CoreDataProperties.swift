//
//  Exercise+CoreDataProperties.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var muscles: [String]?
    @NSManaged public var goalWeight: Int16
    @NSManaged public var goalWeightUnit: String?
    @NSManaged public var notes: String?

    var unwrappedName: String {
        name ?? "Unknown Name"
    }
    
    var unwrappedMuscles: [String] {
        muscles ?? []
    }
    
    var unwrappedGoalWeightUnit: String {
        goalWeightUnit ?? "Pounds"
    }
}

extension Exercise : Identifiable {

}
