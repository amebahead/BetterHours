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
        ForEach(analysisEvents, id: \.self.0) { event in
          VStack {
            HStack {
              Circle()
                .fill(event.2)
                .frame(width: 20, height: 20)
              Text("\(event.1)h")
                .font(.caption)
                .bold()
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
