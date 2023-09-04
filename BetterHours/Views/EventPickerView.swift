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

            var isExist = false
            for event in events {
              if event.id == selectedId {
                isExist = true
                break
              }
            }

            if isExist {
              events.remove(at: selectedId)
            }

            events.append(Event(id: selectedId, startDate: dateFrom(2023, 8, 31, selectedId), endDate: dateFrom(2023, 8, 31, selectedId+1), eventType: eventType))
          }
      }
    }
  }
}

//#Preview {
//  EventPickerView(selection: .constant(.exercise), isPresentingEventPickerView: .constant(false))
//}
