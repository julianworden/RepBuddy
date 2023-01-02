//
//  ExerciseRepsInWorkoutDetailsList.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/6/22.
//

import SwiftUI

struct ExerciseRepsInWorkoutDetailsList: View {
    @ObservedObject var viewModel: ExerciseRepsInWorkoutDetailsViewModel

    var body: some View {
        List(viewModel.repSets) { repSet in
            Button(repSet.formattedDescription) {
                viewModel.repSetButtonTapped(repSet)
            }
        }
    }
}

struct RepSetsList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRepsInWorkoutDetailsList(viewModel: ExerciseRepsInWorkoutDetailsViewModel(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example, repSets: []))
    }
}
