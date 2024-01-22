//
//  EditorView.swift
//  BetterHours
//
//  Created by Junsu Song on 2024/01/22.
//

import SwiftUI

struct EditorView: View {
  enum FocusField {
    case field
  }

  @State var selectedDate: Date
  @Binding var journal: Journal
  @Environment(\.presentationMode) var presentationMode
  @FocusState var focusedField: FocusField?

  var body: some View {
    NavigationView {
      VStack {
        TextEditor(text: $journal.subtitle)
          .focused($focusedField, equals: .field)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              self.focusedField = .field
            }
          }
          .padding()

        Button("저장하기") {
          presentationMode.wrappedValue.dismiss()
        }
        .padding()
      }
      .navigationTitle(journal.subscription)
      .navigationBarTitleDisplayMode(.inline)
    }
    .onDisappear {
      let jounals = readJournals()
      var newJournals = jounals
      let newJournal = Journal(index: $journal.index.wrappedValue, title: $journal.title.wrappedValue, subtitle: $journal.subtitle.wrappedValue)

      for (index, jounal) in jounals.enumerated() {
        if areDatesOnSameDay(jounal.date, selectedDate) {
          var originJournals = jounal.journals
          originJournals[$journal.index.wrappedValue] = newJournal
          newJournals[index].journals = originJournals
          break
        }
      }

      saveJournal(journals: newJournals)
    }
  }
}

