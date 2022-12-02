//
//  ExerciseDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct ExerciseDetailsView: View {
    @StateObject private var viewModel: ExerciseDetailsViewModel
    
    init(exercise: Exercise) {
        _viewModel = StateObject(wrappedValue: ExerciseDetailsViewModel(exercise: exercise))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.exercise.unwrappedName)
            Text(viewModel.exercise.formattedMuscles)
            Text("\(viewModel.exercise.goalWeight) \(viewModel.exercise.unwrappedGoalWeightUnit)")
            Text("Utilized in: \(viewModel.exercise.workoutNamesArray.joined(separator: ", "))")
        }
        .navigationTitle(viewModel.exercise.unwrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsView(exercise: Exercise.example)
    }
}
