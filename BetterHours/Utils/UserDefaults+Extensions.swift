//
//  UserDefaults+Extensions.swift
//  BetterHours
//
//  Created by MacDole on 2023/10/30.
//

import Foundation

// BetterHours
func readBetterHours() -> [BetterHour] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "betterHours") as? Data {
    if let betterHours = try? JSONDecoder().decode([BetterHour].self, from: data) {
      return betterHours
    }
  }
  return []
}

func saveBetterHours(betterHours: [BetterHour]) {
  let defaults = UserDefaults.standard
  if let encoded = try? JSONEncoder().encode(betterHours) {
    defaults.set(encoded, forKey: "betterHours")
  }
}

// Goals
func readGoals() -> [Goal] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "goals") as? Data {
    if let goals = try? JSONDecoder().decode([Goal].self, from: data) {
      return goals
    }
  }
  return []
}

func saveGoals(goals: [Goal]) {
  let defaults = UserDefaults.standard
  if let encoded = try? JSONEncoder().encode(goals) {
    defaults.set(encoded, forKey: "goals")
  }
}

// Events
func readEvents() -> [Event] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "events") as? Data {
    if let events = try? JSONDecoder().decode([Event].self, from: data) {
      return events
    }
  }
  return []
}

func saveEvents(events: [Event]) {
  let defaults = UserDefaults.standard
  if let encodedEvents = try? JSONEncoder().encode(events) {
    defaults.set(encodedEvents, forKey: "events")
  }
}

// Journals
func readJournals() -> [JournalWithDate] {
  let defaults = UserDefaults.standard
  if let data = defaults.object(forKey: "journals") as? Data {
    if let journals = try? JSONDecoder().decode([JournalWithDate].self, from: data) {
      return journals
    }
  }
  return []
}

func saveJournal(journals: [JournalWithDate]) {
  let defaults = UserDefaults.standard
  if let encodedJournals = try? JSONEncoder().encode(journals) {
    defaults.set(encodedJournals, forKey: "journals")
  }
}
