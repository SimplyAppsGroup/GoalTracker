//
//  WeekCalendarView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

extension Color {
    static let appBlue = Color(red: 0/255, green: 122/255, blue: 255/255)
}

struct ContentView: View {
    @StateObject var viewModel = GoalViewModel()

    //Tab view bar/icon color
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 20/255, green: 25/255, blue: 40/255, alpha: 1)
        let selectedColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        //Apply to whole app
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeScreen(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ProgressScreen(viewModel: viewModel)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }
            
            InsightsScreen(viewModel: viewModel)
                .tabItem {
                    Label("Insights", systemImage: "chart.pie")
                }
            
            AchievementScreen(viewModel: viewModel)
                .tabItem {
                    Label("Achievements", systemImage: "star")
                }
        }
    }
}
