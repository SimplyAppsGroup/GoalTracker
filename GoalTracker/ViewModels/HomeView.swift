//
//  HomeView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//


import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = GoalViewModel() // Managing goals state
    @State private var isGoalAdding = false // Track if user is adding a goal
    @State private var goalToEdit: Goal? = nil // Track goal to be edited
    
    var body: some View {
        NavigationView {
            VStack {
                // Header showing current day
                Text("Today: \(DateFormatter.localizedString(from: Date(), dateStyle: .full, timeStyle: .none))")
                    .font(.title)
                    .padding()
                
                // Week calendar display (could be a simple horizontal scroll of days)
                WeekCalendarView()
                
                // Goal list display
                List {
                    ForEach(viewModel.goals) { goal in
                        HStack {
                            Button(action: {
                                viewModel.toggleGoalCompletion(goal) // Toggle completion
                            }) {
                                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(goal.isCompleted ? .green : .gray)
                            }
                            
                            Text(goal.description)
                                .font(.body)
                        }
                        .swipeActions {
                            Button("Edit") {
                                goalToEdit = goal // Set the goal to edit
                                isGoalAdding = true // Show the edit screen
                            }
                            .tint(.blue)
                        }
                    }
                    .onDelete(perform: viewModel.deleteGoal)
                }
                .navigationTitle("Goals")
                .navigationBarItems(trailing: Button(action: {
                    isGoalAdding = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                })
                .sheet(isPresented: $isGoalAdding) {
                    if let goalToEdit = goalToEdit {
                        AddGoalView(viewModel: viewModel, goalToEdit: goalToEdit) // Pass the goal to edit
                    } else {
                        AddGoalView(viewModel: viewModel) // If no goal to edit, show the "Add Goal" view
                    }
                }
            }
        }
    }
}
