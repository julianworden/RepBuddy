//
//  WeightUnit.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

enum WeightUnit: String, CaseIterable, Identifiable {
    case pounds = "Pounds"
    case kilograms = "Kilograms"
    
    var id: Self { self }
}
