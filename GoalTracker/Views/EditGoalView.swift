//
//  EditGoalView.swift
//  GoalTracker
//
//  Created by Desiree on 11/9/24.
//

import SwiftUI

struct EditGoalView: View {
    @Environment(\.presentationMode) var presentationMode  // To dismiss the view
    @Binding var goal: Goal  // Binding to the selected goal
    @ObservedObject var viewModel: GoalViewModel  // Access viewModel to save changes
    @Binding var isPresented: Bool  // To control presentation
    
    // Local state for temporary edits
    @State private var editedDescription: String
    @State private var editedDueDate: Date
    @State private var isCompleted: Bool
    
    init(goal: Binding<Goal>, viewModel: GoalViewModel, isPresented: Binding<Bool>) {
        _goal = goal
        self.viewModel = viewModel
        _isPresented = isPresented
        _editedDescription = State(initialValue: goal.wrappedValue.description)
        _editedDueDate = State(initialValue: goal.wrappedValue.dueDate)
        _isCompleted = State(initialValue: goal.wrappedValue.isCompleted)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details").font(.headline)) {
                    TextField("Description", text: $editedDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    
                    DatePicker("Due Date", selection: $editedDueDate, displayedComponents: [.date])
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.vertical, 5)
                    
                    Toggle(isOn: $isCompleted) {
                        Text("Completed")
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()  // Apply the changes and save
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        // Apply the changes to the goal object
        goal.description = editedDescription
        goal.dueDate = editedDueDate
        goal.isCompleted = isCompleted

        // Update the goal in the view model
        viewModel.updateGoal(goal)
        
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
}
