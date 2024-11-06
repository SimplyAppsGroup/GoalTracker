//
//  GoalViewModel.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//


import SwiftUI

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func toggleGoalCompletion(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].isCompleted.toggle()
            if goals[index].isCompleted {
                goals[index].completionDates.append(Date()) // Add current date to completionDates
            }
        }
    }
    
    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }
}
