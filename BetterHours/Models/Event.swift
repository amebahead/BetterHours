//
//  Event.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import Foundation

struct Event: Identifiable {
  let id: Int
  var startDate: Date
  var endDate: Date
  var eventType: EventType?

  init() {
    self.id = 0
    self.startDate = Date()
    self.endDate = Date()
    self.eventType = nil
  }

  init(id: Int, startDate: Date, endDate: Date, eventType: EventType?) {
    self.id = id
    self.startDate = startDate
    self.endDate = endDate
    self.eventType = eventType
  }
}
