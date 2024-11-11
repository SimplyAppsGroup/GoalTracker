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
    var reminderInterval: ReminderInterval

    // Initialize the Goal struct with reminderInterval
    init(description: String, isCompleted: Bool, dueDate: Date, reminderInterval: ReminderInterval = .none) {
        self.id = UUID()
        self.description = description
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.reminderInterval = reminderInterval
    }
}
