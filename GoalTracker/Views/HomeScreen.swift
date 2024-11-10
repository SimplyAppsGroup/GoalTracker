//
//  HomeView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: GoalViewModel
    @ObservedObject var calendarViewModel = CalendarViewModel()  // Using CalendarViewModel for date handling
    @State private var isAddGoalPresented: Bool = false
    @State private var goalToEdit: Goal?

    var body: some View {
        NavigationView {
            VStack {
                DateHeaderView(date: $calendarViewModel.selectedDate, showFullCalendar: $calendarViewModel.showFullCalendar)

                if calendarViewModel.showFullCalendar {
                    FullCalendarView(calendarViewModel: calendarViewModel)
                } else {
                    DaySelectorView(selectedDate: $calendarViewModel.selectedDate)
                    GoalsSummaryView(viewModel: viewModel, selectedDate: calendarViewModel.selectedDate)

                    GoalListView(
                        viewModel: viewModel,
                        selectedDate: calendarViewModel.selectedDate,
                        isAddGoalPresented: $isAddGoalPresented,
                        goalToEdit: $goalToEdit
                    )
                }
            }
            .navigationBarTitle("Goal Tracker", displayMode: .inline)
            .navigationBarHidden(true)
            .sheet(isPresented: $isAddGoalPresented, onDismiss: { goalToEdit = nil }) {
                if let goal = goalToEdit {
                    EditGoalView(goal: .constant(goal), viewModel: viewModel, isPresented: $isAddGoalPresented)
                } else {
                    AddGoalView(isPresented: $isAddGoalPresented, goals: $viewModel.goals)
                }
            }
        }
    }
}

struct DateHeaderView: View {
    @Binding var date: Date
    @Binding var showFullCalendar: Bool  // Toggle for full calendar display

    var body: some View {
        Button(action: {
            showFullCalendar.toggle()  // Toggle full calendar display
        }) {
            Text("\(formattedMonthYear(date))")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
        }
        .padding(.top)
    }

    func formattedMonthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct DaySelectorView: View {
    @Binding var selectedDate: Date

    var body: some View {
        let calendar = Calendar.current
        guard let startOfWeek = selectedDate.startOfWeek() else { return AnyView(EmptyView()) }
        let currentWeek = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }

        return AnyView(
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(currentWeek, id: \.self) { day in
                        Text("\(calendar.component(.day, from: day))")
                            .padding()
                            .background(calendar.isDate(day, inSameDayAs: selectedDate) ? Color.blue : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .onTapGesture {
                                selectedDate = day
                            }
                    }
                }
            }
            .padding()
        )
    }
}

struct GoalsSummaryView: View {
    var viewModel: GoalViewModel
    var selectedDate: Date

    var body: some View {
        VStack {
            HStack {
                Text("Total Goals Due: \(viewModel.totalGoals(for: selectedDate))")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .padding(.bottom, 5)

            HStack {
                Text("Total Missed Goals: \(viewModel.totalMissedGoals(for: selectedDate))")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.red)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct GoalListView: View {
    @ObservedObject var viewModel: GoalViewModel
    var selectedDate: Date
    @Binding var isAddGoalPresented: Bool
    @Binding var goalToEdit: Goal?

    @State private var showActionSheet = false
    @State private var selectedGoal: Goal?

    var body: some View {
        List {
            ForEach(viewModel.goalsForDate(selectedDate)) { goal in
                GoalRowView(goal: goal, viewModel: viewModel)
                    .onTapGesture {
                        selectedGoal = goal
                        showActionSheet = true
                    }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.bottom)

        Button(action: {
            isAddGoalPresented = true
        }) {
            Text("Add New Goal")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .padding()
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Goal Options"),
                message: Text("What would you like to do with this goal?"),
                buttons: [
                    .default(Text("Edit Goal")) {
                        goalToEdit = selectedGoal
                        isAddGoalPresented = true
                    },
                    .destructive(Text("Delete Goal"), action: {
                        if let goal = selectedGoal {
                            deleteGoal(goal)
                        }
                    }),
                    .cancel()
                ]
            )
        }
    }

    private func deleteGoal(_ goal: Goal) {
        if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.goals.remove(at: index)
            viewModel.saveGoals()
        }
    }
}

struct GoalRowView: View {
    var goal: Goal
    @ObservedObject var viewModel: GoalViewModel

    var body: some View {
        HStack {
            Button(action: {
                toggleGoalCompletion(goal)
            }) {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(goal.isCompleted ? .green : .blue)
                    .padding(.trailing, 10)
            }

            Text(goal.description)
                .foregroundColor(.primary)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    private func toggleGoalCompletion(_ goal: Goal) {
        if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.goals[index].isCompleted.toggle()
            viewModel.saveGoals()
        }
    }
}

extension Date {
    func startOfWeek() -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)
    }
}
