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
  case exercise = "운동"
  case leisure = "여가"
  case living = "생활"
  case etc = "기타"
  case meeting = "모임"

  var title: String {
    rawValue
  }

  var id: String {
    title
  }

  var color: Color {
    switch self {
    case .work:
      return Color(hex: "#ff3b30")
    case .study:
      return Color(hex: "#ffcc00")
    case .exercise:
      return Color(hex: "#1ac759")
    case .leisure:
      return Color(hex: "#0176f7")
    case .living:
      return Color(hex: "#c077db")
    case .etc:
      return Color(hex: "#9d8563")
    case .meeting:
      return Color(hex: "#ff9500")
    }
  }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
