//
//  DraftConfiguration.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/14/26.
//

struct DraftConfiguration {
    let name: String?
    let teamNames: [String]
    let numberOfRounds: Int
    let format: DraftFormat
    let defaultPickTime: Int
    let roundTimerOverrides: [Int: Int]
    
    var numberOfTeams: Int {
        teamNames.count
    }
    
    func pickTime(forRound round: Int) -> Int {
        roundTimerOverrides[round] ?? defaultPickTime
    }
}
