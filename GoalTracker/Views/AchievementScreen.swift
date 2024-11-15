//
//  AchievementView.swift
//  GoalTracker
//
//  Created by Christina Gonzalez on 11/13/24.
//

import SwiftUI

struct AchievementScreen: View {
    @ObservedObject var viewModel: GoalViewModel

    var body: some View {
        VStack {
            Text("Achievements")
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .padding(.top, 20)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.achievements) { achievement in
                        AchievementRow(achievement: achievement)
                    }
                }
                .padding(.horizontal)
                .background(
                    Color(red: 20/255, green: 25/255, blue: 40/255)
                        .cornerRadius(15)
                )
                .padding(.top, 10)
            }
        }
        .background(
            Color(red: 20/255, green: 25/255, blue: 40/255).edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            viewModel.updateAchievements()
        }
        .navigationBarHidden(true)
        .toolbarBackground(Color(red: 20/255, green: 25/255, blue: 40/255), for: .navigationBar)
    }
}

struct AchievementRow: View {
    var achievement: Achievement

    var body: some View {
        HStack {
            Image(systemName: achievement.icon)
                .font(.system(size: 30))
                .frame(width: 50, height: 50)
                .foregroundColor(achievement.isUnlocked ? .green : .red)
                .background(achievement.isUnlocked ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .clipShape(Circle())
                .padding(.trailing, 15)

            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(achievement.isUnlocked ? "Unlocked" : "Locked")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(achievement.isUnlocked ? .blue : .red)
                .padding(6)
                .background(achievement.isUnlocked ? Color.blue.opacity(0.2) : Color.red.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(achievement.isUnlocked ? Color.green.opacity(0.2) : Color.gray.opacity(0.3)) 
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .padding(.vertical, 5)
    }
}


