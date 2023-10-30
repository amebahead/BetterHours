//
//  Goal.swift
//  BetterHours
//
//  Created by MacDole on 2023/10/30.
//

import Foundation

struct Goal: Codable {
  var date: Date
  var text: String

  init() {
    self.date = Date()
    self.text = ""
  }

  init(date: Date, text: String) {
    self.date = date
    self.text = text
  }
}
