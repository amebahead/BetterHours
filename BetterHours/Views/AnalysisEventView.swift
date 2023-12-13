//
//  AnalysisEventView.swift
//  BetterHours
//
//  Created by Junsu Song on 2023/12/06.
//

import SwiftUI

struct AnalysisEventView: View {
  @Binding var analysisEvents: [(String, String, Color)]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .center, spacing: 20) {
        // Header
        VStack {
          let total = self.analysisEvents.reduce(0, { partialResult, event in
            partialResult + (Int(event.1) ?? 0)
          })

          Text("\(total)h")
            .font(.caption)
            .bold()
          Text(" /24")
            .font(.caption)
            .bold()
        }
        // Contents
        ForEach(analysisEvents, id: \.self.0) { event in
          VStack {
            HStack {
              Circle()
                .fill(event.2)
                .frame(width: 20, height: 20)
              Text("\(event.1)h")
                .font(.caption)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
            }
            HStack {
              Text(event.0)
                .font(.caption2)
              Spacer()
            }
          }
        }
      }
      .padding()
    }
  }
}
