//
//  EventType.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

enum Category: String, CaseIterable, Identifiable, Codable {
  case work = "업무"
  case study = "학습"
  case lecture = "강의"
  case meeting = "모임"
  case exercise = "운동"
  case living = "생활"

  var title: String {
    rawValue
  }

  var id: String {
    title
  }

  var color: Color {
    switch self {
    case .work:
      return .blue
    case .study:
      return .brown
    case .lecture:
      return .cyan
    case .meeting:
      return .gray
    case .exercise:
      return .indigo
    case .living:
      return .orange
    }
  }
}
