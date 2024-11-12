//
//  ProgressView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

enum TimePeriod: String, CaseIterable, Identifiable {
    case thisMonth = "This Month"
    case thisYear = "This Year"
    case allTime = "All Time"
    
    var id: String { self.rawValue }
}

struct ProgressScreen: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var selectedTimePeriod: TimePeriod = .thisMonth
    @State private var isAddGoalPresented: Bool = false
    @State private var goalToEdit: Goal?

    var body: some View {
        VStack {
            // Title
            HStack {
                Text("Goal Progression")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
            
            Spacer()

            // Time Period Picker
            Picker("Time Period", selection: $selectedTimePeriod) {
                ForEach(TimePeriod.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color(red: 20/255, green: 25/255, blue: 40/255))
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = .gray
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            }
            .padding()
            
            // Total Goals & Goals Met
            HStack {
                VStack(alignment: .center) {
                    Text("Total Goals:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(viewModel.totalGoals)")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()

                VStack(alignment: .center) {
                    Text("Goals Met:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(viewModel.goalsMet)")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            // Progress Bars
            if selectedTimePeriod == .thisMonth {
                // Month Goal Progress Bar
                VStack(alignment: .leading) {
                    Text("Goals Progress (This Month)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    let currentMonth = Date()
                    let totalGoalsThisMonth = viewModel.goalsPerMonth(for: currentMonth)
                    let goalsMetThisMonth = viewModel.goalsMetPerMonth(for: currentMonth)
                    let monthlyProgress = totalGoalsThisMonth > 0 ? Double(goalsMetThisMonth) / Double(totalGoalsThisMonth) : 0
                    let monthlyPercentage = monthlyProgress * 100

                    ProgressView(value: monthlyProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .padding(.horizontal)

                    HStack {
                        Text("Met: \(goalsMetThisMonth) (\(String(format: "%.1f", monthlyPercentage))%)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Total: \(totalGoalsThisMonth)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
            } else if selectedTimePeriod == .thisYear {
                // Year Goal Progression Bar
                VStack(alignment: .leading) {
                    Text("Goals Progress (This Year)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    let currentYear = Date()
                    let totalGoalsThisYear = viewModel.goalsPerYear(for: currentYear)
                    let goalsMetThisYear = viewModel.goalsMetPerYear(for: currentYear)
                    let yearlyProgress = totalGoalsThisYear > 0 ? Double(goalsMetThisYear) / Double(totalGoalsThisYear) : 0
                    let yearlyPercentage = yearlyProgress * 100

                    ProgressView(value: yearlyProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .padding(.horizontal)

                    HStack {
                        Text("Met: \(goalsMetThisYear) (\(String(format: "%.1f", yearlyPercentage))%)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Total: \(totalGoalsThisYear)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
            } else if selectedTimePeriod == .allTime {
                // All Time Goal Progression Bar
                VStack(alignment: .leading) {
                    Text("Goals Progress (All Time)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    let totalGoalsAllTime = viewModel.totalGoals
                    let goalsMetAllTime = viewModel.goalsMet
                    let allTimeProgress = totalGoalsAllTime > 0 ? Double(goalsMetAllTime) / Double(totalGoalsAllTime) : 0
                    let allTimePercentage = allTimeProgress * 100

                    ProgressView(value: allTimeProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .padding(.horizontal)

                    HStack {
                        Text("Met: \(goalsMetAllTime) (\(String(format: "%.1f", allTimePercentage))%)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Total: \(totalGoalsAllTime)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()

            // Goal List
            List {
                ForEach(filteredGoals) { goal in
                    HStack {
                        Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(goal.isCompleted ? .green : .blue)
                        Text(goal.description)
                            .font(.title3)
                            .strikethrough(goal.isCompleted)
                            .foregroundColor(.white)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
                            viewModel.goals[index].isCompleted.toggle()
                            viewModel.saveGoals()
                        }
                    }
                    .contextMenu {
                        Button(action: {
                            goalToEdit = goal
                            isAddGoalPresented = true
                        }) {
                            Text("Edit Goal")
                            Image(systemName: "pencil")
                        }
                    }
                }
                .listRowBackground(Color(red: 20/255, green: 25/255, blue: 40/255))
            }
            .background(Color(red: 20/255, green: 25/255, blue: 40/255))
            .scrollContentBackground(.hidden)
        }
        .padding()
        .background(Color(red: 20/255, green: 25/255, blue: 40/255).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isAddGoalPresented, onDismiss: { goalToEdit = nil }) {
            if let goalToEdit = goalToEdit {
                CreateGoalView(goal: $goalToEdit, viewModel: viewModel, isPresented: $isAddGoalPresented)
            }
        }
    }
    
    // Filter goals based on the selected time period
    var filteredGoals: [Goal] {
        switch selectedTimePeriod {
        case .thisMonth:
            return viewModel.goals.filter { Calendar.current.isDate($0.dueDate, equalTo: Date(), toGranularity: .month) }
        case .thisYear:
            return viewModel.goals.filter { Calendar.current.isDate($0.dueDate, equalTo: Date(), toGranularity: .year) }
        case .allTime:
            return viewModel.goals
        }
    }
}

#Preview {
    ContentView()
}
