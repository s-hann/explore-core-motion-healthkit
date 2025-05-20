//
//  MetricsData.swift
//  ExploreWatchCompanionApp
//
//  Created by Hanna Nadia Savira on 15/05/25.
//

import SwiftUICore

struct MetricsData: View {
    let symbol: String
    let text: String
    let measurement: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.system(size: 32))
                .frame(width: 32, height: 32)
            HStack {
                Text(text)
                    .font(.system(size: 24, weight: .bold))
                Text(measurement)
                    .textCase(.uppercase)
                    .padding(.top, 4)
            }
        }
    }
}
