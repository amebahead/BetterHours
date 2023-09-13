//
//  DailyEventView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct DailyEventView: View {

  var body: some View {
    NavigationStack {
      TimeEventView()
        .toolbar {
          NavigationLink(destination: SettingsView()) {
            Button(action: {
              print("edit")
            }) {
              Image(systemName: "gearshape")
            }
            .accessibilityLabel("Edit Settings")
          }
        }
    }
  }
}
