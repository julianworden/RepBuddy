//
//  ExerciseSetChart.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Charts
import SwiftUI

struct ExerciseSetChart: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel

    let exercise: Exercise

    var body: some View {
        Chart {
            ForEach(Array(viewModel.fetchRepSet(in: exercise, and: viewModel.workout).enumerated()), id: \.element) { index, repSet in
                LineMark(
                    x: .value("Set Number", index),
                    y: .value("Weight (\(exercise.unwrappedGoalWeightUnit))", repSet.weight)
                )

                PointMark(
                    x: .value("Set Number", index),
                    y: .value("Weight (\(exercise.unwrappedGoalWeightUnit))", repSet.weight)
                )
                .foregroundStyle(repSet.weight > exercise.goalWeight ? .green : .accentColor)
            }

            RuleMark(y: .value("Goal Weight", exercise.goalWeight))
                .foregroundStyle(.green)
                .lineStyle(StrokeStyle.init(lineWidth: 3, dash: [3], dashPhase: 0))
                .annotation(position: .top, alignment: .leading) {
                    Text("Goal (\(exercise.formattedGoalWeight))")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                }
        }
        .chartXAxis(.hidden)
    }
}

struct ExerciseSetChart_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSetChart(
            viewModel: WorkoutDetailsViewModel(
                dataController: DataController.preview,
                workout: Workout.example
            ),
            exercise: Exercise.example
        )
    }
}
