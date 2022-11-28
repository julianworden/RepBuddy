//
//  ExerciseRepsList.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/28/22.
//

import SwiftUI

struct ExerciseRepsList: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    
    let exercise: Exercise
    
    var body: some View {
        List {
            ForEach(exercise.repSetArray, id: \.self) { repSet in
                // Only show reps for the currently displayed workout
                if repSet.workout == viewModel.workout {
                    HStack {
                        Text("\(repSet.reps) reps")
                        
                        Spacer()
                        
                        Button {
                            viewModel.editSetButtonTapped(for: repSet, in: exercise)
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.accentColor)
                        .buttonStyle(.plain)
                    }
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
        ExerciseRepsList(viewModel: WorkoutDetailsViewModel(dataController: DataController.preview, workout: Workout.example), exercise: Exercise.example)
    }
}
