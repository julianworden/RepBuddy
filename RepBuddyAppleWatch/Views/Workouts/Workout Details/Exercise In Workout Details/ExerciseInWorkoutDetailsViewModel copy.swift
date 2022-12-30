//
//  ExerciseInWorkoutDetailsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import CoreData
import Foundation

class ExerciseInWorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var exercise: Exercise
    @Published var exerciseRepSets = [RepSet]()
    let workout: Workout
    let dataController: DataController
    
    @Published var addEditRepSetSheetIsShowing = false
    @Published var deleteExerciseAlertIsShowing = false
    
    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""
    
    @Published var viewState = ViewState.dataLoading {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing.toggle()
                
            default:
                if viewState != .dataLoaded && viewState != .dataNotFound {
                    errorAlertText = "Invalid ViewState"
                    errorAlertIsShowing.toggle()
                }
            }
        }
    }
    
    var repSetToEdit: RepSet?
    
    var exerciseController: NSFetchedResultsController<Exercise>!
    
    init(dataController: DataController, exercise: Exercise, workout: Workout) {
        self.exercise = exercise
        self.workout = workout
        self.dataController = dataController
        super.init()
        
        fetchRepSet(in: exercise, and: workout)
    }
    
    func fetchRepSet(in exercise: Exercise, and workout: Workout) {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchedRepSets = try dataController.moc.fetch(fetchRequest)
            exerciseRepSets = fetchedRepSets
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func setupExerciseController() {
        let fetchRequest = Exercise.fetchRequest()
        let exercisePredicate = NSPredicate(format: "%K == %@", "id", exercise.unwrappedId as CVarArg)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = exercisePredicate
        
        exerciseController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        exerciseController.delegate = self
        
        do {
            try exerciseController.performFetch()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func deleteExercise() {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let exerciseRepsInWorkout = try dataController.moc.fetch(fetchRequest)
            
            for repSet in exerciseRepsInWorkout {
                exercise.removeFromRepSets(repSet)
            }
            
            workout.removeFromExercises(exercise)
            
            save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func save() {
        guard dataController.moc.hasChanges else { print("moc has no changes, save not performed"); return }
        
        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
