//
//  Achievement.swift
//  GoalTracker
//
//  Created by Christina Gonzalez on 11/13/24.
//

import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var isUnlocked: Bool
    var icon: String
}
