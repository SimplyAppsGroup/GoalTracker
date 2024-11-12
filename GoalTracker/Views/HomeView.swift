//
//  HomeView.swift
//  GoalTracker
//
//  Created by Desiree on 11/9/24.
//

import SwiftUI



struct HomeView: View {
    @State private var selectedDay: String = "Monday"  // Track selected day
    @State private var goals: [Goal] = []  // Store the goals
    @State private var isAddGoalPresented: Bool = false  // Track if the Add Goal view is presented
    @State private var goalToEdit: Goal? = nil  // Goal to edit (if any)

    var body: some View {
        VStack {
            // Header showing the current day
            Text("Today's Goals")
                .font(.largeTitle)
                .padding()

            // Horizontal day selector
            HStack {
                ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], id: \.self) { day in
                    Text(day)
                        .padding()
                        .background(self.selectedDay == day ? Color.blue : Color.gray)
                        .foregroundColor(self.selectedDay == day ? .white : .black)
                        .cornerRadius(8)
                        .onTapGesture {
                            self.selectedDay = day
                        }
                }
            }
            .padding()

            // Display the total number of goals for the selected day
            Text("Goals Due: \(goals.count)")
                .padding()

            // Display goals for the selected day
            List {
                ForEach(goals) { goal in
                    HStack {
                        Text(goal.description)
                        Spacer()
                        if goal.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Image(systemName: "circle")
                        }
                    }
                    .onTapGesture {
                        // Handle goal editing (edit the goal when tapped)
                        goalToEdit = goal
                        isAddGoalPresented = true
                    }
                    .contextMenu {
                        Button(action: {
                            deleteGoal(goal)  // Context menu for deleting the goal
                        }) {
                            Text("Delete Goal")
                            Image(systemName: "trash")
                        }
                    }
                }
                .onDelete(perform: deleteGoalAt)  // Corrected onDelete method
            }
            .padding()

            // Add goal button
            Button(action: {
                isAddGoalPresented = true  // Show the AddGoalView
            }) {
                Text("Add Goal")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .sheet(isPresented: $isAddGoalPresented) {
            CreateGoalView(goal: $goalToEdit, viewModel: GoalViewModel(), isPresented: $isAddGoalPresented)
        }
    }

    // Function to delete a goal from the goals array using the IndexSet
    private func deleteGoalAt(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)  // Removes the goal from the array based on the offsets provided by onDelete
    }

    // Function to delete a goal by directly matching its ID (used in the context menu)
    private func deleteGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals.remove(at: index)
        }
    }
}

#Preview {
    HomeView()
}
