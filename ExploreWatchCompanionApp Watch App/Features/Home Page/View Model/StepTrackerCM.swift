//
//  StepTrackerCM.swift
//  ExploreWatchCompanionApp
//
//  Created by Hanna Nadia Savira on 14/05/25.
//

import CoreMotion
import Foundation

@Observable
class StepTrackerCM {
    var initialSteps: Int = 0
    var liveSteps: Int = 0
    
    // local attributes
    private let pedometer = CMPedometer()
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        guard CMPedometer.isStepCountingAvailable() else { return }
    }
    
    var totalSteps: Int {
        return initialSteps + liveSteps
    }
    
    func fetchPreviousData() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let now = Date()
        
        pedometer.queryPedometerData(from: startOfToday, to: now) { [weak self] data, error in
            DispatchQueue.main.async {
                if let steps = data?.numberOfSteps.intValue {
                    self?.initialSteps = steps
                }
            }
        }
    }
    
    func startLiveStepUpdate() {
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            if let steps = data?.numberOfSteps {
                DispatchQueue.main.async {
                    self?.liveSteps = Int(truncating: steps)
                }
            }
        }
    }
    
    func stopLiveUpdates() {
        pedometer.stopUpdates()
    }
}
