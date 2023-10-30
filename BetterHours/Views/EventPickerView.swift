//
//  EventPickerView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

let sampleItems = [
  Event(category: .work, detail: "일과 관련된 내용입니다."),
  Event(category: .lecture, detail: "학습에 대한 설명입니다."),
  Event(category: .exercise, detail: "운동 정보입니다."),
  Event(category: .study, detail: "독서 내용입니다."),
  Event(category: .living, detail: "생활 팁입니다.")
]

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
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(events) { event in
          VStack(alignment: .leading) {
            Text(event.category?.title ?? "")
              .font(.headline)
            Text(event.detail ?? "")
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
          .padding()
          .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
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

            // FIXME: Userdefaults set이 안정적이지가 않음.. 고칠 필요가 있을듯
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
              isPresentingEventPickerView = false
            }
          }
        }
      }
      .padding()
    }
    .onAppear {
      events = readEvents() + sampleItems
    }
  }
}
