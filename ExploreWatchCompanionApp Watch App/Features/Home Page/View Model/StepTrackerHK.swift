//
//  StepTrackerHK.swift
//  ExploreWatchCompanionApp
//
//  Created by Hanna Nadia Savira on 15/05/25.
//

import Foundation
import HealthKit

@Observable
class StepTrackerHK {
    var heartRate: Double = 0
    var steps: Int = 0
    var error: Error?
    
    // local attributes
    private let healthStore = HKHealthStore()
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
//        let typesToShare: Set = [
//            HKQuantityType(.stepCount)
//        ]
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType(.heartRate),
            HKQuantityType(.stepCount)
        ]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if success {
                // fetch step data
            } else if let error = error {
                self.error = error
            }
        }
    }
    
    func fetchHealthData() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let now = Date()
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfToday,
            end: now,
            options: .strictStartDate
        )
        
        let queryStepCount = HKStatisticsQuery(
            quantityType: HKQuantityType(.stepCount),
            quantitySamplePredicate: predicate,
            options: [.cumulativeSum]) { query, statistics, error in
                guard let statistics = statistics else {
                    return
                }
                
                let sum = statistics.sumQuantity()
                let totalSteps = Int(sum?.doubleValue(for: .count()) ?? 0)
                print("HK sum: \(String(describing: sum))\nHK total steps: \(totalSteps)")
                
                DispatchQueue.main.async {
                    self.steps = totalSteps
                }
            }
        healthStore.execute(queryStepCount)
    }
    
    func updateStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType(.heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType(.stepCount):
                self.steps = Int(statistics.mostRecentQuantity()?.doubleValue(for: .count()) ?? 0)
            default:
                return
            }
        }
    }
}
