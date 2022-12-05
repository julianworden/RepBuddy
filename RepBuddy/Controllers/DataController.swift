//
//  Persistence.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData

struct DataController {
    static let shared = DataController()

    static var preview: DataController = {
        let result = DataController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newExercise = Exercise(context: viewContext)
            newExercise.name = "Shoulder Press"
            newExercise.goalWeight = 100
            newExercise.goalWeightUnit = "Pounds"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer
    
    var moc: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "RepBuddy")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func save() throws {
        guard moc.hasChanges else { print("MOC has no changes, save not performed."); return }

        try moc.save()
    }
}
