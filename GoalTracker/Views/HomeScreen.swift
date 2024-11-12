//  HomeScreen.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: GoalViewModel
    @ObservedObject var calendarViewModel = CalendarViewModel()  // Using CalendarViewModel for date handling
    @State private var isAddGoalPresented: Bool = false
    @State private var goalToEdit: Goal?

    var body: some View {
        NavigationView {
            VStack {
                //Month and Year Header
                DateHeaderView(date: $calendarViewModel.selectedDate, showFullCalendar: $calendarViewModel.showFullCalendar)
                if calendarViewModel.showFullCalendar {
                    FullCalendarView(calendarViewModel: calendarViewModel)
                } else {
                    //Horizontal Day Selector
                    DaySelectorView(selectedDate: $calendarViewModel.selectedDate, currentMonthDates: calendarViewModel.currentMonthDates)
                    //Due and Missed Goals
                    GoalsSummaryView(viewModel: viewModel, selectedDate: calendarViewModel.selectedDate)
                    //List of Goals
                    GoalListView(
                        viewModel: viewModel,
                        selectedDate: calendarViewModel.selectedDate,
                        isAddGoalPresented: $isAddGoalPresented,
                        goalToEdit: $goalToEdit
                    )
                }
            }
            .background(Color(red: 20/255, green: 25/255, blue: 40/255).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Goal Tracker", displayMode: .inline)
            .navigationBarHidden(true)
            .sheet(isPresented: $isAddGoalPresented, onDismiss: { goalToEdit = nil }) {
                CreateGoalView(goal: $goalToEdit, viewModel: viewModel, isPresented: $isAddGoalPresented)
            }
        }
        .onAppear {
            calendarViewModel.generateCurrentMonthDates()
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
                .font(.largeTitle)
                .bold()
                .underline()
                .padding()
                .background(Color(red: 20/255, green: 25/255, blue: 40/255).edgesIgnoringSafeArea(.all))
                .foregroundColor(.blue)
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
    var currentMonthDates: [Date]

    var body: some View {
        let calendar = Calendar.current
        let startOfWeek = selectedDate.startOfWeek()
        
        VStack {
            
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(currentMonthDates, id: \.self) { day in
                            Text("\(calendar.component(.day, from: day))")
                                .foregroundColor(.white)
                                .padding()
                                .background(calendar.isDate(day, inSameDayAs: selectedDate) ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedDate = day
                                }
                        }
                    }
                    .padding()
                    .onAppear {
                        if let startOfWeek = startOfWeek, calendar.isDate(selectedDate, equalTo: Date(), toGranularity: .month) {
                            if let index = currentMonthDates.firstIndex(of: startOfWeek) {
                                scrollViewProxy.scrollTo(currentMonthDates[index], anchor: .center)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(red: 20/255, green: 25/255, blue: 40/255).edgesIgnoringSafeArea(.all))
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

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            List {
                ForEach(viewModel.goalsForDate(selectedDate)) { goal in
                    GoalRowView(goal: goal, viewModel: viewModel)
                        .onTapGesture {
                            toggleGoalCompletion(goal) // Mark complete on tap
                        }
                        .contextMenu { // Show edit and delete on hold
                            Button("Edit Goal") {
                                goalToEdit = goal
                                isAddGoalPresented = true
                            }
                            Button("Delete Goal", role: .destructive) {
                                deleteGoal(goal)
                            }
                        }
                        .listRowBackground(Color(red: 20/255, green: 25/255, blue: 40/255)) // Match row background
                }
            }
            .listStyle(PlainListStyle())
            .background(Color(red: 20/255, green: 25/255, blue: 40/255)) // Match list background
            .scrollContentBackground(.hidden) // Hide default background
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
        }
        .background(Color(red: 20/255, green: 25/255, blue: 40/255))
    }

    private func toggleGoalCompletion(_ goal: Goal) {
        if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
            viewModel.goals[index].isCompleted.toggle()
            viewModel.saveGoals()
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
            Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(goal.isCompleted ? .green : .blue)
                .padding(.trailing, 10)

            Text(goal.description)
                .foregroundColor(.white)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(red: 20/255, green: 25/255, blue: 40/255))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

extension Date {
    func startOfWeek() -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)

        return calendar.date(from: components)
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



#Preview {
    ContentView()
}
