// CalendarViewModel.swift
// GoalTracker
//
// Created by Marlon Delrosario on 11/10/24.

import SwiftUI
import Foundation

class CalendarViewModel: ObservableObject {
    @Published var currentMonthDates: [Date] = []
    @Published var selectedDate = Date()
    @Published var showFullCalendar = false

    init() {
        generateCurrentMonthDates()
    }

    func generateCurrentMonthDates() {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: selectedDate) else { return }
        var dates: [Date] = []
        var currentDate = monthInterval.start

        while currentDate < monthInterval.end {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        currentMonthDates = dates
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        showFullCalendar = false
        generateCurrentMonthDates()
    }

    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    func goToPreviousMonth() {
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
        generateCurrentMonthDates()
    }

    func goToNextMonth() {
        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
        generateCurrentMonthDates()
    }

    func returnToToday() {
        selectedDate = Date()
        generateCurrentMonthDates()
        showFullCalendar = false
    }
}
