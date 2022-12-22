//
//  RepSet+CoreDataProperties.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/20/22.
//
//

import Foundation
import CoreData


extension RepSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepSet> {
        return NSFetchRequest<RepSet>(entityName: "RepSet")
    }

    @NSManaged public var date: Date?
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var exercise: Exercise?
    @NSManaged public var workout: Workout?

}

extension RepSet : Identifiable {

}
