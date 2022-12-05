//
//  ExerciseDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct ExerciseDetailsView: View {
    @StateObject private var viewModel: ExerciseDetailsViewModel
    
    init(dataController: DataController, exercise: Exercise) {
        _viewModel = StateObject(wrappedValue: ExerciseDetailsViewModel(dataController: dataController, exercise: exercise))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.exercise.unwrappedName)
            Text(viewModel.exercise.formattedMuscles)
            Text("\(viewModel.exercise.goalWeight) \(viewModel.exercise.unwrappedGoalWeightUnit)")
            Text("Utilized in: \(viewModel.exercise.workoutNamesArray.joined(separator: ", "))")
            Button("Edit") {
                viewModel.addEditExerciseSheetIsShowing.toggle()
            }
        }
        .navigationTitle(viewModel.exercise.unwrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.addEditExerciseSheetIsShowing) {
            AddEditExerciseView(dataController: viewModel.dataController, exerciseToEdit: viewModel.exercise)
        }
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsView(dataController: DataController.preview, exercise: Exercise.example)
    }
}
