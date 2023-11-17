//
//  DailyEventView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct DailyEventView: View {
  var body: some View {
    NavigationView {
      TimeEventView()
    }
    .navigationViewStyle(.stack)
  }
}
