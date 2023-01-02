//
//  ExerciseDetailsViewUITests.swift
//  RepBuddyUITests
//
//  Created by Julian Worden on 12/19/22.
//

import XCTest

final class ExerciseDetailsViewUITests: XCTestCase {
    var app: XCUIApplication!
    var helpers: UITestHelpers!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()

        helpers = UITestHelpers(app: app)
    }

    override func tearDownWithError() throws { }

    func test_OnCreateExercise_CorrectValuesAreDisplayed() {
        helpers.createTestExerciseWithDefaultValues()
        helpers.testExerciseWithDefaultValuesListRowExercisesView.tap()

        let exerciseNameText = app.scrollViews.staticTexts["Test"]

        XCTAssertTrue(helpers.detailsNavigationTitle.exists, "The navigation title should be 'Details'")
        XCTAssertTrue(exerciseNameText.exists, "The name of the Exercise should be displayed")
        XCTAssertTrue(helpers.exerciseDetailsSetChart.exists, "A chart showing the Exercise's sets should be displayed")
        XCTAssertTrue(helpers.exerciseDetailsSetChartRuleMark.exists, "A RuleMark showing the Exercise's goal should exist")
    }

    func test_OnEditExercise_ExerciseDetailsHeaderUpdates() {
        helpers.createAndUpdateTestExercise()

        let updatedNameText = app.scrollViews.staticTexts["Test1"]

        XCTAssertTrue(updatedNameText.exists, "The Exercise's updated name should be displayed in the header")
    }
}
