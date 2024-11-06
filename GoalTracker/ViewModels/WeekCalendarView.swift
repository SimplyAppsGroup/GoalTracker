//
//  WeekCalendarView.swift
//  GoalTracker
//
//  Created by Desiree on 11/5/24.
//

import SwiftUI

struct WeekCalendarView: View {
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(width: 40, height: 40)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.top)
        }
    }
}
