//
//  Date+CustomFormats.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

extension Date {
    var numericDateNoTime: String {
        self.formatted(date: .numeric, time: .omitted)
    }

    var completeDateAndTime: String {
        self.formatted(date: .complete, time: .complete)
    }
}
