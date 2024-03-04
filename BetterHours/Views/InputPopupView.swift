//
//  InputPopupView.swift
//  BetterHours
//
//  Created by Junsu Song on 2024/02/06.
//

import SwiftUI

struct InputPopupView: View {
  @State var inputText: String
  @Binding var isPresented: Bool

  var body: some View {
    VStack(spacing: 10) {
      TextField("이메일을 입력하세요", text: $inputText)
        .textFieldStyle(.plain)
        .padding()

      Button(action: {
        // 버튼 액션
        UserDefaults.standard.set(self.inputText, forKey: "UserEmail")
        isPresented = false
      }) {
        Text("register")
          .foregroundStyle(.primary)
          .padding()
          .frame(maxWidth: .infinity)
      }
      .background(Color.blue)
      .foregroundColor(.white)
      .padding()

      Spacer()
    }
    .padding()
  }
}
