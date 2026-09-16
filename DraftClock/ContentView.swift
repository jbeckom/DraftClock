//
//  ContentView.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/13/26.
//

import SwiftUI

struct ContentView: View {
    let configuration: DraftConfiguration
    
    @State private var draftEngine: DraftEngine
    @State private var draftTimer: DraftTimer
    @State private var alertFeedback = AlertFeedback()
    @State private var showingEndDraftConfirmation = false
    
    @Environment(\.dismiss) private var dismiss
    
    init(configuration: DraftConfiguration) {
        self.configuration = configuration
        
        _draftEngine = State(
            initialValue: DraftEngine(
                configuration: configuration
            )
        )
        
        _draftTimer = State(
            initialValue: DraftTimer(
                startingTime: configuration.pickTime(forRound: 1),
            )
        )
    }

    var body: some View {
        GeometryReader { geometry in
            if geometry.size.height < 500 {
                compactLayout
            } else {
                standardLayout
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(40)
        .onChange(of: draftTimer.isExpired) { _, isExpired in
            if isExpired {
                alertFeedback.triggerExpirationFeedback()
            }
        }
        .onChange(of: draftTimer.timeRemaining) {
            if draftTimer.isWarningPeriod {
                alertFeedback.triggerWarningFeedback()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("End Draft") {
                    showingEndDraftConfirmation = true
                }
            }
        }
        .alert("End Draft?", isPresented: $showingEndDraftConfirmation) {
            Button("Cancel", role: .cancel) {
                // Nothing at the moment
            }
            
            Button("End Draft", role: .destructive) {
                draftTimer.pause()
                dismiss()
            }
        } message: {
            Text("This will end the current draft and return to setup.")
        }
    }
    
    private var standardLayout: some View {
        VStack(spacing: 24) {
            draftStatus
            
            nextTeam
            
            HStack(spacing: 24) {
                previousButton
                pickMadeButton
            }
            
            HStack(spacing: 24) {
                timerToggleButton
                resetButton
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
    }
    
    private var compactLayout: some View {
        HStack(spacing: 40) {
            draftStatus
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 16) {
                nextTeam
                
                pickMadeButton
                previousButton
                timerToggleButton
                resetButton
            }
            .frame(minWidth: 100)
        }
    }
    
    private var draftStatus: some View {
        VStack(spacing: 24) {
            if let draftName = configuration.name {
                Text(draftName)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            Text("ROUND \(draftEngine.currentRound) · PICK \(draftEngine.pickInRound)")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Text("ON THE CLOCK")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(draftEngine.currentTeamName)
                .font(.system(size: 64, weight: .bold))
            
            Text(draftTimer.formattedTime)
                .font(.system(size: 120, weight: .bold, design: .monospaced))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundStyle(draftTimer.isWarningPeriod || draftTimer.isExpired ? .red : .primary)
                .animation(
                    .easeInOut(duration: 0.2),
                    value: draftTimer.timeRemaining
                )
                .opacity(
                    draftTimer.isWarningPeriod && draftTimer.timeRemaining.isMultiple(of: 2)
                    ? 0.35
                    : 1.0
                )
            
            if draftTimer.isExpired {
                Text ("TIME EXPIRED")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }
        }
    }
    
    private var nextTeam: some View {
        Group {
            if let nextTeamName = draftEngine.nextTeamName {
                Text("Next: \(nextTeamName)")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            } else {
                Text("Final Pick")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var previousButton: some View {
        Button("Previous") {
            draftEngine.goBack()
            
            let roundPickTime = configuration.pickTime(
                forRound: draftEngine.currentRound
            )

            draftTimer.reset(to: roundPickTime)
        }
        .buttonStyle(.bordered)
    }
    
    private var pickMadeButton: some View {
        Button("THE PICK IS IN!") {
            if draftEngine.isDraftComplete {
                draftTimer.pause()
            } else {
                draftEngine.advance()
                
                let roundPickTime = configuration.pickTime(
                    forRound: draftEngine.currentRound
                )
                
                draftTimer.reset(to: roundPickTime)
                draftTimer.start()
            }
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var timerToggleButton: some View {
        Button(draftTimer.isRunning ? "Pause Timer" : "Start Timer") {
            draftTimer.toggle()
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var resetButton: some View {
        Button("Reset Timer") {
            draftTimer.reset()
        }
        .buttonStyle(.bordered)
    }
}


#Preview {
    ContentView(
        configuration: DraftConfiguration(
            name: "Preview Draft",
            teamNames: [
                "Team 1",
                "Team 2",
                "Team 3",
                "Team 4",
            ],
            numberOfRounds: 3,
            format: .snake,
            defaultPickTime: 12,
            roundTimerOverrides: [:]
        )
        
    )
}
