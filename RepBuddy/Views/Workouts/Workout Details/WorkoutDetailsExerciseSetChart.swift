//
//  WorkoutDetailsExerciseSetChart.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Charts
import SwiftUI

struct WorkoutDetailsExerciseSetChart: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel

    let repSets: [RepSet]
    let exercise: Exercise

    var body: some View {
        Chart {
            ForEach(Array(repSets.enumerated()), id: \.element) { index, repSet in
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
