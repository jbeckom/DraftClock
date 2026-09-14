//
//  DraftEngineTests.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/14/26.
//

import Testing
@testable import DraftClock

@MainActor
struct DraftEngineTests {
    
    @Test
    func snakeDraftAdvancesCorrectly() {
        let engine = DraftEngine(
            configuration: DraftConfiguration(
                name: nil,
                teamNames: ["Team 1", "Team 2", "Team 3", "Team 4"],
                numberOfRounds: 3,
                format: .snake,
                defaultPickTime: 90,
                roundTimerOverrides: [:]
            )
        )
        
        #expect(engine.currentRound == 1)
        #expect(engine.pickInRound == 1)
        #expect(engine.currentTeamNumber == 1)
        #expect(engine.currentTeamName == "Team 1")
        #expect(engine.nextTeamName == "Team 2")
        
        engine.advance()
        #expect(engine.currentTeamNumber == 2)
        #expect(engine.currentTeamName == "Team 2")
        #expect(engine.nextTeamName == "Team 3")
        
        engine.advance()
        #expect(engine.currentTeamNumber == 3)
        #expect(engine.currentTeamName == "Team 3")
        #expect(engine.nextTeamName == "Team 4")
        
        engine.advance()
        #expect(engine.currentTeamNumber == 4)
        #expect(engine.currentTeamName == "Team 4")
        #expect(engine.nextTeamName == "Team 4")
        
        engine.advance()
        
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 1)
        #expect(engine.currentTeamNumber == 4)
        #expect(engine.currentTeamName == "Team 4")
        #expect(engine.nextTeamName == "Team 3")
    }
    
    @Test
    func linearDraftKeepsSameOrderEachRound() {
        let engine = DraftEngine(
            configuration: DraftConfiguration(
                name: nil,
                teamNames: ["Team 1", "Team 2", "Team 3", "Team 4"],
                numberOfRounds: 3,
                format: .linear,
                defaultPickTime: 90,
                roundTimerOverrides: [:]
            )
        )
        
        engine.advance()
        engine.advance()
        engine.advance()
        engine.advance()
        
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 1)
        #expect(engine.currentTeamNumber == 1)
    }
    
    @Test
    func previousMovesAcrossRoundBoundary() {
        let engine = DraftEngine(
            configuration: DraftConfiguration(
                name: nil,
                teamNames: ["Team 1", "Team 2", "Team 3", "Team 4"],
                numberOfRounds: 3,
                format: .snake,
                defaultPickTime: 90,
                roundTimerOverrides: [:]
            )
        )
        
        for _ in 0..<4 {
            engine.advance()
        }
        
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 1)
        #expect(engine.currentTeamNumber == 4)
        
        engine.goBack()
        
        #expect(engine.currentRound == 1)
        #expect(engine.pickInRound == 4)
        #expect(engine.currentTeamNumber == 4)
    }
    
    @Test
    func cannotGoBackBeforeFirstPick() {
        let engine = DraftEngine(
            configuration: DraftConfiguration(
                name: nil,
                teamNames: ["Team 1", "Team 2", "Team 3", "Team 4"],
                numberOfRounds: 3,
                format: .snake,
                defaultPickTime: 90,
                roundTimerOverrides: [:]
            )
        )
        
        engine.goBack()
        
        #expect(engine.currentRound == 1)
        #expect(engine.pickInRound == 1)
        #expect(engine.currentTeamNumber == 1)
    }
    
    @Test
    func draftStopsAtFinalPick() {
        let engine = DraftEngine(
            configuration: DraftConfiguration(
                name: nil,
                teamNames: ["Team 1", "Team 2"],
                numberOfRounds: 2,
                format: .snake,
                defaultPickTime: 90,
                roundTimerOverrides: [:]
            )
        )
        
        engine.advance()
        engine.advance()
        engine.advance()
        
        #expect(engine.isDraftComplete)
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 2)
        #expect(engine.currentTeamNumber == 1)
        #expect(engine.nextTeamName == nil)
        
        engine.advance()
        
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 2)
    }
    
    @Test
    func roundTimerUsesOverrideWhenAvailable() {
        let configuration = DraftConfiguration(
            name: nil,
            teamNames: ["Team 1", "Team 2"],
            numberOfRounds: 3,
            format: .snake,
            defaultPickTime: 90,
            roundTimerOverrides: [
                1: 120,
                3: 60
            ]
        )
        
        #expect(configuration.pickTime(forRound: 1) == 120)
        #expect(configuration.pickTime(forRound: 2) == 90)
        #expect(configuration.pickTime(forRound: 3) == 60)
    }
}
