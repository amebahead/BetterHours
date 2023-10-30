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

  @State private var eventIdentys: [EventIdenty] = []

  @State private var isShowingDatePicker = false
  @State private var selectedDate = Date()


  let hourHeight: CGFloat = 50.0
  let lineHeight: CGFloat = 1.0

  var body: some View {
    VStack(alignment: .leading) {

      // Date Headline
      Button(action: {
        isShowingDatePicker.toggle()
      }, label: {
        VStack {
          Text("Today")
            .bold()
            .font(.title)

          HStack {
            Text(selectedDate.formatted(.dateTime.year()))
            Text(selectedDate.formatted(.dateTime.day().month()))
          }
        }
        .padding()
        .foregroundColor(.white)
      })

      if isShowingDatePicker {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
          .datePickerStyle(.wheel)
          .onChange(of: selectedDate) { newValue in
            isShowingDatePicker.toggle()
            
            let betterHours = readBetterHours()
            var this = [EventIdenty]()
            betterHours.forEach { betterHour in
              if areDatesOnSameDay(betterHour.date, newValue) {
                this = betterHour.eventIdentys
              }
            }
            eventIdentys = this
          }
      }

      ScrollView {
        ZStack(alignment: .topLeading) {
          VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<25) { hour in
              Color.gray
                .frame(height: lineHeight)
                .padding(EdgeInsets(top: 0.0, leading: 42.0, bottom: 0.0, trailing: 0.0))
                .opacity(0.4)

              HStack {
                VStack {
                  Text("\(hour):00")
                    .font(.caption)
                    .frame(width: 35, alignment: .trailing)

                  Spacer()
                }

                Color.gray
                  .frame(height: lineHeight)
                  .opacity(0.0)
              }
              .frame(height: hourHeight)
              .background(Color(UIColor.systemBackground))
              .onTapGesture {
                selectedId = hour
                isPresentingEventPickerView = true
              }
            }
          }

          ForEach(eventIdentys) { eventIdenty in
            eventCell(eventIdenty)
              .onTapGesture {
                selectedId = eventIdenty.id
                isPresentingEventPickerView = true
              }
          }
        }
      }
    }
    .padding()
    .sheet(isPresented: $isPresentingEventPickerView) {
      EventPickerView(eventIdentys: $eventIdentys, selectedId: $selectedId, selectedDate: $selectedDate, isPresentingEventPickerView: $isPresentingEventPickerView)
    }
    .onAppear {
      let betterHours = readBetterHours()
      betterHours.forEach { betterHour in
        if areDatesOnSameDay(betterHour.date, selectedDate) {
          eventIdentys = betterHour.eventIdentys
          print(eventIdentys)
        }
      }
    }
  }

  func eventCell(_ eventIdenty: EventIdenty) -> some View {
    let id = CGFloat(eventIdenty.id)
    let lineHeight = id + 1
    let offset = (id * hourHeight) + lineHeight

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
func readBetterHours() -> [BetterHour] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "betterHours") as? Data {
    if let betterHours = try? JSONDecoder().decode([BetterHour].self, from: data) {
      return betterHours
    }
  }
  return []
}

func saveBetterHours(betterHours: [BetterHour]) {
  let defaults = UserDefaults.standard
  if let encoded = try? JSONEncoder().encode(betterHours) {
    defaults.set(encoded, forKey: "betterHours")
  }
}

func readEvents() -> [Event] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "events") as? Data {
    if let events = try? JSONDecoder().decode([Event].self, from: data) {
      return events
    }
  }
  return []
}

func saveEvents(events: [Event]) {
  let defaults = UserDefaults.standard
  if let encodedEvents = try? JSONEncoder().encode(events) {
    defaults.set(encodedEvents, forKey: "events")
  }
}
