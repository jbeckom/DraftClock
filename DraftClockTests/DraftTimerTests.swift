//
//  DraftClockTests.swift
//  DraftClockTests
//
//  Created by Joshua Beckom on 9/13/26.
//

import Testing
@testable import DraftClock

@MainActor
struct DraftTimerTests {

    @Test
    func resetUserOriginalStartingTime() {
        let timer = DraftTimer(startingTime: 90)
        
        timer.reset()
        
        #expect(timer.startingTime == 90)
        #expect(timer.timeRemaining == 90)
        #expect(timer.isRunning == false)
        #expect(timer.isExpired == false)
    }
    
    @Test
    func resetCanChangeStartingTime() {
        let timer = DraftTimer(startingTime: 90)
        
        timer.reset(to: 120)
        
        #expect(timer.startingTime == 120)
        #expect(timer.timeRemaining == 120)
    }
    
    @Test
    func subsequentResetUsesUpdatedStartingTime() {
        let timer = DraftTimer(startingTime: 90)
        
        timer.reset(to: 120)
        timer.reset()
        
        #expect(timer.startingTime == 120)
        #expect(timer.timeRemaining == 120)
    }
    
    @Test
    func warningPeriodBeginsAtTenSeconds() {
        let timer = DraftTimer(startingTime: 10)
        
        #expect(timer.isWarningPeriod)
    }
    
    @Test
    func warningPeriodDoesNotBeginAboveTenSeconds() {
        let timer = DraftTimer(startingTime: 11)
        
        #expect(!timer.isWarningPeriod)
    }
    
    @Test
    func expiredTimerIsNotInWarningPeriod() {
        let timer = DraftTimer(startingTime: 0)
        
        #expect(!timer.isWarningPeriod)
    }

}
