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
      .frame(maxWidth: .infinity, minHeight: 60)
      .foregroundStyle(.foreground)
      .background(Color(UIColor.lightGray).opacity(0.3))
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}
