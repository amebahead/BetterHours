//
//  Date+Extensions.swift
//  BetterHours
//
//  Created by MacDole on 2023/10/30.
//

import Foundation

extension Date {
  static func today() -> Date {
    return Date()
  }

  func dateString(_ format: String) -> String {
    let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.timeZone = koreaTimeZone

    return formatter.string(from: self)
  }
}

func areDatesOnSameDay(_ date1: Date, _ date2: Date) -> Bool {
  let calendar = Calendar.current
  let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
  let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

  return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
}

func areDatesNotFutureDay(_ date1: Date, _ date2: Date) -> Bool {
  // 오늘이거나
  if areDatesOnSameDay(date1, date2) { return true }
  // 과거이거나
  if date1 < date2 { return true }

  // 아니면
  return false
}
