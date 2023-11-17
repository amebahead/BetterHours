//
//  EventPickerView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct EventPickerView: View {

  @Binding var eventIdentys: [EventIdenty]
  @Binding var selectedId: Int
  @Binding var selectedDate: Date
  @Binding var isPresentingEventPickerView: Bool

  @State private var events: [Event] = []

  // 그리드 레이아웃 설정
  var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

  var body: some View {
    ScrollView {
      VStack {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(events) { event in
            VStack(alignment: .leading) {
              Text(event.category?.title ?? "")
                .font(.headline)
              Text(event.detail ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 40)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(event.category?.color.opacity(0.8) ?? Color.gray))
            .onTapGesture {
              var existIndex: Int? = nil
              for (index, eventIdenty) in eventIdentys.enumerated() {
                if eventIdenty.id == selectedId {
                  existIndex = index
                  break
                }
              }
              if let index = existIndex {
                eventIdentys.remove(at: index)
              }
              eventIdentys.append(EventIdenty(id: selectedId, event: event))

              // Saved UserDefaults
              save()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                isPresentingEventPickerView = false
              }
            }
          }
        }
        .padding()
        
        Button {
          var existIndex: Int? = nil
          for (index, eventIdenty) in eventIdentys.enumerated() {
            if eventIdenty.id == selectedId {
              existIndex = index
              break
            }
          }
          if let index = existIndex {
            eventIdentys.remove(at: index)
            // Saved UserDefaults
            save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
              isPresentingEventPickerView = false
            }
          }
        } label: {
          Text("삭제")
            .font(.headline)
            .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 70)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.8))
        .padding()
      }
    }
    .onAppear {
      self.events = readEvents()
    }
  }

  private func save() {
    let betterHours = readBetterHours()
    var newBetterHours = betterHours
    let new = BetterHour(date: selectedDate, eventIdentys: eventIdentys)

    if betterHours.isEmpty {
      newBetterHours.append(new)
    } else {
      for i in 0..<betterHours.count {
        let betterHour = betterHours[i]
        if areDatesOnSameDay(betterHour.date, selectedDate) {
          newBetterHours.remove(at: i)
        }
      }
      newBetterHours.append(new)
    }

    saveBetterHours(betterHours: newBetterHours)
  }
}
