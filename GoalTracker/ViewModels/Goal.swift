//
//  GoalViewModel.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import Foundation

// A goal model conforming to Identifiable for easy listing in SwiftUI
struct Goal: Identifiable {
    var id = UUID()
    var description: String
    var target: String
    var startDate: Date
    var isCompleted: Bool
    var completionDates: [Date] = [] // Track completion dates for the goal
    
    // To help calculate streaks
    var longestStreak: Int
    var currentStreak: Int
}
