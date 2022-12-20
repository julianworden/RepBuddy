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

        if CommandLine.arguments.contains("testing") {
            deleteAllData()
        }
    }

    func generateSampleData() throws {
        for exerciseCounter in 1...5 {
            let exercise = Exercise(context: moc)
            exercise.name = "Exercise \(exerciseCounter)"
            exercise.goalWeightUnit = WeightUnit.allCases.randomElement()!.rawValue
            exercise.goalWeight = Int16.random(in: 20...100)

            for _ in 1...10 {
                let workout = Workout(context: moc)
                workout.type = WorkoutType.allCases.randomElement()!.rawValue
                workout.date = Date.now
                workout.addToExercises(exercise)

                for _ in 1...3 {
                    let repSet = RepSet(context: moc)
                    repSet.reps = Int16.random(in: 1...12)
                    repSet.weight = Int16.random(in: 20...100)
                    repSet.date = Date.now
                    repSet.exercise = exercise
                    repSet.workout = workout
                }
            }
        }

        try save()
    }

    func deleteAllData() {
        let exercisesBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Exercise.fetchRequest())
        let workoutsBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Workout.fetchRequest())
        let repSetsBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: RepSet.fetchRequest())

        do {
            try moc.execute(exercisesBatchDeleteRequest)
            try moc.execute(workoutsBatchDeleteRequest)
            try moc.execute(repSetsBatchDeleteRequest)
        } catch {
            print(error)
        }
    }

    func save() throws {
        guard moc.hasChanges else { print("MOC has no changes, save not performed."); return }

        try moc.save()
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        do {
            return try moc.count(for: fetchRequest)
        } catch {
            print(error)
            return 0
        }
    }
}
