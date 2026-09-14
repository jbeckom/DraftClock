//
//  DraftConfiguration.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/14/26.
//

struct DraftConfiguration {
    let teamNames: [String]
    let numberOfRounds: Int
    let format: DraftFormat
    
    var numberOfTeams: Int {
        teamNames.count
    }
}
