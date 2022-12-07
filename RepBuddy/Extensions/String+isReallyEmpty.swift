//
//  String+isReallyEmpty.swift
//  TheSamePage
//
//  Created by Julian Worden on 11/10/22.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
