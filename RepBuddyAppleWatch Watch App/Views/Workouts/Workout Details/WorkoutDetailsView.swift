//
//  WorkoutDetailsView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    @StateObject private var viewModel: WorkoutDetailsViewModel
    @StateObject private var sheetNavigator: WorkoutDetailsViewSheetNavigator

    init(dataController: DataController, workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(dataController: dataController, workout: workout))
        _sheetNavigator = StateObject(wrappedValue: WorkoutDetailsViewSheetNavigator(dataController: dataController, workout: workout))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack {
                    Text("\(viewModel.workout.unwrappedType) Workout on \(viewModel.workout.formattedNumericDateTimeOmitted)")
                        .font(.title3.bold())
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Button {
                        sheetNavigator.editWorkoutButtonTapped()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .fixedSize()
                    .foregroundColor(.blue)
                }

                Divider()

                HStack {
                    Text("Exercises")
                        .font(.title3.bold())

                    Spacer()

                    Button {
                        sheetNavigator.addExerciseButtonTapped()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .fixedSize()
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                }

                ExercisesList(viewModel: viewModel, sheetNavigator: sheetNavigator)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
        .sheet(
            isPresented: $sheetNavigator.presentSheet,
            content: { sheetNavigator.sheetView() }
        )
        .onAppear {
            viewModel.setupWorkoutController()
        }
    }
}

struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailsView(dataController: DataController.preview, workout: Workout.example)
    }
}
