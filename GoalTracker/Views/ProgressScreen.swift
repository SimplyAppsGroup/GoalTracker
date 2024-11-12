//
//  ProgressView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

struct ProgressScreen: View {
    @ObservedObject var viewModel: GoalViewModel
    
    var body: some View {
            VStack {
                //Title
                HStack {
                    Text("Goal Progression")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                //Total Goals Met
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

                //Month Goal Progress Bar
                VStack(alignment: .leading) {
                    Text("Goals Progress (This Month)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    let currentMonth = Date()
                    let totalGoalsThisMonth = viewModel.goalsPerMonth(for: currentMonth)
                    let goalsMetThisMonth = viewModel.goalsMetPerMonth(for: currentMonth)
                    let monthlyProgress = totalGoalsThisMonth > 0 ? Double(goalsMetThisMonth) / Double(totalGoalsThisMonth) : 0

                    ProgressView(value: monthlyProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.horizontal)

                    HStack {
                        Text("Met: \(goalsMetThisMonth)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Total: \(totalGoalsThisMonth)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }

                //Year Goal Progression Bar
                VStack(alignment: .leading) {
                    Text("Goals Progress (This Year)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    let currentYear = Date()
                    let totalGoalsThisYear = viewModel.goalsPerYear(for: currentYear)
                    let goalsMetThisYear = viewModel.goalsMetPerYear(for: currentYear)
                    let yearlyProgress = totalGoalsThisYear > 0 ? Double(goalsMetThisYear) / Double(totalGoalsThisYear) : 0

                    ProgressView(value: yearlyProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .padding(.horizontal)

                    HStack {
                        Text("Met: \(goalsMetThisYear)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Total: \(totalGoalsThisYear)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }

                Spacer()
                
                //Goal List
                List {
                    ForEach(viewModel.goals) { goal in
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
                        .onTapGesture {
                            if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
                                viewModel.goals[index].isCompleted.toggle()
                                viewModel.saveGoals()
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
    }
}

#Preview {
    ContentView()
}
