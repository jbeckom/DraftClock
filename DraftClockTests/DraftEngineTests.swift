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
                numberOfTeams: 4,
                numberOfRounds: 3,
                format: .snake
            )
        )
        
        #expect(engine.currentRound == 1)
        #expect(engine.pickInRound == 1)
        #expect(engine.currentTeamNumber == 1)
        
        engine.advance()
        #expect(engine.currentTeamNumber == 2)
        
        engine.advance()
        #expect(engine.currentTeamNumber == 3)
        
        engine.advance()
        #expect(engine.currentTeamNumber == 4)
        
        engine.advance()
        
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 1)
        #expect(engine.currentTeamNumber == 4)
    }
    
    @Test
    func linearDraftKeepsSameOrderEachRound() {
        let engine = DraftEngine(
            configuration: DraftConfiguration(
                numberOfTeams: 4,
                numberOfRounds: 2,
                format: .linear
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
                numberOfTeams: 4,
                numberOfRounds: 3,
                format: .snake
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
                numberOfTeams: 4,
                numberOfRounds: 3,
                format: .snake
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
                numberOfTeams: 2,
                numberOfRounds: 2,
                format: .snake
            )
        )
        
        engine.advance()
        engine.advance()
        engine.advance()
        
        #expect(engine.isDraftComplete)
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 2)
        #expect(engine.currentTeamNumber == 1)
        
        engine.advance()
        
        #expect(engine.currentRound == 2)
        #expect(engine.pickInRound == 2)
    }
}
