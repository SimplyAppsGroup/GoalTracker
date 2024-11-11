//
//  GoalViewModel.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []  // The list of goals
    
    // Initialize and load goals from persistent storage when the view model is created
    init() {
        loadGoals()  // Load goals from persistent storage when the view model is initialized
    }
    
    // Filter goals by a specific date
    func goalsForDate(_ date: Date) -> [Goal] {
        let calendar = Calendar.current
        return goals.filter { calendar.isDate($0.dueDate, inSameDayAs: date) }
    }
    
    // Function to update a goal in the list
    func updateGoal(_ updatedGoal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == updatedGoal.id }) {
            goals[index] = updatedGoal
            saveGoals()  // Save the changes persistently if needed
        }
    }
    
    
    // Function to save goals (e.g., to UserDefaults)
    func saveGoals() {
        guard let encoded = try? JSONEncoder().encode(goals) else { return }
        UserDefaults.standard.set(encoded, forKey: "savedGoals")
    }
    
    // Function to load goals (e.g., from UserDefaults)
    func loadGoals() {
        guard let data = UserDefaults.standard.data(forKey: "savedGoals"),
              let decodedGoals = try? JSONDecoder().decode([Goal].self, from: data) else { return }
        goals = decodedGoals
    }

    
    // Get the total number of goals for a specific date
    func totalGoals(for date: Date) -> Int {
        return goalsForDate(date).count
    }
    
    // Get the total number of missed goals for a specific date
    func totalMissedGoals(for date: Date) -> Int {
        let goalsForTheDay = goalsForDate(date)
        return goalsForTheDay.filter { !$0.isCompleted }.count
    }
}
