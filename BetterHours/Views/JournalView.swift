//
//  JournalView.swift
//  BetterHours
//
//  Created by Junsu Song on 2023/12/13.
//

import SwiftUI

struct JournalView: View {
  @State private var journals: [Journal] = []
  @State private var selectedjournal: Journal?
  @State internal var selectedDate: Date
  @Binding var analysisEvents: [(String, String, Color)]

  var body: some View {
    VStack {
      AnalysisEventView(analysisEvents: $analysisEvents)

      ScrollView {
        VStack {
          ForEach($journals.indices, id: \.self) { index in
            JournalCard(title: journals[index].title, subtitle: journals[index].subtitle, index: journals[index].index, subscription: journals[index].subscription)
              .onTapGesture {
                self.selectedjournal = journals[index]
              }
          }
        }
        .padding()
      }
    }
    .sheet(item: $selectedjournal) { journal in
      EditorView(selectedDate: selectedDate, journal: $journals[journals.firstIndex(where: { $0.id == journal.id })!])
    }
    .onAppear {
      let journals = readJournals()
      var this: [Journal] = [
        Journal(index: 0, title: "오늘 회고", subtitle: ""),
        Journal(index: 1, title: "가장 좋았던 일", subtitle: ""),
        Journal(index: 2, title: "스스로에게 한 마디", subtitle: "")
      ]

      if journals.isEmpty {
        let new = JournalWithDate(date: selectedDate, journals: this)
        var newJournals = journals
        newJournals.append(new)
        saveJournal(journals: newJournals)
      } else {
        var isNew = true
        journals.forEach { journal in
          if areDatesOnSameDay(journal.date, selectedDate) {
            this = journal.journals
            isNew = false
          }
        }
        if isNew {
          let new = JournalWithDate(date: selectedDate, journals: this)
          var newJournals = journals
          newJournals.append(new)
          saveJournal(journals: newJournals)
        }
      }
      self.journals = this
    }
    .navigationTitle("하루 기록")
  }
}

struct JournalCard: View {
  var title: String
  var subtitle: String
  var index: Int
  var subscription: String

  var body: some View {
    VStack(spacing: 5) {
      Text(title)
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)

      if subtitle.isEmpty {
        Text(subscription)
          .foregroundColor(.gray)
      } else {
        Text(subtitle)
          .font(.body)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.2))
    .cornerRadius(10)
  }
}
