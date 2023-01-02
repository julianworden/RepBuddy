//
//  AddExerciseToWorkoutViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import CoreData
import Foundation

class AddExerciseToWorkoutViewModel: ObservableObject {
    @Published var allUserExercises = [Exercise]()
    @Published var dismissView = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.dataLoading {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing = true

            default:
                if viewState != .dataLoaded && viewState != .dataNotFound {
                    errorAlertText = "Invalid ViewState"
                    errorAlertIsShowing = true
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

    func exerciseIsSelectable(_ exercise: Exercise) -> Bool {
        return !workout.exercisesArray.contains(exercise)
    }

    func fetchAllUserExercises() {
        do {
            let allUserExercises = try dataController.getAllExercises()
            self.allUserExercises = allUserExercises.sorted { $0.unwrappedName < $1.unwrappedName }
            self.allUserExercises.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func exerciseSelected(_ exercise: Exercise) {
        do {
            workout.addToExercises(exercise)
            try dataController.save()
            dismissView = true
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
