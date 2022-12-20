//
//  WorkoutDetailsExerciseSetChart.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Charts
import SwiftUI

struct WorkoutDetailsExerciseSetChart: View {
    @StateObject var viewModel: WorkoutDetailsExerciseSetChartViewModel

    init(dataController: DataController, exercise: Exercise, workout: Workout) {
        _viewModel = StateObject(
            wrappedValue: WorkoutDetailsExerciseSetChartViewModel(
                dataController: dataController,
                exercise: exercise,
                workout: workout
            )
        )
    }

    var body: some View {
        Chart {
            ForEach(Array(viewModel.fetchRepSet(in: viewModel.exercise, and: viewModel.workout).enumerated()), id: \.element) { index, repSet in
                LineMark(
                    x: .value("Set Number", index),
                    y: .value("Weight (\(viewModel.exercise.unwrappedGoalWeightUnit))", repSet.weight)
                )

                PointMark(
                    x: .value("Set Number", index),
                    y: .value("Weight (\(viewModel.exercise.unwrappedGoalWeightUnit))", repSet.weight)
                )
                .symbol(repSet.weight >= viewModel.exercise.goalWeight ? .asterisk : .circle)
                .foregroundStyle(repSet.weight >= viewModel.exercise.goalWeight ? .green : .accentColor)
            }

            RuleMark(y: .value("Goal Weight", viewModel.exercise.goalWeight))
                .foregroundStyle(.green)
                .lineStyle(StrokeStyle.init(lineWidth: 3, dash: [3], dashPhase: 0))
                .annotation(position: .top, alignment: .leading) {
                    Text("Goal (\(viewModel.exercise.formattedGoalWeight))")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.setChartGoalRuleMark)
        }
        .chartXAxis(.hidden)
        .accessibilityIdentifier(AccessibilityIdentifiers.exerciseSetChart)
        .alert(
            "Error",
            isPresented: $viewModel.errorAlertIsShowing,
            actions: {
                Button("OK") { }
            },
            message: {
                Text(viewModel.errorAlertText)
            }
        )
        .onAppear(perform: viewModel.setupExerciseController)
    }
}

struct WorkoutDetailsExerciseSetChart_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsSetChart(
            viewModel: ExerciseDetailsViewModel(
                dataController: DataController.preview,
                exercise: Exercise.example
            )
        )
    }
}
