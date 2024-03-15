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
      return NSLocalizedString("howIsToday", comment: "")
    } else if index == 1 {
      return NSLocalizedString("whatIsTheBestThingForYouToday", comment: "")
    } else if index == 2 {
      return NSLocalizedString("whatDoIWantToSayToMeToday", comment: "")
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
