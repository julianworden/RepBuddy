//
//  WorkoutDetailsView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: WorkoutDetailsViewModel
    @StateObject private var sheetNavigator: WorkoutDetailsViewSheetNavigator
    
    init(dataController: DataController, workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(dataController: dataController, workout: workout))
        _sheetNavigator = StateObject(wrappedValue: WorkoutDetailsViewSheetNavigator(dataController: dataController, workout: workout))
    }
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .displayingView:
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
                            .buttonStyle(.plain)
                            .foregroundColor(.blue)
                        }
                        
                        Divider()

                        if viewModel.workoutExercises.isEmpty {
                            VStack {
                                NoDataFoundView(message: "No exercises selected.")

                                Button("Add Exercise") {
                                    sheetNavigator.addExerciseButtonTapped()
                                }
                                .tint(.blue)
                            }
                        } else {
                            VStack {
                                HStack {
                                    Text("Exercises")
                                        .font(.title3.bold())

                                    Spacer()
                                }
                                
                                ExercisesList(viewModel: viewModel, sheetNavigator: sheetNavigator)


                                Button("Add Exercise") {
                                    sheetNavigator.addExerciseButtonTapped()
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
            case .dataDeleted, .error:
                EmptyView()
                
            default:
                NoDataFoundView(message: "Invalid ViewState")
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(
            isPresented: $sheetNavigator.presentSheet,
            content: { sheetNavigator.sheetView() }
        )
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
        .onAppear(perform: viewModel.setupWorkoutController)
        .onChange(of: viewModel.dismissView) { _ in
            dismiss()
        }
    }
}

struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailsView(dataController: DataController.preview, workout: Workout.example)
    }
}
