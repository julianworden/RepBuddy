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
            ForEach(exercise.repSetArray) { repSet in
                LineMark(
                    x: .value("Set Number", repSet.number),
                    y: .value("Weight (\(exercise.unwrappedGoalWeightUnit))", repSet.weight)
                )

                PointMark(
                    x: .value("Set Number", repSet.number),
                    y: .value("Weight (\(exercise.unwrappedGoalWeightUnit))", repSet.weight)
                )
                .annotation(spacing: 5) {
                    Text("\(repSet.weight)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            RuleMark(y: .value("Goal Weight", exercise.goalWeight))
                .foregroundStyle(.green)
//                .opacity(0.5)
                .lineStyle(StrokeStyle.init(lineWidth: 3, dash: [3], dashPhase: 0))
                .annotation(position: .top, alignment: .leading) {
                    Text("Goal (\(exercise.formattedGoalWeight))")
                        .font(.caption)
                        .foregroundStyle(.green)
//                        .opacity(0.5)
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
