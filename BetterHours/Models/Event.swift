//
//  Event.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import Foundation

struct Event: Identifiable, Codable {
  var id = UUID()
  var category: Category?
  var detail: String?

  init(category: Category?, detail: String?) {
    self.category = category
    self.detail = detail
  }
}
