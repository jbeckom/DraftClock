//
//  DraftEngine.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/14/26.
//

import Observation

@MainActor
@Observable
final class DraftEngine {
    private(set) var currentRound = 1
    private(set) var pickInRound = 1
    
    let configuration: DraftConfiguration
    
    init(configuration: DraftConfiguration) {
        self.configuration = configuration
    }
    
    var currentTeamNumber: Int {
        teamNumber(
            round: currentRound,
            pickInRound: pickInRound
        )
    }
    
    var nextTeamNumber: Int? {
        guard !isDraftComplete else {
            return nil
        }
        
        var nextRound = currentRound
        var nextPick = pickInRound + 1
        
        if nextPick > configuration.numberOfTeams {
            nextRound += 1
            nextPick = 1
        }
        
        guard nextRound <= configuration.numberOfRounds else {
            return nil
        }
        
        return teamNumber(
            round: nextRound,
            pickInRound: nextPick
        )
    }
    
    var isDraftComplete: Bool {
        currentRound == configuration.numberOfRounds &&
        pickInRound == configuration.numberOfTeams
    }
    
    var currentTeamName: String {
        configuration.teamNames[currentTeamNumber - 1]
    }
    
    var nextTeamName: String? {
        guard let nextTeamNumber else {
            return nil
        }
        
        return configuration.teamNames[nextTeamNumber - 1]
    }
    
    func advance() {
        guard !isDraftComplete else {
            return
        }
        
        if pickInRound < configuration.numberOfTeams {
            pickInRound += 1
        } else {
            currentRound += 1
            pickInRound = 1
        }
    }
    
    func goBack() {
        guard currentRound > 1 || pickInRound > 1 else {
            return
        }
        
        if pickInRound > 1 {
            pickInRound -= 1
        } else {
            currentRound -= 1
            pickInRound = configuration.numberOfTeams
        }
    }
    
    private func teamNumber(
        round: Int,
        pickInRound: Int
    ) -> Int {
        switch configuration.format {
        case .linear:
            return pickInRound
            
        case .snake:
            if round.isMultiple(of: 2) {
                return configuration.numberOfTeams - pickInRound + 1
            } else {
                return pickInRound
            }
        }
    }
}
