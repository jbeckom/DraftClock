//
//  ContentView.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/13/26.
//

import SwiftUI

struct ContentView: View {
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
            
            Text("1:30")
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
            
            Button("Pause Timer") {
                // Add functionality later
            }
            .buttonStyle(.bordered)
        }
        .padding(40)
    }
}

#Preview {
    ContentView()
}
