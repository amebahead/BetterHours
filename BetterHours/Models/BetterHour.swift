//
//  BetterHour.swift
//  BetterHours
//
//  Created by Junsu Song on 2023/10/24.
//

import Foundation

struct BetterHour: Codable {
  var date: Date
  var eventIdenty: [EventIdenty]

  init() {
    self.date = Date()
    self.eventIdenty = [EventIdenty]()
  }
}
