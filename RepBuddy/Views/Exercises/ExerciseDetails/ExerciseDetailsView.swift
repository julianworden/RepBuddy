//
//  ExerciseDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Charts
import SwiftUI

struct ExerciseDetailsView: View {
    @StateObject private var viewModel: ExerciseDetailsViewModel
    
    init(dataController: DataController, exercise: Exercise) {
        _viewModel = StateObject(
            wrappedValue: ExerciseDetailsViewModel(
                dataController: dataController,
                exercise: exercise
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack {
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

                        ExerciseGoalProgressView(exercise: viewModel.exercise)
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

                Spacer()

                Divider()
                    .padding(.bottom, 6)

                GroupBox {
                    HStack {
                        Text("Sets")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }

                    ExerciseSetChart(
                        repSets: viewModel.exercise.repSetArray,
                        exercise: viewModel.exercise
                    )
                    .frame(height: 200)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.setupExerciseController)
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseDetailsView(dataController: DataController.preview, exercise: Exercise.example)
        }
    }
}
