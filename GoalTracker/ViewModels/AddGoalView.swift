//
//  AddGoalView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//



import SwiftUI

struct AddGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GoalViewModel
    
    @State private var goalDescription = ""
    @State private var target = ""
    @State private var startDate = Date()
    @State private var goalToEdit: Goal? = nil
    
    init(viewModel: GoalViewModel, goalToEdit: Goal? = nil) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._goalToEdit = State(initialValue: goalToEdit)
        
        if let goalToEdit = goalToEdit {
            _goalDescription = State(initialValue: goalToEdit.description)
            _target = State(initialValue: goalToEdit.target)
            _startDate = State(initialValue: goalToEdit.startDate)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Goal Description", text: $goalDescription)
                TextField("Target (e.g., 5 cups of water)", text: $target)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                
                Button("Save Goal") {
                    if let goalToEdit = goalToEdit {
                        // If we are editing, update the goal
                        if let index = viewModel.goals.firstIndex(where: { $0.id == goalToEdit.id }) {
                            viewModel.goals[index].description = goalDescription
                            viewModel.goals[index].target = target
                            viewModel.goals[index].startDate = startDate
                        }
                    } else {
                        // Otherwise, add a new goal
                        let newGoal = Goal(description: goalDescription, target: target, startDate: startDate, isCompleted: false, longestStreak: 0, currentStreak: 0)
                        viewModel.addGoal(newGoal)
                    }
                    presentationMode.wrappedValue.dismiss() // Close the sheet
                }
            }
            .navigationTitle(goalToEdit == nil ? "Add New Goal" : "Edit Goal")
        }
    }
}
