//
//  ProgressView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//


import SwiftUI

struct ProgressView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var selectedGoal: Goal? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.goals) { goal in
                    Button(action: {
                        selectedGoal = goal
                    }) {
                        Text(goal.description)
                    }
                }
                .navigationTitle("Progress")
                
                if let goal = selectedGoal {
                    VStack {
                        // Calendar for completion dates
                        Text("Completion Dates")
                        CalendarView(completionDates: goal.completionDates)
                        
                        // Streak information
                        Text("Current Streak: \(goal.currentStreak) days")
                        Text("Longest Streak: \(goal.longestStreak) days")
                    }
                    .padding()
                }
            }
        }
    }
}
