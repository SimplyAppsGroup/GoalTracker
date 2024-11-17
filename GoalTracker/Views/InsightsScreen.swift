//
//  InsightsView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//


import SwiftUI
import Charts
import GoogleGenerativeAI

struct InsightsScreen: View {
    @ObservedObject var viewModel: GoalViewModel
    let apiKey = "AIzaSyAqfFVnw0MhCSWAE1vaNl-maXxYk5g_uaM" //API key
    
    @State private var geminiResponse: String = "💭"
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Insights Screen")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                }
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
                .background(Color(red: 30 / 255, green: 30 / 255, blue: 30 / 255))
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
                .background(Color(red: 30 / 255, green: 30 / 255, blue: 30 / 255))
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
                .background(Color(red: 30 / 255, green: 30 / 255, blue: 30 / 255))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal)
                
                // Google Gemini headline & button
                VStack(alignment: .center, spacing: 15) {
                    Text("Generate personalized insight on goals using AI")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text(geminiResponse)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Button("Generate") {
                        Task {
                            await fetchGeminiResponse()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .background(Color(red: 20 / 255, green: 25 / 255, blue: 40 / 255).edgesIgnoringSafeArea(.all))
        }
    }
    
    // Gemini API call
    private func fetchGeminiResponse() async {
        let generativeModel = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: apiKey
        )
                
        // AI prompt with goal information
        let prompt = """
        Analyze user habits and provide personalized feedback on progress based on the following data:
        
        - Current Goal Completion Streak: \(viewModel.currentGoalCompletionStreak) days
        - Highest Goal Completion Streak: \(viewModel.highestGoalCompletionStreak) days
        - Average Goals Completed Per Day: \(String(format: "%.2f", viewModel.averageGoalsCompletedPerDay))
        - Average Goals Completed Per Week: \(String(format: "%.2f", viewModel.averageGoalsCompletedPerWeek))
        - Average Goals Completed Per Month: \(String(format: "%.2f", viewModel.averageGoalsCompletedPerMonth))
        
        Additionally, here is the trend of goals completed each day this month:
        \(viewModel.goalsCompletedEachDayThisMonth.map { "\($0.date): \($0.count) goals" }.joined(separator: "\n"))
        
        
        Be positive.
        """
        
        // Retry if AI doesn't generate
        var retryCount = 0
        let maxRetries = 3
        
        while retryCount < maxRetries {
            do {
                let response = try await generativeModel.generateContent(prompt)
                if let text = response.text {
                    DispatchQueue.main.async {
                        geminiResponse = text
                    }
                    return
                }
            } catch {
                retryCount += 1
                DispatchQueue.main.async {
                    geminiResponse = "Attempt \(retryCount) failed. Retrying..."
                }
                if retryCount >= maxRetries {
                    DispatchQueue.main.async {
                        geminiResponse = "Failed to fetch Gemini response after \(maxRetries) attempts. Error: \(error.localizedDescription)"
                    }
                    return
                }
            }
            
            try? await Task.sleep(nanoseconds: 1_000_000_000) //wait before retrying
        }
    }
}

#Preview {
    ContentView()
}
