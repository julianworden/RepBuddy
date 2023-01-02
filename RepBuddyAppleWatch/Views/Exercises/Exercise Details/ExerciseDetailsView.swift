//
//  ExerciseDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct ExerciseDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: ExerciseDetailsViewModel
    
    init(dataController: DataController, exercise: Exercise) {
        _viewModel = StateObject(wrappedValue: ExerciseDetailsViewModel(dataController: dataController, exercise: exercise))
    }
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .displayingView:
                ScrollView {
                    VStack(spacing: 10) {
                        HStack {
                            Text(viewModel.exercise.unwrappedName)
                                .font(.title3.bold())
                                .multilineTextAlignment(.leading)

                            Spacer()

                            Button {
                                viewModel.addEditExerciseSheetIsShowing.toggle()
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .fixedSize()
                            .buttonStyle(.plain)
                            .foregroundColor(.blue)
                        }

                        NavigationLink {
                            AllExerciseRepSetsView(
                                dataController: viewModel.dataController,
                                exercise: viewModel.exercise
                            )
                        } label: {
                            HStack {
                                ExerciseDetailsSetChart(viewModel: viewModel)
                                    // Without this, a line on the chart will go off the leading edge of the screen
                                    .padding(.leading, 5)
                                    .accessibilityIdentifier(AccessibilityIdentifiers.exerciseSetChart)

                                Image(systemName: "chevron.right")
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
        ExerciseDetailsView(dataController: DataController.preview, exercise: Exercise.example)
    }
}
