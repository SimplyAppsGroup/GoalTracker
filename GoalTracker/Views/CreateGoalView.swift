//  CreateGoalView.swift
//  GoalTracker
//
//  Created by Marlon del rosario on 11/9/24.

import SwiftUI
import UserNotifications

// Enum to specify repeat intervals
enum ReminderInterval: String, CaseIterable, Identifiable {
    case none
    case daily
    case weekly

    var id: String { self.rawValue }
}

struct CreateGoalView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var goal: Goal?
    @ObservedObject var viewModel: GoalViewModel
    @Binding var isPresented: Bool

    // State properties for creating or editing a goal
    @State private var description: String = ""
    @State private var isCompleted: Bool = false
    @State private var reminderTime: Date? = nil
    @State private var repeatInterval: ReminderInterval = .none

    // Date picker state
    @State private var selectedDate: Date = Date()

    init(goal: Binding<Goal?>, viewModel: GoalViewModel, isPresented: Binding<Bool>) {
        _goal = goal
        self.viewModel = viewModel
        _isPresented = isPresented
        if let existingGoal = goal.wrappedValue {
            _description = State(initialValue: existingGoal.description)
            _selectedDate = State(initialValue: existingGoal.dueDate)
            _isCompleted = State(initialValue: existingGoal.isCompleted)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details").font(.headline)) {
                    TextField("Goal Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    
                    // Use custom date-time picker for date selection
                    CustomDateTimePicker(selectedDate: $selectedDate)
                        .padding(.vertical, 5)

                    Toggle(isOn: $isCompleted) {
                        Text("Completed")
                    }
                    .padding(.vertical, 5)

                    Picker("Repeat Reminder", selection: $repeatInterval) {
                        Text("None").tag(ReminderInterval.none)
                        Text("Daily").tag(ReminderInterval.daily)
                        Text("Weekly").tag(ReminderInterval.weekly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveGoal()
                        if let reminderTime = reminderTime {
                            scheduleNotification(at: reminderTime, repeatInterval: repeatInterval)
                        }
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

    private func saveGoal() {
        if let existingGoal = goal {
            var updatedGoal = existingGoal
            updatedGoal.description = description
            updatedGoal.dueDate = selectedDate
            updatedGoal.isCompleted = isCompleted
            viewModel.updateGoal(updatedGoal)
        } else {
            let newGoal = Goal(description: description, isCompleted: false, dueDate: selectedDate)
            viewModel.goals.append(newGoal)
            viewModel.saveGoals()
        }
        isPresented = false
    }

    private func scheduleNotification(at time: Date, repeatInterval: ReminderInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Goal Reminder"
        content.body = "Don't forget: \(description)"
        content.sound = .default

        var triggerDate = Calendar.current.dateComponents([.hour, .minute], from: time)
        
        switch repeatInterval {
        case .daily:
            triggerDate = Calendar.current.dateComponents([.hour, .minute], from: time)
        case .weekly:
            triggerDate = Calendar.current.dateComponents([.weekday, .hour, .minute], from: time)
        case .none:
            break
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeatInterval != .none)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct CustomDateTimePicker: View {
    @Binding var selectedDate: Date

    var body: some View {
        DatePicker(
            "Select Date and Time",
            selection: $selectedDate,
            displayedComponents: [.date, .hourAndMinute]
        )
        .datePickerStyle(WheelDatePickerStyle())
        .labelsHidden()
    }
}
