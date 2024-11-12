//
//  InsightsView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//


import SwiftUI

struct InsightsScreen: View {
    @ObservedObject var viewModel: GoalViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Insights Screen")
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    ContentView()
}
