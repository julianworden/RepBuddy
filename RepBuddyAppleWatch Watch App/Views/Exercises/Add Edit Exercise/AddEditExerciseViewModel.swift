//
//  AddEditExerciseViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

class AddEditExerciseViewModel: ObservableObject {
    @Published var exerciseName = ""
    @Published var exerciseNotes = ""
    
    @Published var exerciseWeightGoal = 20
    @Published var exerciseWeightGoalUnit = WeightUnit.pounds
    
    @Published var calvesIsSelected = false
    @Published var bicepsIsSelected = false
    @Published var tricepsIsSelected = false
    @Published var pectoralisIsSelected = false
    @Published var shouldersIsSelected = false
    @Published var deltoidIsSelected = false
    @Published var trapeziusIsSelected = false
    @Published var abdomenIsSelected = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

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

    @Published var dismissView = false

    @Published var deleteExerciseAlertIsShowing = false

    var exerciseToEdit: Exercise?
    
    let dataController: DataController

    var formIsCompleted: Bool {
        !exerciseName.isReallyEmpty
    }
    
    var musclesArray: [String] {
        var array = [String]()
        
        if calvesIsSelected {
            array.append(Muscle.calves.rawValue)
        }
        if bicepsIsSelected {
            array.append(Muscle.biceps.rawValue)
        }
        if tricepsIsSelected {
            array.append(Muscle.biceps.rawValue)
        }
        if pectoralisIsSelected {
            array.append(Muscle.pectoralis.rawValue)
        }
        if shouldersIsSelected {
            array.append(Muscle.shoulders.rawValue)
        }
        if deltoidIsSelected {
            array.append(Muscle.deltoid.rawValue)
        }
        if trapeziusIsSelected {
            array.append(Muscle.trapezius.rawValue)
        }
        if abdomenIsSelected {
            array.append(Muscle.abdomen.rawValue)
        }
        
        return array
    }
    
    init(dataController: DataController, exerciseToEdit: Exercise? = nil) {
        self.dataController = dataController
        if let exerciseToEdit {
            self.exerciseToEdit = exerciseToEdit
            self.exerciseName = exerciseToEdit.unwrappedName
            self.exerciseWeightGoal = Int(exerciseToEdit.goalWeight)
            self.exerciseWeightGoalUnit = WeightUnit(rawValue: exerciseToEdit.unwrappedGoalWeightUnit)!
        }
    }
    
    func saveExercise() {
        guard formIsCompleted else {
            viewState = .error(message: FormValidationError.emptyFields.localizedDescription)
            return
        }

        let newExercise = Exercise(context: dataController.moc)
        newExercise.id = UUID()
        newExercise.name = exerciseName
        newExercise.notes = exerciseNotes
        newExercise.goalWeight = Int16(exerciseWeightGoal)
        newExercise.goalWeightUnit = exerciseWeightGoalUnit.rawValue
        newExercise.muscles = musclesArray

        save()

        dismissView.toggle()
    }

    func deleteExercise() {
        guard let exerciseToEdit else { return }

        dataController.moc.delete(exerciseToEdit)
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
