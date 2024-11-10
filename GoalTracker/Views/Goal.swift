//
//  GoalViewModel.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import Foundation

struct Goal: Identifiable, Codable {
    var id: UUID
    var description: String
    var isCompleted: Bool
    var dueDate: Date

    // Initialize the Goal struct
    init(description: String, isCompleted: Bool, dueDate: Date) {
        self.id = UUID()  // Assign a unique ID for each goal
        self.description = description
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}
