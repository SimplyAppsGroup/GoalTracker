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
            HomeScreen(viewModel: GoalViewModel()) // Main screen content
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            // Placeholder for Progress Screen
            Text("Progress Screen")
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }
            
            // Placeholder for Insights Screen
            Text("Insights Screen")
                .tabItem {
                    Label("Insights", systemImage: "chart.pie")
                }
        }
    }
}
