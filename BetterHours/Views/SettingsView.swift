//
//  SettingsView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct SettingsView: View {
  @State private var selectedCategory = Category.work
  @State private var detail = ""

  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ZStack {
      Form {
        // 카테고리 선택 Picker
        Picker("카테고리", selection: $selectedCategory) {
          ForEach(Category.allCases) { category in
            Text(category.rawValue).tag(category)
          }
        }

        // 상세 내용 입력 TextEditor
        TextEditor(text: $detail)
          .frame(height: 200)
          .padding(4)
          .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
      }
      .navigationBarItems(trailing: Button("저장") {
        guard !detail.isEmpty else { return }
        var events = readEvents()
        events.append(Event(category: selectedCategory, detail: detail))

        saveEvents(events: events)
        self.presentationMode.wrappedValue.dismiss()
      })
    }
  }
}
