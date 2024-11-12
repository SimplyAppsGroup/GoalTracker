//
//  InsightsView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//


import SwiftUI
import Charts

struct InsightsScreen: View {
    @ObservedObject var viewModel: GoalViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Insights Screen")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
            }
            
            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text("Goal Completion Streaks")
                    .font(.headline)

                HStack {
                    Text("Current Streak:")
                        .font(.subheadline)
                    Spacer()
                    Text("\(viewModel.currentGoalCompletionStreak) days") +
                        Text(viewModel.currentGoalCompletionStreak >= viewModel.highestGoalCompletionStreak ? " 🔥" : "")
                }

                HStack {
                    Text("Highest Streak:")
                        .font(.subheadline)
                    Spacer()
                    Text("\(viewModel.highestGoalCompletionStreak) days")
                }
            }
            .padding()
            .background(Color(red: 30/255, green: 30/255, blue: 30/255))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("Average Goals Completed")
                    .font(.headline)

                HStack {
                    Text("Per Day:")
                        .font(.subheadline)
                    Spacer()
                    Text(String(format: "%.2f", viewModel.averageGoalsCompletedPerDay))
                }

                HStack {
                    Text("Per Week:")
                        .font(.subheadline)
                    Spacer()
                    Text(String(format: "%.2f", viewModel.averageGoalsCompletedPerWeek))
                }

                HStack {
                    Text("Per Month:")
                        .font(.subheadline)
                    Spacer()
                    Text(String(format: "%.2f", viewModel.averageGoalsCompletedPerMonth))
                }
            }
            .padding()
            .background(Color(red: 30/255, green: 30/255, blue: 30/255))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("Goals Completed Each Day (This Month)")
                    .font(.headline)

                Chart {
                    ForEach(viewModel.goalsCompletedEachDayThisMonth, id: \.date) { data in
                        BarMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Goals Completed", data.count)
                        )
                        .foregroundStyle(Color.blue)
                    }
                }
                .frame(height: 200)
            }
            .padding()
            .background(Color(red: 30/255, green: 30/255, blue: 30/255))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(red: 20/255, green: 25/255, blue: 40/255).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ContentView()
}
