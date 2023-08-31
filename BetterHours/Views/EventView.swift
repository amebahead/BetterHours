//
//  EventView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct EventView: View {
  let eventType: EventType

  var body: some View {
    Text(eventType.title)
      .padding(4)
      .frame(maxWidth: .infinity, minHeight: 50)
      .foregroundStyle(.foreground)
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}

#Preview {
  EventView(eventType: .exercise)
}
