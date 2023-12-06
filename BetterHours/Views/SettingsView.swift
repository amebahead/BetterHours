//
//  SettingsView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct SettingsView: View {
  @State private var selectedCategory = Category.life
  @State private var detail = ""
  @State private var events: [Event] = []
  @FocusState private var isTextFieldFocused: Bool

  @Environment(\.presentationMode) var presentationMode

  // 그리드 레이아웃 설정
  var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

  var body: some View {
    ScrollView {
      VStack {
        Form {
          // 카테고리 선택 Picker
          Picker("카테고리", selection: $selectedCategory) {
            ForEach(Category.allCases) { category in
              Text(category.rawValue).tag(category)
            }
          }
          // 상세 내용 입력 TextEditor
          TextEditor(text: $detail)
            .frame(height: 200.0)
            .focused($isTextFieldFocused)
            .toolbar {
              ToolbarItem(placement: .keyboard) {
                Button("Done") {
                  isTextFieldFocused = false
                }
              }
            }
            .onChange(of: detail) { newValue in
              let isKorean = containsKorean(text: newValue)
              let limit = isKorean ? 40 : 80
              if newValue.count > limit {
                detail = String(newValue.prefix(limit))
              }
            }
        }
        .navigationBarItems(trailing: Button("저장") {
          guard !detail.isEmpty else { return }
          var events = readEvents()
          events.append(Event(category: selectedCategory, detail: detail))
          saveEvents(events: events)

          self.presentationMode.wrappedValue.dismiss()
        })
        .frame(minHeight: 350.0)

        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(events.indices, id: \.self) { index in
            VStack(alignment: .leading) {
              Text(events[index].category?.title ?? "")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: Alignment.center)
              Text(events[index].detail ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: Alignment.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(events[index].category?.color.opacity(0.8) ?? Color.gray))
            .contextMenu {
              Button(action: {
                events.remove(at: index)
                saveEvents(events: events)
              }, label: {
                Label("삭제", systemImage: "trash")
              })
            }
          }
        }
        .padding()
      }
    }
    .onAppear {
      events = readEvents()
    }
  }

  private func containsKorean(text: String) -> Bool {
    for char in text {
      if char.isKorean {
        return true
      }
    }
    return false
  }
}

extension Character {
  var isKorean: Bool {
    return "\u{AC00}" <= self && self <= "\u{D7A3}"
  }
}
