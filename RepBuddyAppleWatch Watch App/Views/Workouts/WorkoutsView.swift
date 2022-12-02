//
//  ContentView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import SwiftUI

struct WorkoutsView: View {
    @StateObject private var viewModel: WorkoutsViewModel

    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: WorkoutsViewModel(dataController: dataController))
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.workouts) { workout in
                        NavigationLink {
                            WorkoutDetailsView(dataController: viewModel.dataController, workout: workout)
                        } label: {
                            Text("\(workout.unwrappedType) workout on \(workout.formattedNumericDateTimeOmitted)")
                        }
                    }
                }

                Spacer()

                Button("Add Workout") {
                    viewModel.addWorkoutButtonTapped()
                }
                .buttonStyle(.plain)
                .foregroundColor(.blue)
            }
            .navigationTitle("Rep Buddy")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.addWorkoutSheetIsShowing) {
                AddEditWorkoutView(dataController: viewModel.dataController)
            }
        }
        .onAppear(perform: viewModel.setupExercisesController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutsView(dataController: DataController.preview)
        }
    }
}
