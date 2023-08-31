//
//  EventPickerView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct EventPickerView: View {
  @Binding var selection: EventType?
  @Binding var isPresentingEventPickerView: Bool

  let events = EventType.allCases

  var body: some View {
    List(events) { event in
      EventView(eventType: event)
        .onTapGesture {
          isPresentingEventPickerView = false
          selection = event
        }
    }
    .listStyle(.plain)
  }
}

#Preview {
  EventPickerView(selection: .constant(.exercise), isPresentingEventPickerView: .constant(false))
}
