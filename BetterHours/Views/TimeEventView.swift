//
//  TimeEventView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//


import SwiftUI

struct TimeEventView: View {
  @State private var isPresentingEventPickerView = false
  @State private var selectedId: Int = -1

  @State private var eventIdentys: [EventIdenty] = []
  @State private var analysisEvents: [(String, String, Color)] = []

  @State private var isShowingDatePicker = false
  @State private var selectedDate = Date()

  @State private var goal: String = ""
  @FocusState private var isTextFieldFocused: Bool

  let hourHeight: CGFloat = 50.0
  let lineHeight: CGFloat = 1.0

  var body: some View {
    VStack(alignment: .leading) {
      if isShowingDatePicker {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
          .datePickerStyle(.graphical)
          .accentColor(.red)
          .environment(\.locale, Locale.init(identifier: "ko_KR"))
          .onChange(of: selectedDate) { newValue in
            isShowingDatePicker.toggle()

            // Events
            let betterHours = readBetterHours()
            var this = [EventIdenty]()
            betterHours.forEach { betterHour in
              if areDatesOnSameDay(betterHour.date, newValue) {
                this = betterHour.eventIdentys
              }
            }
            eventIdentys = this

            // Goals
            getGoals()

            // Analysis
            setAnalysisEvent()
          }
      }

      // Analysis
      AnalysisEventView(analysisEvents: $analysisEvents)

      // HeadView
      if #available(iOS 16, *) {
        TextField("현재 목표", text: $goal, axis: .vertical)
          .padding()
          .font(.title3)
          .onChange(of: goal) { newValue in
            if goal.count >= 200 {
              goal = String(goal.prefix(200))
            }
          }
          .focused($isTextFieldFocused)
          .disabled(!areDatesOnSameDay(selectedDate, Date.today()))   // Policy: 현재 목표는 '오늘' 시점에만 입력 가능
          .toolbar {
            ToolbarItem(placement: .keyboard) {
              Button("Done") {
                isTextFieldFocused = false
                setGoals(goal)
              }
            }
          }
          .onSubmit {
            setGoals(goal)
          }
      } else {
        TextField("현재 목표", text: $goal)
          .padding()
          .font(.title3)
          .onChange(of: goal) { newValue in
            if goal.count >= 200 {
              goal = String(goal.prefix(200))
            }
          }
          .focused($isTextFieldFocused)
          .disabled(!areDatesOnSameDay(selectedDate, Date.today()))   // Policy: 현재 목표는 '오늘' 시점에만 입력 가능
          .toolbar {
            ToolbarItem(placement: .keyboard) {
              Button("Done") {
                isTextFieldFocused = false
                setGoals(goal)
              }
            }
          }
          .onSubmit {
            setGoals(goal)
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
    .sheet(isPresented: $isPresentingEventPickerView, onDismiss: {
      setAnalysisEvent()
    }) {
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
          Text("활동 카드 덱")
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
      getGoals()

      // Analysis
      setAnalysisEvent()
    }
  }
}


// MARK: Functions
extension TimeEventView {
  func eventCell(_ eventIdenty: EventIdenty) -> some View {
    let id = CGFloat(eventIdenty.id)
    let lineHeight = id + 1
    let offset = (id * hourHeight) + lineHeight

    return VStack(alignment: .leading, spacing: 10.0) {
      Text(eventIdenty.event.category?.title ?? "").bold()
      Text(eventIdenty.event.detail ?? "")
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
        .truncationMode(.tail)
    }
    .font(.caption)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(4)
    .frame(height: hourHeight, alignment: .top)
    .background(
      RoundedRectangle(cornerRadius: 2)
        .fill(eventIdenty.event.category?.color ?? .clear).opacity(0.8)
    )
    .padding(.trailing, 30)
    .offset(x: 42, y: offset)
  }

  func getGoals() {
    // clear
    self.goal = ""

    let goals = readGoals()
    var isSetGoal = false
    let sortedGoals = goals.sorted(by: { $0.date > $1.date })   // 내림차순

    for goal in sortedGoals {
      if areDatesOnSameDay(goal.date, selectedDate) {
        self.goal = goal.text
        isSetGoal = true
      }
    }

    if isSetGoal == false {
      switch selectedDate.compare(Date.today()) {
        // 미래
      case .orderedDescending:
        self.goal = goals.first?.text ?? ""
        break
        // 과거
      case .orderedAscending:
        self.goal = ""
        break
      case .orderedSame:
        break
      }
    }
  }

  func setGoals(_ goal: String) {
    let goals = readGoals()
    var newGoals = goals
    let new = Goal(date: Date.today(), text: goal)

    if goals.isEmpty {
      newGoals.append(new)
    } else {
      for i in 0 ..< goals.count {
        let goal = goals[i]
        if areDatesOnSameDay(goal.date, Date.today()) {
          newGoals.remove(at: i)
        }
      }
      newGoals.append(new)
    }
    saveGoals(goals: newGoals)
  }

  func setAnalysisEvent() {
    var life = 0
    var work = 0
    var learn = 0
    var exercise = 0
    var leisure = 0
    var meeting = 0
    var etc = 0
    var sleep = 0

    for eventIdenty in eventIdentys {
      switch eventIdenty.event.category {
      case .some(.life):
        life += 1
      case .some(.work):
        work += 1
      case .some(.learn):
        learn += 1
      case .some(.exercise):
        exercise += 1
      case .some(.leisure):
        leisure += 1
      case .some(.meeting):
        meeting += 1
      case .some(.etc):
        etc += 1
      case .some(.sleep):
        sleep += 1
      case .none:
        break
      }

      let events = [
        (Category.life.title, "\(life)", Category.life.color),
        (Category.work.title, "\(work)", Category.work.color),
        (Category.learn.title, "\(learn)", Category.learn.color),
        (Category.exercise.title, "\(exercise)", Category.exercise.color),
        (Category.leisure.title, "\(leisure)", Category.leisure.color),
        (Category.meeting.title, "\(meeting)", Category.meeting.color),
        (Category.etc.title, "\(etc)", Category.etc.color),
        (Category.sleep.title, "\(sleep)", Category.sleep.color)
      ]

      self.analysisEvents = events
    }
  }
}
