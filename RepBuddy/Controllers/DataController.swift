//
//  Persistence.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData

struct DataController: Equatable {
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

    func save() throws {
        guard moc.hasChanges else { print("MOC has no changes, save not performed."); return }

        try moc.save()
    }

    // MARK: - Testing Methods

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

    /// Used for Unit Testing to make it easier to add RepSets to an Exercise.
    ///
    /// Adds 5 RepSet objects to a workout. The Exercise in the exercise property must already belong to the Workout in the workout property before this method is called.
    /// - Parameter exercise: The Exercise that the RepSets will belong to.
    /// - Parameter workout: The Workout that the RepSets will belong to.
    /// - Returns: An updated Exercise object that now has the RepSets that have been added to it.
    func addTestRepSetsToExerciseAndWorkout(exercise: Exercise, workout: Workout) -> (Exercise, Workout) {
        for _ in 1...5 {
            let repSet = RepSet(context: moc)
            repSet.reps = 12
            repSet.weight = Int16.random(in: 50...100)
            repSet.workout = workout
            repSet.exercise = exercise
        }

        return (exercise, workout)
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

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        do {
            return try moc.count(for: fetchRequest)
        } catch {
            print(error)
            return 0
        }
    }

    // MARK: - Exercise Methods

    /// Used for Unit Testing to make it easier to fetch Exercises created in
    /// generateSampleData().
    /// - Returns: All exercises in the container's NSManagedObjectContext.
    func getAllExercises() throws -> [Exercise] {
        let fetchRequest = Exercise.fetchRequest()
        return try moc.fetch(fetchRequest)
    }

    /// Used for Unit Testing to make it easier to verify that an Exercise was saved or
    /// updated correctly.
    /// - Parameter name: The name of the Exercise for which the search is occuring.
    /// - Returns: The exercise that has the given name. If no exercise with the given name exists,
    /// this value will be nil.
    func getExercise(with name: String) throws -> Exercise? {
        let fetchRequest = Exercise.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.predicate = predicate

        let fetchedExercises = try moc.fetch(fetchRequest)
        return fetchedExercises.first ?? nil
    }

    func createExercise(name: String, goalWeight: Int, goalWeightUnit: WeightUnit) -> Exercise {
        let exercise = Exercise(context: moc)
        exercise.id = UUID()
        exercise.name = name
        exercise.goalWeight = Int16(goalWeight)
        exercise.goalWeightUnit = goalWeightUnit.rawValue
        return exercise
    }

    func updateExercise(
        exerciseToEdit: Exercise,
        name: String,
        goalWeight: Int,
        goalWeightUnit: String
    ) -> Exercise {
        let updatedExercise = exerciseToEdit
        updatedExercise.name = name
        updatedExercise.goalWeight = Int16(goalWeight)
        updatedExercise.goalWeightUnit = goalWeightUnit
        return updatedExercise
    }

    func deleteExercise(_ exercise: Exercise) {
        moc.delete(exercise)
    }

    // MARK: - Workout Methods

    func getAllWorkouts() throws -> [Workout] {
        let fetchRequest = Workout.fetchRequest()

        return try moc.fetch(fetchRequest)
    }

    func createWorkout(type: WorkoutType, date: Date) -> Workout {
        let workout = Workout(context: moc)
        workout.id = UUID()
        workout.type = type.rawValue
        workout.date = date
        return workout
    }

    func updateWorkout(
        workoutToEdit: Workout,
        type: WorkoutType,
        date: Date
    ) -> Workout {
        let updatedWorkout = workoutToEdit
        updatedWorkout.type = type.rawValue
        updatedWorkout.date = date
        updatedWorkout.repSetsArray.forEach { repSet in
            repSet.date = createUpdatedRepSetDate(for: repSet, with: date)
        }

        return updatedWorkout
    }

    func deleteWorkout(_ workout: Workout) {
        moc.delete(workout)
    }

    /// Removes a given Exercise from a given Workout.
    ///
    /// This method also performs a fetch request to fetch all of the RepSets that belong to both the given Exercise and the given
    /// Workout. These RepSets are removed from the Exercise, and then the Exercise is removed from the Workout.
    /// - Parameters:
    ///   - exercise: The Exercise to be deleted from the Workout provided in the workout parameter.
    ///   - workout: The Workout that will be having one of its Exercises deleted.
    func deleteExerciseInWorkout(delete exercise: Exercise, in workout: Workout) throws {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        fetchRequest.predicate = compoundPredicate
        let exerciseRepsInWorkout = try moc.fetch(fetchRequest)

        for repSet in exerciseRepsInWorkout {
            deleteRepSet(repSet)
        }

        workout.removeFromExercises(exercise)
    }

    // MARK: - RepSet Methods

    func createRepSet(
        date: Date,
        reps: Int,
        weight: Int,
        exercise: Exercise,
        workout: Workout
    ) -> RepSet {
        let repSet = RepSet(context: moc)
        repSet.id = UUID()
        repSet.date = date
        repSet.reps = Int16(reps)
        repSet.weight = Int16(weight)
        repSet.exercise = exercise
        repSet.workout = workout
        return repSet
    }

    func updateRepSet(
        repSetToEdit: RepSet,
        date: Date,
        reps: Int,
        weight: Int
    ) -> RepSet {
        let updatedRepSet = repSetToEdit
        updatedRepSet.date = date
        updatedRepSet.reps = Int16(reps)
        updatedRepSet.weight = Int16(weight)
        return updatedRepSet
    }

    func deleteRepSet(_ repSet: RepSet) {
        moc.delete(repSet)
    }

    func getRepSets(in exercise: Exercise, and workout: Workout) throws -> [RepSet] {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        return try moc.fetch(fetchRequest)
    }

    /// Updates the date property for a RepSet object. Called on each RepSet object in a Workout's repSetsArray property
    /// whenever a Workout update takes place. This is done so that, if a Workout's date changes, its RepSets'
    /// date properties change with it.
    ///
    /// When this method is run, the only part of the given RepSet that is modified is its year, month, and day. Its hour, minute
    /// and hour info is retained. This is done so that the order of the RepSets within the Workout is preserved, and it works
    /// because the Workout time is not modifiable.
    /// - Parameter repSet: The RepSet to be edited.
    /// - Parameter newWorkoutDate: The new date for the updated Workout.
    /// - Returns: The updated Date for the given RepSet.
    func createUpdatedRepSetDate(for repSet: RepSet, with newWorkoutDate: Date) -> Date? {
        let updatedRepSetDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: newWorkoutDate
        )
        let repSetDateComponents = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: repSet.unwrappedDate
        )
        let fullUpdatedRepSetDateComponents = DateComponents(
            year: updatedRepSetDateComponents.year,
            month: updatedRepSetDateComponents.month,
            day: updatedRepSetDateComponents.day,
            hour: repSetDateComponents.hour,
            minute: repSetDateComponents.minute,
            second: repSetDateComponents.second
        )
        let fullUpdatedRepSetDate = Calendar.current.date(from: fullUpdatedRepSetDateComponents)

        return fullUpdatedRepSetDate
    }
}
