//
//  TimeEventView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//


import SwiftUI

struct TimeEventView: View {
  @State private var isPresentingEventPickerView = false
  @State private var selectedId: Int = 0
  let today: Date = Date()

  @State private var events: [Event] = []

  let hourHeight = 50.0

  var body: some View {
    VStack(alignment: .leading) {

      // Date headline
      Text("Today")
        .bold()
        .font(.title)

      HStack {
        Text(today.formatted(.dateTime.year()))
        Text(today.formatted(.dateTime.day().month()))
      }

      ScrollView {
        ZStack(alignment: .topLeading) {
          VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<25) { hour in
              HStack {
                Text("\(hour):00")
                  .font(.caption)
                  .frame(width: 35, alignment: .trailing)
                Color.gray
                  .frame(height: 1)
                  .opacity(0.4)
              }
              .frame(height: hourHeight)
              .background(Color(UIColor.systemBackground))
              .onTapGesture {
                print("blankCell")
                selectedId = hour
                isPresentingEventPickerView = true
                print(selectedId)
              }
            }
          }

          ForEach(events) { event in
            eventCell(event)
              .onTapGesture {
                print("eventCell")
                selectedId = event.id
                isPresentingEventPickerView = true
                print(selectedId)
              }
          }
        }
      }
    }
    .padding()
    .sheet(isPresented: $isPresentingEventPickerView) {
      EventPickerView(events: $events, isPresentingEventPickerView: $isPresentingEventPickerView, selectedId: $selectedId)
    }
  }

  func eventCell(_ event: Event) -> some View {
    let duration = event.endDate.timeIntervalSince(event.startDate)
    let height = duration / 60 / 60 * hourHeight

    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: event.startDate)
    let offset = Double(hour) * (hourHeight)

    return VStack(alignment: .leading) {
      Text(event.eventType?.title ?? "").bold()
    }
    .font(.caption)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(4)
    .frame(height: height, alignment: .top)
    .background(
      RoundedRectangle(cornerRadius: 2)
        .fill(Color.random()).opacity(0.4)
    )
    .padding(.trailing, 30)
    .offset(x: 42, y: offset)

  }

}

func dateFrom(_ year: Int, _ month: Int, _ day: Int, _ hour: Int) -> Date {
  let calendar = Calendar.current
  let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: 0)
  return calendar.date(from: dateComponents) ?? .now
}

#Preview {
  TimeEventView()
}
