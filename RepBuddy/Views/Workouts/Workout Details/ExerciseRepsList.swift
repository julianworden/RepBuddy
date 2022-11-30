//
//  ExerciseRepsList.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/28/22.
//

import SwiftUI

struct ExerciseRepsList: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    @ObservedObject var sheetNavigator: WorkoutDetailsViewSheetNavigator
    
    let exercise: Exercise
    
    var body: some View {
        List {
            ForEach(exercise.repSetArray) { repSet in
                HStack {
                    Text("\(repSet.reps) reps")

                    Spacer()

                    Button {
                        sheetNavigator.editSetButtonTapped(for: repSet, in: exercise)
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .foregroundColor(.accentColor)
                    .buttonStyle(.plain)
                }
            }
            .onDelete { indexSet in
                viewModel.deleteRepSet(in: exercise, at: indexSet)
            }
        }
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
        .listStyle(.plain)
        .padding(.trailing)
    }
}

struct ExerciseRepsList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRepsList(
            viewModel: WorkoutDetailsViewModel(
                dataController: DataController.preview,
                workout: Workout.example),
            sheetNavigator: WorkoutDetailsViewSheetNavigator(
                dataController: DataController.preview,
                workout: Workout.example
            ),
            exercise: Exercise.example
        )
    }
}
