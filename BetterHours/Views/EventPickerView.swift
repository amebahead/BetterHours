//
//  EventPickerView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct EventPickerView: View {
  @Binding var events: [Event]
  @Binding var isPresentingEventPickerView: Bool
  @Binding var selectedId: Int

  let eventTypes = EventType.allCases

  var body: some View {
    VStack {
      ForEach(eventTypes, id: \.self) { eventType in
        EventView(eventType: eventType)
          .padding(8)
          .onTapGesture {
            isPresentingEventPickerView = false

            var existIndex: Int? = nil
            for (index, event) in events.enumerated() {
              if event.id == selectedId {
                existIndex = index
                break
              }
            }

            if let index = existIndex {
              events.remove(at: index)
            }

            events.append(Event(id: selectedId, startDate: dateFrom(hour: selectedId), endDate: dateFrom(hour: selectedId+1), eventType: eventType.title))

            // Saved UserDefaults
            saveEvent(events: events)
          }
      }
    }
  }
}
