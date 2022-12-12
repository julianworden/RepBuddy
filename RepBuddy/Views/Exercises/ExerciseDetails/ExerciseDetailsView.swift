//
//  ExerciseDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Charts
import SwiftUI

struct ExerciseDetailsView: View {
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
        ScrollView {
            VStack {
                ExerciseDetailsViewHeader(viewModel: viewModel)

                Spacer()

                Divider()
                    .padding(.bottom, 6)

                GroupBox {
                    HStack {
                        Text("Sets")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }

                    ExerciseDetailsSetChart(viewModel: viewModel)
                        .frame(height: 200)
                }
            }
            .padding(.horizontal)
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
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseDetailsView(dataController: DataController.preview, exercise: Exercise.example)
        }
    }
}
