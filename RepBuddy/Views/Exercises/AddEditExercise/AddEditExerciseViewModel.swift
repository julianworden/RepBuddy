//
//  AddEditExerciseViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

class AddEditExerciseViewModel: ObservableObject {
    @Published var exerciseName = ""
    
    @Published var exerciseWeightGoal = 20
    @Published var exerciseWeightGoalUnit = WeightUnit.pounds

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""
    
    @Published var dismissView = false

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing.toggle()

            default:
                errorAlertText = "Invalid ViewState"
                errorAlertIsShowing.toggle()
            }
        }
    }
    
    let dataController: DataController

    var formIsCompleted: Bool {
        !exerciseName.isReallyEmpty
    }
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func saveExercise() {
        guard formIsCompleted else {
            viewState = .error(message: FormValidationError.emptyFields.localizedDescription)
            return
        }

        let newExercise = Exercise(context: dataController.moc)
        newExercise.id = UUID()
        newExercise.name = exerciseName
        newExercise.goalWeight = Int16(exerciseWeightGoal)
        newExercise.goalWeightUnit = exerciseWeightGoalUnit.rawValue

        do {
            try dataController.moc.save()
        } catch {
            print("Failed to save new exercise.")
        }
        
        dismissView.toggle()
    }
}
