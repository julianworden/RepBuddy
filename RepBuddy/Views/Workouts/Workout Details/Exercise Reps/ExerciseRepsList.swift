//
//  ExerciseRepsList.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/28/22.
//

import SwiftUI

struct ExerciseRepsList: View {
    @ObservedObject var viewModel: ExerciseRepsViewModel

    let exercise: Exercise

    var body: some View {
        List {
            ForEach(exercise.repSetArray) { repSet in
                if repSet.workout == viewModel.workout {
                    Button {
                        viewModel.editRepSetSheetIsShowing.toggle()
                    } label: {
                        Text(repSet.formattedDescription)
                    }
                    .tint(.primary)
                    .sheet(isPresented: $viewModel.editRepSetSheetIsShowing) {
                        AddEditRepSetView(
                            dataController: viewModel.dataController,
                            workout: viewModel.workout,
                            exercise: exercise,
                            repSetToEdit: repSet
                        )
                    }
                }
            }
            .onDelete { indexSet in
                viewModel.deleteRepSet(in: exercise, at: indexSet)
            }
        }
    }
}

struct ExerciseRepsList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRepsList(
            viewModel: ExerciseRepsViewModel(
                dataController: DataController.preview,
                workout: Workout.example,
                exercise: Exercise.example,
                repSets: []
            ),
            exercise: Exercise.example
        )
    }
}
