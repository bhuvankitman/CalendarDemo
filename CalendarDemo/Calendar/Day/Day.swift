import Foundation

struct Day {
  let day: String
  let date: Date
  let events: [Event]

  init(day: String, date: Date = .now, events: [Event] = []) {
    self.day = day
    self.date = date
    self.events = events
  }
}

extension Day {
  func isToday() -> Bool {
    Calendar.current.isDateInToday(date)
  }
}
