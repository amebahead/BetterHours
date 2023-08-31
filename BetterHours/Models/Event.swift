//
//  Event.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import Foundation

struct Event: Identifiable {
  let id = UUID()
  var startDate: Date
  var endDate: Date
  var eventType: EventType?

  init() {
    self.startDate = Date()
    self.endDate = Date()
    self.eventType = nil
  }

  init(startDate: Date, endDate: Date, eventType: EventType?) {
    self.startDate = startDate
    self.endDate = endDate
    self.eventType = eventType
  }
}
