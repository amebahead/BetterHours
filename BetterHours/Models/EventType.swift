//
//  EventType.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

enum EventType: String, CaseIterable, Identifiable {
  case work = "업무"
  case study = "학습"
  case lecture = "강의"
  case meeting = "모임"
  case exercise = "운동"
  case reading = "독서"
  case freetime = "여가"
  case personal = "개인적 활동"

  var title: String {
    rawValue
  }

  var id: String {
    title
  }
}
