//
//  SettingsView.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

struct SettingsView: View {
  
  var body: some View {
    VStack {
      // 이메일 정보 표시
      Text(UserDefaults.standard.string(forKey: "UserEmail") ?? "")
        .foregroundStyle(.primary)
        .padding()

      // 백업하기 버튼
      Button(action: {
        print("백업하기 클릭됨")
        // 여기에 실제 백업 로직 구현
      }) {
        Text("백업하기")
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .cornerRadius(10)
      }
      .padding(.horizontal)

      // 복원하기 버튼
      Button(action: {
        print("복원하기 클릭됨")
        // 여기에 실제 복원 로직 구현
      }) {
        Text("복원하기")
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.green)
          .cornerRadius(10)
      }
      .padding(.horizontal)

      Spacer()
    }
    .padding()
  }
}
