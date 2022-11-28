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
    
    let dataController: DataController
    
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
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func saveExercise() {
        let newExercise = Exercise(context: dataController.moc)
        newExercise.id = UUID()
        newExercise.name = exerciseName
        newExercise.notes = exerciseNotes
        newExercise.goalWeight = Int16(exerciseWeightGoal)
        newExercise.goalWeightUnit = exerciseWeightGoalUnit.rawValue
        newExercise.muscles = musclesArray
        
        do {
            try dataController.moc.save()
        } catch {
            print("Failed to save new exercise.")
        }
    }
}