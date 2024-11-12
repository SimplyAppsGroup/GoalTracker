//
//  WeekCalendarView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GoalViewModel()

    var body: some View {
        TabView {
            HomeScreen(viewModel: viewModel) // Main screen content
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ProgressScreen(viewModel: viewModel) // Progress screen content
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }
            
            InsightsScreen(viewModel: viewModel) // Progress screen content
                .tabItem {
                    Label("Insights", systemImage: "chart.pie")
                }
        }
    }
}
#Preview {
    ContentView()
}
