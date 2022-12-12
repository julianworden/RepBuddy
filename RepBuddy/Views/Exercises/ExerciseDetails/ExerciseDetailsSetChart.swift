//
//  ExerciseDetailsSetChart.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Charts
import SwiftUI

struct ExerciseDetailsSetChart: View {
    @ObservedObject var viewModel: ExerciseDetailsViewModel

    var body: some View {
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
        .chartXAxis(.hidden)
    }
}

struct ExerciseDetailsSetChart_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsSetChart(
            viewModel: ExerciseDetailsViewModel(
                dataController: DataController.preview,
                exercise: Exercise.example
            )
        )
    }
}
