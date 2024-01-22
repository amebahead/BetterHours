//
//  Journal.swift
//  BetterHours
//
//  Created by MacDole on 2023/12/18.
//

import Foundation

struct Journal: Identifiable, Equatable, Codable {
  var id = UUID()
  var index: Int
  var title: String
  var subtitle: String
  var subscription: String {
    if index == 0 {
      return "오늘 하루는 어땠나요?"
    } else if index == 1 {
      return "오늘 어떤일이 가장 좋았나요?"
    } else if index == 2 {
      return "오늘 나에게 하고 싶은 말이 있나요?"
    }
    return ""
  }

  init(index: Int, title: String, subtitle: String) {
    self.index = index
    self.title = title
    self.subtitle = subtitle
  }
}

struct JournalWithDate: Codable {
  var date: Date
  var journals: [Journal]
}
