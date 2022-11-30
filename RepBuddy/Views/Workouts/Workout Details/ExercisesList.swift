//
//  ExercisesList.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Charts
import SwiftUI

struct ExercisesList: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    @ObservedObject var sheetNavigator: WorkoutDetailsViewSheetNavigator
    
    var body: some View {
        ForEach(viewModel.workoutExercises, id: \.self) { exercise in
            HStack {
                Text(exercise.unwrappedName)
                    .font(.title2)

                Spacer()

                Button(role: .destructive) {
                    viewModel.deleteExercise(exercise)
                } label: {
                    Image(systemName: "trash")
                }

                Button("Add Set") {
                    viewModel.setupExerciseController(with: exercise)
                    sheetNavigator.addSetButtonTapped(for: exercise)
                }
            }
            .onAppear {
                print(exercise.repSetArray.count)
            }
            .buttonStyle(.bordered)

            ExerciseSetChart(viewModel: viewModel, exercise: exercise)
                .padding(.bottom, 35)
        }
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(
            viewModel: WorkoutDetailsViewModel(
                dataController: DataController.preview,
                workout: Workout.example
            ),
            sheetNavigator: WorkoutDetailsViewSheetNavigator(
                dataController: DataController.preview,
                workout: Workout.example
            )
        )
    }
}
