//
//  JournalView.swift
//  BetterHours
//
//  Created by Junsu Song on 2023/12/13.
//

import SwiftUI


struct Reflection: Identifiable, Equatable {
  let id = UUID()
  var title: String
  var subtitle: String
  var color: Color
}

struct JournalView: View {
  @State private var reflections: [Reflection] = [
    Reflection(title: "오늘 회고", subtitle: "", color: .blue),
    Reflection(title: "가장 좋았던 일", subtitle: "", color: .red),
    Reflection(title: "스스로에게 한 마디", subtitle: "", color: .purple)
  ]
  @State private var selectedReflection: Reflection?

  var body: some View {
    ScrollView {
      VStack {
        ForEach($reflections.indices, id: \.self) { index in
          ReflectionCard(color: reflections[index].color, title: reflections[index].title, subtitle: reflections[index].subtitle)
            .onTapGesture {
              self.selectedReflection = reflections[index]
            }
        }
      }
    }
    .sheet(item: $selectedReflection) { reflection in
      EditorView(reflection: $reflections[reflections.firstIndex(where: { $0.id == reflection.id })!])
    }
    .navigationTitle("하루 기록")
  }
}

struct ReflectionCard: View {
  var color: Color
  var title: String
  var subtitle: String

  var body: some View {
    VStack(spacing: 5) {
      Text(title)
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .center)

      Text(subtitle)
        .font(.body)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(color)
    .cornerRadius(10)
  }
}

struct EditorView: View {
  @Binding var reflection: Reflection
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    VStack {
      TextEditor(text: $reflection.subtitle)
        .padding()
      Button("Save") {
        presentationMode.wrappedValue.dismiss()
      }
      .padding()
    }
  }
}
