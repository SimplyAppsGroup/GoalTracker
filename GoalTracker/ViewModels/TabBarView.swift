//
//  TabBarView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView() // Home Screen
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ProgressView(viewModel: GoalViewModel()) // Progress Screen
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }
            
            InsightsView() // Insights Screen
                .tabItem {
                    Label("Insights", systemImage: "lightbulb")
                }
        }
    }
}
