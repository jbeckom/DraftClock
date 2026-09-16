//
//  DraftTimer.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/13/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class DraftTimer {
    private(set) var timeRemaining: Int
    private(set) var isRunning = false
    private(set) var isExpired = false
    private(set) var startingTime: Int
    
    private var endDate: Date?
    private var tickerTask: Task<Void, Never>?
    
    init(startingTime: Int = 90) {
        self.startingTime = startingTime
        self.timeRemaining = startingTime
    }
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func toggle() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }
    
    func start() {
        guard !isRunning, timeRemaining > 0 else {
            return
        }
        
        isExpired = false
        isRunning = true
        
        endDate = Date().addingTimeInterval(
            TimeInterval(timeRemaining)
        )
        
        startTicker()
        updateRemainingTime()
    }
    
    func pause() {
        guard isRunning else {
            return
        }
        
        updateRemainingTime()
        
        isRunning = false
        endDate = nil
        
        stopTicker()
    }
    
    func reset(to newStartingTime: Int? = nil) {
        stopTicker()
        
        if let newStartingTime {
            startingTime = newStartingTime
        }
        
        isRunning = false
        isExpired = false
        endDate = nil
        timeRemaining = startingTime
    }
    
    private func startTicker() {
        stopTicker()
        
        tickerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(250))
                
                guard !Task.isCancelled else {
                    return
                }
                
                self?.updateRemainingTime()
            }
        }
    }
    
    private func stopTicker() {
        tickerTask?.cancel()
        tickerTask = nil
    }
    
    private func updateRemainingTime() {
        guard isRunning, let endDate else {
            return
        }
        
        let remaining = max(
            0,
            Int(ceil(endDate.timeIntervalSinceNow))
        )
        
        timeRemaining = remaining
        
        if remaining == 0 {
            isRunning = false
            isExpired = true
            self.endDate = nil
            stopTicker()
        }
    }
}
