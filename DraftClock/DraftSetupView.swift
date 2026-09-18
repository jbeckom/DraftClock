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
    @State private var teamNames = Array(repeating: "", count: 12)
    @State private var customizeRoundTimers = false
    @State private var roundTimerOverrides: [Int: Int] = [:]
    @State private var activeConfiguration: DraftConfiguration?
    @State private var showValidationErrors = false
    @State private var showingStartConfirmation = false
    @State private var pendingConfiguration: DraftConfiguration?
    
    private var normalizedTeamNames: [String] {
        teamNames.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private var hasBlankTeamNames: Bool {
        normalizedTeamNames.contains { $0.isEmpty }
    }
    
    private var hasDuplicateTeamNames: Bool {
        let names = normalizedTeamNames.map { $0.lowercased() }
        return Set(names).count != names.count
    }
    
    private var canStartDraft: Bool {
        !hasBlankTeamNames && !hasDuplicateTeamNames
    }
    
    var body: some View {
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
                if showValidationErrors && !canStartDraft {
                    VStack(spacing: 6) {
                        if hasBlankTeamNames {
                            Text("Each team must have a name.")
                        }
                        
                        if hasDuplicateTeamNames {
                            Text("Team names must be unique.")
                        }
                    }
                    .font(.callout)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                }
                
                Button("Start Draft") {
                    guard canStartDraft else {
                        showValidationErrors = true
                        return
                    }
                    
                    let trimmedName = draftName
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    pendingConfiguration = DraftConfiguration(
                        name: trimmedName.isEmpty ? nil : trimmedName,
                        teamNames: normalizedTeamNames,
                        numberOfRounds: numberOfRounds,
                        format: draftFormat,
                        defaultPickTime: defaultPickTime,
                        roundTimerOverrides: customizeRoundTimers
                            ? roundTimerOverrides
                            : [:]
                    )
                    
                    showingStartConfirmation = true
                    
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Draft Setup")
        .alert("Start Draft?", isPresented: $showingStartConfirmation) {
            Button("Cancel", role: .cancel) {
                pendingConfiguration = nil
            }
            
            Button("Start Draft") {
                guard let configuration = pendingConfiguration else {
                    return
                }
                
                activeConfiguration = configuration
                pendingConfiguration = nil
            }
        } message: {
            Text("Once the draft begins, setup cannot be changed without ending the draft.")
        }
        .toolbar{
            EditButton()
        }
        .navigationDestination(
            item: $activeConfiguration
        ) { configuration in
            ContentView(configuration: configuration)
        }
    }
    
    private func updateTeamCount() {
        if teamNames.count < numberOfTeams {
            teamNames.append(
                contentsOf: Array (
                    repeating: "",
                    count: numberOfTeams - teamNames.count
                )
            )
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
