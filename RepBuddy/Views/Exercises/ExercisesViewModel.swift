//
//  HomeViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData
import Foundation

class ExercisesViewModel: NSObject, ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var addEditExerciseSheetIsShowing = false

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
    var exercisesController: NSFetchedResultsController<Exercise>!
    
    init(dataController: DataController) {
        self.dataController = dataController
        super.init()
        
        setupExercisesController()
        getExercises()
    }
    
    func setupExercisesController() {
        let exercisesFetchRequest = NSFetchRequest<Exercise>(entityName: CoreDataConstants.Exercise)
        exercisesFetchRequest.sortDescriptors = []
        
        exercisesController = NSFetchedResultsController(
            fetchRequest: exercisesFetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        exercisesController.delegate = self
    }
    
    func getExercises() {
        do {
            try exercisesController.performFetch()
            exercises = exercisesController.fetchedObjects ?? []

            exercises.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func deleteExercise(at indexSet: IndexSet) {
        for index in indexSet {
            dataController.moc.delete(exercises[index])
        }
        
        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
