//
//  BetterHour.swift
//  BetterHours
//
//  Created by Junsu Song on 2023/10/24.
//

import Foundation

struct BetterHour: Codable {
  var date: Date
  var eventIdentys: [EventIdenty]

  init() {
    self.date = Date.today()
    self.eventIdentys = [EventIdenty]()
  }

  init(date: Date, eventIdentys: [EventIdenty]) {
    self.date = date
    self.eventIdentys = eventIdentys
  }
}
