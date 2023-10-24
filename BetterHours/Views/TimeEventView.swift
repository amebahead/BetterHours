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

  @State private var eventIdentys: [EventIdenty] = []

  let hourHeight: CGFloat = 50.0
  let lineHeight: CGFloat = 1.0

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
              Color.gray
                .frame(height: lineHeight)
                .opacity(0.4)

              HStack {
                Text("\(hour):00")
                  .font(.caption)
                  .frame(width: 35, alignment: .trailing)

                Color.gray
                  .frame(height: lineHeight)
                  .opacity(0.0)
              }
              .frame(height: hourHeight)
              .background(Color(UIColor.systemBackground))
              .onTapGesture {
                print("blankCell")
                print(selectedId)
                selectedId = hour
                isPresentingEventPickerView = true
              }
            }
          }

          ForEach(eventIdentys) { eventIdenty in
            eventCell(eventIdenty)
              .onTapGesture {
                print("eventCell")
                selectedId = eventIdenty.id
                isPresentingEventPickerView = true
                print(selectedId)
              }
          }
        }
      }
    }
    .padding()
    .sheet(isPresented: $isPresentingEventPickerView) {
      EventPickerView(eventIdentys: $eventIdentys, selectedId: $selectedId, isPresentingEventPickerView: $isPresentingEventPickerView)
    }
    .onAppear {
      eventIdentys = readEventIdentys()
      print(eventIdentys)
    }
  }

  func eventCell(_ eventIdenty: EventIdenty) -> some View {
    let id = CGFloat(eventIdenty.id)
    let lineHeight = id + 1
    let offset = (id * hourHeight) + lineHeight - 25.0

    return VStack(alignment: .leading, spacing: 10.0) {
      Text(eventIdenty.event.category?.title ?? "").bold()
      Text(eventIdenty.event.detail ?? "")
    }
    .font(.caption)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(4)
    .frame(height: hourHeight, alignment: .top)
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

func readEventIdentys() -> [EventIdenty] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "eventIdentys") as? Data {
    if let eventIdentys = try? JSONDecoder().decode([EventIdenty].self, from: data) {
      print(eventIdentys)
      return eventIdentys
    }
  }
  return []
}

func saveEventIdentys(eventIdentys: [EventIdenty]) {
  let defaults = UserDefaults.standard
  // Remove
  defaults.removeObject(forKey: "eventIdentys")

  // Add
  if let encodedEvents = try? JSONEncoder().encode(eventIdentys) {
    defaults.setValue(encodedEvents, forKey: "eventIdentys")
  }
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

func saveEvents(events: [Event]) {
  let defaults = UserDefaults.standard
  // Remove
  defaults.removeObject(forKey: "events")

  // Add
  if let encodedEvents = try? JSONEncoder().encode(events) {
    defaults.setValue(encodedEvents, forKey: "events")
  }
}
