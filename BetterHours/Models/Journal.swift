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
