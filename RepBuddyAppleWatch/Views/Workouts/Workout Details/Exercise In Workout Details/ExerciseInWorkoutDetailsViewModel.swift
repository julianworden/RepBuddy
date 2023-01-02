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

    var exerciseController: NSFetchedResultsController<Exercise>!
    
    init(dataController: DataController, exercise: Exercise, workout: Workout) {
        self.exercise = exercise
        self.workout = workout
        self.dataController = dataController
        super.init()
        
        fetchRepSets(in: exercise, and: workout)
    }
    
    func fetchRepSets(in exercise: Exercise, and workout: Workout) {
        do {
            exerciseRepSets = try dataController.getRepSets(in: exercise, and: workout)
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
        do {
            try dataController.deleteExerciseInWorkout(delete: exercise, in: workout)
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
