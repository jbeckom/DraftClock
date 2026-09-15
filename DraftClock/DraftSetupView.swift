//
//  DraftSetupView.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/14/26.
//

import SwiftUI

struct DraftSetupView: View {
    @State private var draftName = ""
    @State private var numberOfTeams = 12
    @State private var numberOfRounds = 16
    @State private var draftFormat: DraftFormat = .snake
    @State private var defaultPickTime = 90
    @State private var teamNames = (1...12).map { "Team \($0)" }
    @State private var customizeRoundTimers = false
    @State private var roundTimerOverrides: [Int: Int] = [:]
    @State private var activeConfiguration: DraftConfiguration?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Draft") {
                    TextField("Draft Name (Optional)", text: $draftName)
                    
                    Stepper(
                        "Teams: \(numberOfTeams)",
                        value: $numberOfTeams,
                        in: 2...32
                    )
                    .onChange(of: numberOfTeams) {
                        updateTeamCount()
                    }
                    
                    Stepper(
                        "Rounds: \(numberOfRounds)",
                        value: $numberOfRounds,
                        in: 1...50
                    )
                    .onChange(of: numberOfRounds) {
                        updateRoundCount()
                    }
                }
                
                Section("Draft Format") {
                    Picker("Format", selection: $draftFormat) {
                        Text("Snake")
                            .tag(DraftFormat.snake)
                        
                        Text("Linear")
                            .tag(DraftFormat.linear)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Draft Order") {
                    ForEach(teamNames.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                                .foregroundStyle(.secondary)
                                .frame(width: 30)
                            
                            TextField(
                                "Team \(index + 1)",
                                text: $teamNames[index]
                            )
                        }
                    }
                    .onMove { indicies, newOffset in
                        teamNames.move(
                            fromOffsets: indicies,
                            toOffset: newOffset
                        )
                    }
                }
                
                Section("Timer") {
                    Picker("Default Pick Time", selection: $defaultPickTime) {
                        Text("30 seconds").tag(30)
                        Text("45 seconds").tag(45)
                        Text("60 seconds").tag(60)
                        Text("90 seconds").tag(90)
                        Text("120 seconds").tag(120)
                    }
                    
                    Toggle(
                        "Customize Timers by Round",
                        isOn: $customizeRoundTimers
                    )
                    
                    if customizeRoundTimers {
                        Section("Round Timers") {
                            ForEach(1...numberOfRounds, id: \.self) { round in
                                Picker(
                                    "Round \(round)",
                                    selection: timerBinding(for: round)
                                ) {
                                    Text("30 seconds").tag(30)
                                    Text("45 seconds").tag(45)
                                    Text("60 seconds").tag(60)
                                    Text("90 seconds").tag(90)
                                    Text("120 seconds").tag(120)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button("Start Draft") {
                        let trimmedName = draftName
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        activeConfiguration = DraftConfiguration(
                            name: trimmedName.isEmpty ? nil : trimmedName,
                            teamNames: teamNames,
                            numberOfRounds: numberOfRounds,
                            format: draftFormat,
                            defaultPickTime: defaultPickTime,
                            roundTimerOverrides: customizeRoundTimers
                                ? roundTimerOverrides
                                : [:]
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Draft Setup")
            .toolbar{
                EditButton()
            }
            .navigationDestination(
                item: $activeConfiguration
            ) { configuration in
                ContentView(configuration: configuration)
            }
        }
    }
    
    private func updateTeamCount() {
        if teamNames.count < numberOfTeams {
            for teamNumber in (teamNames.count + 1)...numberOfTeams {
                teamNames.append("Team \(teamNumber)")
            }
        } else if teamNames.count > numberOfTeams {
            teamNames.removeLast(teamNames.count - numberOfTeams)
        }
    }
    
    private func updateRoundCount() {
        roundTimerOverrides = roundTimerOverrides.filter {
            $0.key <= numberOfRounds
        }
    }
    
    private func timerBinding(for round: Int) -> Binding<Int> {
        Binding(
            get: {
                roundTimerOverrides[round] ?? defaultPickTime
            },
            set: { newValue in
                if newValue == defaultPickTime {
                    roundTimerOverrides.removeValue(forKey: round)
                } else {
                    roundTimerOverrides[round] = newValue
                }
            }
        )
    }
}

#Preview {
    DraftSetupView()
}
