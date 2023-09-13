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
    .onAppear {
      events = readEvents()
      print(events)
    }
  }

  func eventCell(_ event: Event) -> some View {
    let duration = event.endDate.timeIntervalSince(event.startDate)
    let height = duration / 60 / 60 * hourHeight

    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: event.startDate)
    let offset = Double(hour) * (hourHeight)

    return VStack(alignment: .leading) {
      Text(event.eventType ?? "").bold()
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


// MARK: Functions
func dateFrom(hour: Int) -> Date {
  let calendar = Calendar.current
  let today = Date()
  let year = calendar.dateComponents([.year], from: today).year ?? 0
  let month = calendar.dateComponents([.month], from: today).month ?? 0
  let day = calendar.dateComponents([.day], from: today).day ?? 0
  let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: 0)
  return calendar.date(from: dateComponents) ?? .now
}

func dateFrom(_ year: Int, _ month: Int, _ day: Int, _ hour: Int) -> Date {
  let calendar = Calendar.current
  let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: 0)
  return calendar.date(from: dateComponents) ?? .now
}

func readEvents() -> [Event] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "events") as? Data {
    if let events = try? JSONDecoder().decode([Event].self, from: data) {
      print(events)
      return events
    }
  }
  return []
}

func saveEvent(events: [Event]) {
  let defaults = UserDefaults.standard
  // Remove
  defaults.removeObject(forKey: "events")

  // Add
  if let encodedEvents = try? JSONEncoder().encode(events) {
    defaults.setValue(encodedEvents, forKey: "events")
  }
}
