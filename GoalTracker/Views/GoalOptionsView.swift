//
//  GoalOptionsView.swift
//  GoalTracker
//
//  Created by Desiree on 11/9/24.
//

import SwiftUI

struct GoalOptionsView: View {
    @Binding var isPresented: Bool
    var goal: Goal
    var viewModel: GoalViewModel  // Accept viewModel as a parameter
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    @State private var isEditGoalViewPresented = false  // Track edit view presentation
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Goal Options")
                .font(.headline)
            
            Button(action: {
                isEditGoalViewPresented = true  // Show EditGoalView
            }) {
                Text("Edit Goal")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
            
            Button(action: {
                onDelete()
                isPresented = false
            }) {
                Text("Delete Goal")
                    .foregroundColor(.red)
                    .font(.title3)
            }
            
            Button(action: {
                isPresented = false
            }) {
                Text("Cancel")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 10)
        .sheet(isPresented: $isEditGoalViewPresented) {
            CreateGoalView(goal: .constant(goal), viewModel: viewModel, isPresented: $isEditGoalViewPresented)
        }

    }
}
