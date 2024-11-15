//
//  GoalViewModel.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []  // The list of goals
    @Published var achievements: [Achievement] = [] //List of achievements
    
    
    // Initialize and load goals from persistent storage when the view model is created
    init() {
        loadGoals()  // Load goals from persistent storage when the view model is initialized
        achievements = [ //Achievement list
            Achievement(title: "First Goal", description: "Complete your first goal", isUnlocked: false, icon: "star"),
                       Achievement(title: "7-Day Streak", description: "Complete goals for 7 days in a row", isUnlocked: false, icon: "flame"),
                       Achievement(title: "10 Goals Achieved", description: "Complete 10 goals", isUnlocked: false, icon: "checkmark.seal"),
                       Achievement(title: "50 Goals Achieved", description: "Complete 50 goals", isUnlocked: false, icon: "checkmark.circle.fill"),
                       Achievement(title: "100 Goals Achieved", description: "Complete 100 goals", isUnlocked: false, icon: "checkmark.square.fill"),
                       Achievement(title: "Goal Prodigy", description: "Complete 500 goals", isUnlocked: false, icon: "star.fill"),
                       Achievement(title: "Goal Guru", description: "Complete 1000 goals", isUnlocked: false, icon: "crown.fill"),
                       
                       Achievement(title: "Daily Goal Setter", description: "Complete a goal every day for a week", isUnlocked: false, icon: "calendar.circle"),
                       Achievement(title: "Weekly Warrior", description: "Complete a goal every day for four weeks", isUnlocked: false, icon: "calendar.badge.exclamationmark"),
                       Achievement(title: "Monthly Master", description: "Complete a goal every day for an entire month", isUnlocked: false, icon: "calendar.badge.plus"),
                       Achievement(title: "100-Day Streak", description: "Complete a goal daily for 100 days", isUnlocked: false, icon: "calendar.circle.fill"),
                       Achievement(title: "Year of Goals", description: "Complete a goal every day for an entire year", isUnlocked: false, icon: "calendar.circle.fill"),
                       
                       Achievement(title: "Weekend Warrior", description: "Complete a goal every weekend for a month", isUnlocked: false, icon: "calendar.circle.fill"),
                       Achievement(title: "Early Riser", description: "Complete a goal before 9 a.m. for seven days straight", isUnlocked: false, icon: "sunrise"),
                       Achievement(title: "Night Owl", description: "Complete a goal after 8 p.m. for seven days straight", isUnlocked: false, icon: "moon.stars.fill"),
                       Achievement(title: "Goal Getter", description: "Complete a goal every day, Monday through Friday, for a month", isUnlocked: false, icon: "sun.max.fill"),
                       Achievement(title: "Regular Reacher", description: "Complete goals on a regular schedule (e.g., every Tuesday and Thursday for a month)", isUnlocked: false, icon: "clock.fill")

                ]
                updateAchievements()
    }
   
    
    // Filter goals by a specific date
    func goalsForDate(_ date: Date) -> [Goal] {
        let calendar = Calendar.current
        return goals.filter { calendar.isDate($0.dueDate, inSameDayAs: date) }
    }
    
    // Function to update a goal in the list
    func updateGoal(_ updatedGoal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == updatedGoal.id }) {
            goals[index] = updatedGoal
            saveGoals()  // Save the changes persistently if needed
        }
    }
    
    // Function to save goals (e.g., to UserDefaults)
    func saveGoals() {
        guard let encoded = try? JSONEncoder().encode(goals) else { return }
        UserDefaults.standard.set(encoded, forKey: "savedGoals")
    }
    
    // Function to load goals (e.g., from UserDefaults)
    func loadGoals() {
        guard let data = UserDefaults.standard.data(forKey: "savedGoals"),
              let decodedGoals = try? JSONDecoder().decode([Goal].self, from: data) else { return }
        goals = decodedGoals
    }

    // Get the total number of goals for a specific date
    func totalGoals(for date: Date) -> Int {
        return goalsForDate(date).count
    }
    
    // Get the total number of missed goals for a specific date
    func totalMissedGoals(for date: Date) -> Int {
        let goalsForTheDay = goalsForDate(date)
        return goalsForTheDay.filter { !$0.isCompleted }.count
    }

    // Function to get the total number of goals
    var totalGoals: Int {
        goals.count
    }

    // Function to get the number of completed goals
    var goalsMet: Int {
        goals.filter { $0.isCompleted }.count
    }

    // Function to get the goals per month
    func goalsPerMonth(for month: Date) -> Int {
        let calendar = Calendar.current
        return goals.filter {
            calendar.isDate($0.dueDate, equalTo: month, toGranularity: .month)
        }.count
    }

    // Function to get the goals met per month
    func goalsMetPerMonth(for month: Date) -> Int {
        let calendar = Calendar.current
        return goals.filter {
            $0.isCompleted && calendar.isDate($0.dueDate, equalTo: month, toGranularity: .month)
        }.count
    }

    // Function to get the goals per year
    func goalsPerYear(for year: Date) -> Int {
        let calendar = Calendar.current
        return goals.filter {
            calendar.isDate($0.dueDate, equalTo: year, toGranularity: .year)
        }.count
    }

    // Function to get the goals met per year
    func goalsMetPerYear(for year: Date) -> Int {
        let calendar = Calendar.current
        return goals.filter {
            $0.isCompleted && calendar.isDate($0.dueDate, equalTo: year, toGranularity: .year)
        }.count
    }

    // Calculate the average number of goals completed per day
    var averageGoalsCompletedPerDay: Double {
        let completedGoals = goals.filter { $0.isCompleted }
        guard !completedGoals.isEmpty else { return 0.0 }
        let totalDays = completedGoals.map { $0.dueDate }.uniqueDates().count
        return Double(completedGoals.count) / Double(totalDays)
    }

    // Calculate the average number of goals completed per week
    var averageGoalsCompletedPerWeek: Double {
        let completedGoals = goals.filter { $0.isCompleted }
        guard !completedGoals.isEmpty else { return 0.0 }
        let totalWeeks = completedGoals.map { Calendar.current.component(.weekOfYear, from: $0.dueDate) }.uniqueValues().count
        return Double(completedGoals.count) / Double(totalWeeks)
    }

    // Calculate the average number of goals completed per month
    var averageGoalsCompletedPerMonth: Double {
        let completedGoals = goals.filter { $0.isCompleted }
        guard !completedGoals.isEmpty else { return 0.0 }
        let totalMonths = completedGoals.map { Calendar.current.component(.month, from: $0.dueDate) }.uniqueValues().count
        return Double(completedGoals.count) / Double(totalMonths)
    }

    // Calculate the current goal completion streak
    var currentGoalCompletionStreak: Int {
        let completedDates = goals.filter { $0.isCompleted }.map { Calendar.current.startOfDay(for: $0.dueDate) }.sorted()
        guard !completedDates.isEmpty else { return 0 }
        
        var streak = 0
        var currentStreak = 1
        let calendar = Calendar.current
        
        for i in 1..<completedDates.count {
            if calendar.isDate(completedDates[i], inSameDayAs: calendar.date(byAdding: .day, value: -1, to: completedDates[i - 1])!) {
                currentStreak += 1
            } else {
                streak = max(streak, currentStreak)
                currentStreak = 1
            }
        }
        return max(streak, currentStreak)
    }

    // Calculate the highest goal completion streak
    var highestGoalCompletionStreak: Int {
        let completedDates = goals.filter { $0.isCompleted }.map { Calendar.current.startOfDay(for: $0.dueDate) }.sorted()
        guard !completedDates.isEmpty else { return 0 }
        
        var streak = 0
        var currentStreak = 1
        let calendar = Calendar.current
        
        for i in 1..<completedDates.count {
            if calendar.isDate(completedDates[i], inSameDayAs: calendar.date(byAdding: .day, value: -1, to: completedDates[i - 1])!) {
                currentStreak += 1
            } else {
                streak = max(streak, currentStreak)
                currentStreak = 1
            }
        }
        return max(streak, currentStreak)
    }

    // Data structure for the bar chart
    struct GoalsCompletedPerDay: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }

    // Computed property for the bar graph data
    var goalsCompletedEachDayThisMonth: [GoalsCompletedPerDay] {
        let calendar = Calendar.current
        let currentMonth = Date()
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!
        
        var goalsCompleted: [GoalsCompletedPerDay] = []
        
        for day in daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: calendar.startOfMonth(for: currentMonth)!) {
                let count = goals.filter { $0.isCompleted && calendar.isDate($0.dueDate, inSameDayAs: date) }.count
                goalsCompleted.append(GoalsCompletedPerDay(date: date, count: count))
            }
        }
        
        return goalsCompleted
    }
    
    func updateAchievements() {
            if goals.count >= 1 {
                unlockAchievement(withTitle: "First Goal")
            }
            if currentGoalCompletionStreak >= 7 {
                unlockAchievement(withTitle: "7-Day Streak")
            }
            if goalsMet >= 10 {
                unlockAchievement(withTitle: "10 Goals Achieved")
            }
            if goalsMet >= 50 {
                unlockAchievement(withTitle: "50 Goals Achieved")
            }
            if goalsMet >= 100 {
                unlockAchievement(withTitle: "100 Goals Achieved")
            }
            if goalsMet >= 500 {
                unlockAchievement(withTitle: "Goal Prodigy")
            }
            if goalsMet >= 1000 {
                unlockAchievement(withTitle: "Goal Guru")
            }
            if currentGoalCompletionStreak >= 7 {
                unlockAchievement(withTitle: "Daily Goal Setter")
            }
            if currentGoalCompletionStreak >= 28 {
                unlockAchievement(withTitle: "Weekly Warrior")
            }
            if currentGoalCompletionStreak >= 30 {
                unlockAchievement(withTitle: "Monthly Master")
            }
            if currentGoalCompletionStreak >= 100 {
                unlockAchievement(withTitle: "100-Day Streak")
            }
            if currentGoalCompletionStreak >= 365 {
                unlockAchievement(withTitle: "Year of Goals")
            }
            if goalConsistencyOnWeekends() {
                unlockAchievement(withTitle: "Weekend Warrior")
            }
        }

        // Achievement unlock
    func unlockAchievement(withTitle title: String) {
        if let index = achievements.firstIndex(where: { $0.title == title && !$0.isUnlocked }) {
            achievements[index].isUnlocked = true
        }
    }

        // Weekend achievement check
    func goalConsistencyOnWeekends() -> Bool {
        return goals.filter { Calendar.current.isDateInWeekend($0.dueDate) }.count >= 4
    }

        // Early riser achievement check
    func earlyRiser() -> Bool {
        return goals.filter { Calendar.current.isDateInToday($0.dueDate) && Calendar.current.component(.hour, from: $0.dueDate) < 9 }.count >= 7
    }
}

// Extensions for unique values
extension Array where Element == Date {
    func uniqueDates() -> [Date] {
        Array(Set(self.map { Calendar.current.startOfDay(for: $0) }))
    }
}

extension Array where Element: Hashable {
    func uniqueValues() -> [Element] {
        Array(Set(self))
    }
}

// Extension to get the start of the month
extension Calendar {
    func startOfMonth(for date: Date) -> Date? {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)
    }
}
