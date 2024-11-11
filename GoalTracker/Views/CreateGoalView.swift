//  CreateGoalView.swift
//  GoalTracker
//
//  Created by Marlon del rosario on 11/9/24.

import SwiftUI
import UserNotifications

// Enum to specify repeat intervals
enum ReminderInterval: String, CaseIterable, Identifiable, Codable {
    case none
    case daily
    case weekly
    case onTime  // New option for one-time reminders

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
    @State private var reminderTime: Date = Date()  // Default to current date and time
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
            _repeatInterval = State(initialValue: existingGoal.reminderInterval)  // Load reminder interval
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
                        Text("On Time").tag(ReminderInterval.onTime)
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
                        scheduleNotification(at: selectedDate, repeatInterval: repeatInterval)
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
            updatedGoal.reminderInterval = repeatInterval  // Save reminder interval
            viewModel.updateGoal(updatedGoal)
        } else {
            let newGoal = Goal(description: description, isCompleted: false, dueDate: selectedDate, reminderInterval: repeatInterval)
            viewModel.goals.append(newGoal)
            viewModel.saveGoals()
        }
        isPresented = false
    }

    private func scheduleNotification(at time: Date, repeatInterval: ReminderInterval) {
        // Request notification permission if not already granted
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if granted {
                DispatchQueue.main.async {
                    self.createNotification(at: time, repeatInterval: repeatInterval)
                }
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private func createNotification(at time: Date, repeatInterval: ReminderInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Goal Reminder"
        content.body = "Don't forget: \(description)"
        content.sound = .default

        var trigger: UNNotificationTrigger

        switch repeatInterval {
        case .daily:
            let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: time)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            print("Daily notification scheduled with trigger date components: \(triggerDate)")

        case .weekly:
            let triggerDate = Calendar.current.dateComponents([.weekday, .hour, .minute], from: time)
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            print("Weekly notification scheduled with trigger date components: \(triggerDate)")

        case .onTime, .none:
            // Calculate the time interval in seconds between now and the target time
            let interval = time.timeIntervalSinceNow
            if interval > 0 {
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
                print("One-time notification scheduled to trigger in \(interval) seconds at \(time)")
            } else {
                print("Notification time is in the past; notification not scheduled.")
                return
            }
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(time) with interval \(repeatInterval.rawValue)")
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
