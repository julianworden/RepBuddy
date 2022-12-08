//
//  AddExerciseToWorkoutViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import Foundation

class AddExerciseToWorkoutViewModel: ObservableObject {
    @Published var allUserExercises = [Exercise]()
    
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
    let workout: Workout
    
    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
    }
    
    func fetchAllUserExercises() {
        let fetchRequest = Exercise.fetchRequest()
        
        do {
            let allUserExercises = try dataController.moc.fetch(fetchRequest)
            self.allUserExercises = allUserExercises
            
            allUserExercises.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
    
    func exerciseSelected(_ exercise: Exercise) {
        workout.addToExercises(exercise)
        save()
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
