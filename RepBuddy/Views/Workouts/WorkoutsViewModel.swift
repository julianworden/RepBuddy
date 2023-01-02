//
//  WorkoutsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData
import Foundation

final class WorkoutsViewModel: NSObject, ObservableObject {
    @Published var workouts = [Workout]()
    @Published var addEditWorkoutSheetIsShowing = false

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
    
    let dataController: DataController
    var workoutsController: NSFetchedResultsController<Workout>!
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func setupWorkoutsController() {
        let workoutsFetchRequest = NSFetchRequest<Workout>(entityName: CoreDataConstants.Workout)
        workoutsFetchRequest.sortDescriptors = []
        
        workoutsController = NSFetchedResultsController(
            fetchRequest: workoutsFetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        workoutsController.delegate = self
    }
    
    func getWorkouts() {
        do {
            try workoutsController.performFetch()
            workouts = workoutsController.fetchedObjects?.sorted { $0.unwrappedDate > $1.unwrappedDate } ?? []
            workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func deleteWorkout(at indexSet: IndexSet) {
        do {
            for index in indexSet {
                dataController.deleteWorkout(workouts[index])
            }

            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
