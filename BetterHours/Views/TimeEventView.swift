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

  @State private var goal: String = ""


  let hourHeight: CGFloat = 50.0
  let lineHeight: CGFloat = 1.0

  var body: some View {
    VStack(alignment: .leading) {
      if isShowingDatePicker {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
          .datePickerStyle(.graphical)
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

      // HeadView
      TextField("오늘의 목표", text: $goal)
        .padding()
        .font(.title3)
        .onChange(of: goal) { newValue in
          if goal.count >= 200 {
            goal = String(goal.prefix(200))
          }
        }
        .onSubmit {
          let newGoal = Goal(date: Date(), text: goal)
          var goals = readGoals()

          goals.append(newGoal)
          saveGoals(goals: goals)

          print(newGoal)
          print(goals)
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
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarLeading) {
        Button(action: {
          isShowingDatePicker.toggle()
        }, label: {
          let year = selectedDate.formatted(.dateTime.year())
          let day = selectedDate.formatted(.dateTime.day().month())
          Text("\(year) \(day)")
        })
      }
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        NavigationLink(destination: SettingsView()) {
          Text("Add Event")
        }
      }
    }
    .onAppear {
      // BetterHours
      let betterHours = readBetterHours()
      betterHours.forEach { betterHour in
        if areDatesOnSameDay(betterHour.date, selectedDate) {
          eventIdentys = betterHour.eventIdentys
          print(eventIdentys)
        }
      }

      // Goals
      var goals = readGoals()
      var isSetGoal = false
      goals.sort(by: { $0.date > $1.date })

      for goal in goals {
        let comparison = selectedDate.compare(goal.date)

        switch comparison {
        case .orderedSame, .orderedDescending:
          self.goal = goal.text
          isSetGoal = true
          break
        case .orderedAscending:
          break
        }

        if isSetGoal { break }
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

