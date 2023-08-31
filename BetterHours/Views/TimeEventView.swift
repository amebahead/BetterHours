//
//  TimeEventView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//


import SwiftUI

struct TimeEventView: View {
  @State private var isPresentingEventPickerView = false
  let today: Date = Date()

  @State private var events: [Event] = [
    Event(startDate: dateFrom(2023,8,31,0), endDate: dateFrom(2023,8,31,1), eventType: .exercise),
    Event(startDate: dateFrom(2023,8,31,3), endDate: dateFrom(2023,8,31,5), eventType: .freetime),
    Event(startDate: dateFrom(2023,8,31,6), endDate: dateFrom(2023,8,31,7), eventType: .lecture),
    Event(startDate: dateFrom(2023,8,31,12), endDate: dateFrom(2023,8,31,13), eventType: .meeting),
    Event(startDate: dateFrom(2023,8,31,18), endDate: dateFrom(2023,8,31,22), eventType: .study),
  ]

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
              .background(.black)
              .onTapGesture {
                isPresentingEventPickerView = true
                print("blankCell")
              }
            }
          }

          ForEach(events) { event in
            eventCell(event)
              .onTapGesture {
                isPresentingEventPickerView = true
                print("eventCell")
              }
          }
        }
      }
    }
    .padding()
    .sheet(isPresented: $isPresentingEventPickerView) {
      EventPickerView(selection: $events.first!.eventType, isPresentingEventPickerView: $isPresentingEventPickerView)
    }
  }

  func eventCell(_ event: Event) -> some View {
    let duration = event.endDate.timeIntervalSince(event.startDate)
    let height = duration / 60 / 60 * hourHeight

    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: event.startDate)
    let offset = Double(hour) * (hourHeight)
    //    print(hour, minute, Double(hour-7) + Double(minute)/60 )

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
    .offset(x: 42, y: offset + 24)

  }

}

func dateFrom(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int = 0) -> Date {
  let calendar = Calendar.current
  let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
  return calendar.date(from: dateComponents) ?? .now
}

#Preview {
  TimeEventView()
}

