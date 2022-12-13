//
//  ExerciseDetailsViewHeader.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/12/22.
//

import SwiftUI

struct ExerciseDetailsViewHeader: View {
    @ObservedObject var viewModel: ExerciseDetailsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewModel.exercise.unwrappedName)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.leading)

            HStack {
                Label(
                    "Goal: \(viewModel.exercise.formattedGoalWeight)",
                    systemImage: "trophy"
                )

                Spacer()

                ExerciseDetailsGoalProgressView(viewModel: viewModel)
                    .padding(.leading)
            }
            Label(
                viewModel.exercise.repSetsCountDescription,
                systemImage: "repeat"
            )
            Label(
                viewModel.exercise.workoutsCountDescription,
                systemImage: "dumbbell"
            )
        }
    }
}

struct ExerciseDetailsViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsViewHeader(
            viewModel: ExerciseDetailsViewModel(
                dataController: DataController.preview,
                exercise: Exercise.example
            )
        )
    }
}