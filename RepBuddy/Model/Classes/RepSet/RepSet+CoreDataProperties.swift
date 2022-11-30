//
//  RepSet+CoreDataProperties.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//
//

import Foundation
import CoreData


extension RepSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepSet> {
        return NSFetchRequest<RepSet>(entityName: "RepSet")
    }

    @NSManaged public var reps: Int16
    @NSManaged public var exercise: Exercise?
    @NSManaged public var workout: Workout?

}

extension RepSet : Identifiable {

}
