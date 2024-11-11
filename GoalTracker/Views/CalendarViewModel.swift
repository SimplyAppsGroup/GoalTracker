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

struct FullCalendarView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    calendarViewModel.goToPreviousMonth()
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }

                Spacer()

                Text(calendarViewModel.selectedDate, formatter: monthYearFormatter())
                    .font(.headline)

                Spacer()

                Button(action: {
                    calendarViewModel.goToNextMonth()
                }) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            .padding()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(calendarViewModel.currentMonthDates, id: \.self) { date in
                    if Calendar.current.isDate(date, equalTo: calendarViewModel.selectedDate, toGranularity: .month) {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(calendarViewModel.isSameDay(date, calendarViewModel.selectedDate) ? Color.blue : Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .onTapGesture {
                                calendarViewModel.selectDate(date)
                            }
                    }
                }
            }
            .padding()

            Button(action: {
                calendarViewModel.returnToToday()  // Return to the present date
            }) {
                Text("Return to Today")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
    }

    private func monthYearFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

