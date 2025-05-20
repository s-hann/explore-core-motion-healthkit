//
//  HomeView.swift
//  ExploreWatchCompanionApp Watch App
//
//  Created by Hanna Nadia Savira on 15/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var stepTrackerCM = StepTrackerCM()
    @State private var stepTrackerHK = StepTrackerHK()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Exploration App")
                .font(.headline)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Text("Core Motion")
                .font(.caption2)
            MetricsData(
                symbol: "figure.walk",
                text: "\(stepTrackerCM.totalSteps.formatted())",
                measurement: "steps"
            )
            Divider()
                .padding(.vertical)
            Text("HealthKit")
                .font(.caption2)
            if let error = stepTrackerHK.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                MetricsData(
                    symbol: "figure.walk",
                    text: "\(stepTrackerHK.steps.formatted())",
                    measurement: "steps"
                )
                MetricsData(
                    symbol: "heart.fill",
                    text: "\(136)",
                    measurement: "bpm"
                )
            }
            Spacer()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, 8)
        .task {
            stepTrackerHK.fetchHealthData()
        }
        .onAppear() {
            stepTrackerCM.fetchPreviousData()
            stepTrackerCM.startLiveStepUpdate()
        }
        .onDisappear() {
            stepTrackerCM.stopLiveUpdates()
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                stepTrackerCM.fetchPreviousData()
                stepTrackerCM.startLiveStepUpdate()
            } else if newValue == .background || newValue == .inactive {
                stepTrackerCM.stopLiveUpdates()
            }
        }
    }
}

#Preview {
    HomeView()
}
