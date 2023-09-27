import Foundation

struct CalendarViewModel {
  let monthBackward: Int
  let monthForward: Int
  let events: [Event]

  private let totalDaysInWeek: Int = 7

  func weeklyDays() -> [Day] {
    guard
      let minDate = Calendar.current.date(byAdding: .month, value: -monthBackward, to: .now),
      let maxDate = Calendar.current.date(byAdding: .month, value: monthForward, to: .now)
    else {
      return []
    }

    var totalDays = [Day]()
    for date in dates(from: minDate, to: maxDate) {
      let weeklyDates = date.weekDays()
      let randomIndex = Int.random(in: 0..<[Event].sampleEvents.count)
      let events = Array([Event].sampleEvents[0..<randomIndex])
      let days: [Day] = weeklyDates.map { .init(day: $0.dayString, date: $0, events: events) }
      totalDays.append(contentsOf: days)
    }
    return totalDays
  }

  private func dates(from fromDate: Date, to toDate: Date) -> [Date] {
    var dates: [Date] = []
    var date = fromDate

    while date <= toDate {
      dates.append(date)
      guard let newDate = Calendar.current.date(byAdding: .day, value: totalDaysInWeek, to: date) else { break }
      date = newDate
    }
    return dates
  }
}

fileprivate extension Date {
  func weekDays() -> [Date] {
    var calendar = Calendar.current
    calendar.locale = .current

    guard let weekRange = calendar.range(of: .weekday, in: .weekOfYear, for: self) else {
      return []
    }
    let dayOfWeek = calendar.component(.weekday, from: self)
    return weekRange.compactMap { calendar.date(byAdding: .day,
                                                value: $0 - dayOfWeek,
                                                to: self) }
  }
}
