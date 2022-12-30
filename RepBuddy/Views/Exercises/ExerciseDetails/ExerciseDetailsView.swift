//
//  ExerciseDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Charts
import SwiftUI

struct ExerciseDetailsView: View {
    @Environment(\.dismiss) var dismiss

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
        ZStack {
            switch viewModel.viewState {
            case .displayingView:
                ScrollView {
                    VStack {
                        ExerciseDetailsViewHeader(viewModel: viewModel)

                        Divider()
                            .padding(.bottom, 6)

                        if !viewModel.exercise.repSetsArray.isEmpty {
                            GroupBox {
                                ExerciseDetailsGoalProgressView(viewModel: viewModel)
                                    .padding(.top, 1)
                            } label: {
                                Text("Your Progress")
                                    .font(.title2)
                            }
                            .accessibilityIdentifier(AccessibilityIdentifiers.exerciseDetailsYourProgressGroupBox)
                        }

                        NavigationLink {
                            AllExerciseRepSetsView(
                                dataController: viewModel.dataController,
                                exercise: viewModel.exercise
                            )
                        } label: {
                            GroupBox {
                                HStack(spacing: 10) {
                                    ExerciseDetailsSetChart(viewModel: viewModel)
                                        .frame(height: 200)

                                    Image(systemName: "chevron.right")
                                }
                            } label: {
                                Text("Sets")
                                    .font(.title2)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)

            case .error, .dataDeleted:
                EmptyView()

            default:
                NoDataFoundView(message: "Unknown ViewState")
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                viewModel.addEditExerciseSheetIsShowing.toggle()
            }
        }
        .sheet(isPresented: $viewModel.addEditExerciseSheetIsShowing) {
            AddEditExerciseView(
                dataController: viewModel.dataController,
                exerciseToEdit: viewModel.exercise
            )
        }
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
        .onChange(of: viewModel.dismissView) { _ in
            dismiss()
        }
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseDetailsView(dataController: DataController.preview, exercise: Exercise.example)
        }
    }
}
