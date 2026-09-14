//
//  ContentView.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/13/26.
//

import SwiftUI
//internal import Combine

struct ContentView: View {
    @State private var draftTimer = DraftTimer()
    @State private var alertFeedback = AlertFeedback()
    
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
            
            Text(draftTimer.formattedTime)
                .font(.system(size: 96, weight: .bold, design: .monospaced))
                .foregroundStyle(draftTimer.isExpired ? .red : .primary)
            
            if draftTimer.isExpired {
                Text ("TIME EXPIRED")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }
            
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
                Button(draftTimer.isRunning ? "Pause Timer" : "Start Timer") {
                    draftTimer.toggle()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset Timer") {
                    draftTimer.reset()
                }
                .buttonStyle(.bordered)
            }
            
        }
        .padding(40)
        .onChange(of: draftTimer.isExpired) { _, isExpired in
            if isExpired {
                alertFeedback.triggerExpirationFeedback()
            }
        }
    }
}


#Preview {
    ContentView()
}
