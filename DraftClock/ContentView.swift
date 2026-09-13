//
//  ContentView.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/13/26.
//

import SwiftUI
internal import Combine

struct ContentView: View {
    @State private var timeRemaining = 90
    @State private var isRunning = false
    
    private let startingTime = 90
    
    var body: some View {
        VStack(spacing: 24) {
            Text("ROUND 1 · PICK 1")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Text("ON THE CLOCK")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("TEAM 1")
                .font(.system(size: 64, weight: .bold))
            
            Text(formattedTime)
                .font(.system(size: 96, weight: .bold, design: .monospaced))
            
            Text("Next: Team 2")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 24) {
                Button("Previous") {
                    // Add funtionality later
                }
                .buttonStyle(.bordered)
                
                Button("Pick Made") {
                    // Add functionality later
                }
                .buttonStyle(.borderedProminent)
               
            }
            
            HStack(spacing: 24) {
                Button(isRunning ? "Pause Timer" : "Start Timer") {
                    isRunning.toggle()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset Timer") {
                    resetTimer()
                }
                .buttonStyle(.bordered)
            }
            
        }
        .padding(40)
        .onReceive(
            Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        ) { _ in
            guard isRunning, timeRemaining > 0 else {
                return
            }
            
            timeRemaining -= 1
            
            if timeRemaining == 0 {
                isRunning = false
            }
            
        }
    }
    
    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func resetTimer() {
        timeRemaining = startingTime
        isRunning = false
    }
}

#Preview {
    ContentView()
}
