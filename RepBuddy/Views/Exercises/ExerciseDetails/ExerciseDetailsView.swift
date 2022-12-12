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
    
    init(exercise: Exercise) {
        _viewModel = StateObject(wrappedValue: ExerciseDetailsViewModel(exercise: exercise))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(viewModel.exercise.unwrappedName)
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.leading)

                        HStack {
                            Label(
                                "Goal: \(viewModel.exercise.goalWeight) \(viewModel.exercise.unwrappedGoalWeightUnit)",
                                systemImage: "trophy"
                            )

                            Spacer()

                            if let highestRepSetWeight = viewModel.exercise.highestRepSetWeight {
                                if highestRepSetWeight > viewModel.exercise.goalWeight {
                                    ProgressView(
                                        // Prevents runtime error for providing value higher than total value
                                        value: Double(viewModel.exercise.goalWeight),
                                        total: Double(viewModel.exercise.goalWeight)
                                    )
                                    .padding(.leading)
                                    .tint(highestRepSetWeight >= viewModel.exercise.goalWeight ? .green : .blue)
                                } else {
                                    ProgressView(
                                        value: Double(highestRepSetWeight),
                                        total: Double(viewModel.exercise.goalWeight)
                                    )
                                    .padding(.leading)
                                    .tint(highestRepSetWeight >= viewModel.exercise.goalWeight ? .green : .blue)
                                }
                            }
                        }
                        Label(
                            "\(viewModel.exercise.repSetArray.count) \(viewModel.exercise.repSetArray.count != 1 ? "Sets" : "Set")",
                            systemImage: "repeat"
                        )
                        Label(
                            "\(viewModel.exercise.workoutsArray.count) \(viewModel.exercise.workoutsArray.count != 1 ? "Workouts" : "Workout")",
                            systemImage: "dumbbell"
                        )
                    }

                    Spacer()
                }

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

                    Chart {
                        ForEach(Array(viewModel.exercise.repSetArray.enumerated()), id: \.element) { index, repSet in
                            LineMark(
                                x: .value("Set Number", index),
                                y: .value("Weight (\(viewModel.exercise.unwrappedGoalWeightUnit))", repSet.weight)
                            )


                            PointMark(
                                x: .value("Set Number", index),
                                y: .value("Weight (\(viewModel.exercise.unwrappedGoalWeightUnit))", repSet.weight)
                            )
                            .foregroundStyle(repSet.weight > viewModel.exercise.goalWeight ? .green : .accentColor)
                        }

                        RuleMark(y: .value("Goal Weight", viewModel.exercise.goalWeight))
                            .foregroundStyle(.green)
                            .lineStyle(StrokeStyle.init(lineWidth: 3, dash: [3], dashPhase: 0))
                            .annotation(position: .top, alignment: .leading) {
                                Text("Goal (\(viewModel.exercise.formattedGoalWeight))")
                                    .font(.subheadline)
                                    .foregroundStyle(.green)
                            }
                    }
                    .frame(height: 200)
                    .chartXAxis(.hidden)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseDetailsView(exercise: Exercise.example)
        }
    }
}
