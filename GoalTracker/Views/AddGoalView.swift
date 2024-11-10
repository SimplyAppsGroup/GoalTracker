//
//  AddGoalView.swift
//  GoalTracker
//
//  Created by Desiree on 11/9/24.
//

import SwiftUI

struct AddGoalView: View {
    @Binding var isPresented: Bool
    @Binding var goals: [Goal]
    @State private var goalDescription: String = ""
    @State private var goalDueDate: Date = Date()

    // If goalToEdit is passed, this means we are editing an existing goal
    var goalToEdit: Goal? = nil

    var body: some View {
        VStack {
            TextField("Goal Description", text: $goalDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Due Date", selection: $goalDueDate, displayedComponents: .date)
                .padding()

            Button(action: {
                // Add or edit the goal
                if let goalToEdit = goalToEdit {
                    // Edit an existing goal
                    if let index = goals.firstIndex(where: { $0.id == goalToEdit.id }) {
                        goals[index].description = goalDescription
                        goals[index].dueDate = goalDueDate
                    }
                } else {
                    // Add a new goal
                    let newGoal = Goal(description: goalDescription, isCompleted: false, dueDate: goalDueDate)
                    goals.append(newGoal)
                }
                
                // Dismiss the sheet
                isPresented = false
            }) {
                Text(goalToEdit == nil ? "Add Goal" : "Save")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            Button(action: {
                // Dismiss the AddGoalView without saving
                isPresented = false
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            if let goalToEdit = goalToEdit {
                goalDescription = goalToEdit.description
                goalDueDate = goalToEdit.dueDate
            }
        }
    }
}
