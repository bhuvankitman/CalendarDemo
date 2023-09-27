import Foundation

struct CalendarViewModel {

  struct Week {
    let days: [Day]
  }

  let monthBackward: Int
  let monthForward: Int
  let events: [Event]

  private(set) var totalWeeks: [Week] = []
  private(set) var totalDays: [Day] = []
  private(set) var totalMonths: [Month] = []

  private let totalDaysInWeek: Int = 7
  private var calendar: Calendar = .current


  init(monthBackward: Int, monthForward: Int, events: [Event]) {
    self.monthBackward = monthBackward
    self.monthForward = monthForward
    self.events = events

    calendar = makeCalendar()
    totalWeeks = getTotalWeeks()
    totalDays = totalWeeks.flatMap(\.days)
    totalMonths = getMonths()
  }
}

// MARK: - Weeks Helpers
extension CalendarViewModel {
  private func getTotalWeeks() -> [Week] {
    guard
      let minDate = calendar.date(byAdding: .month, value: -monthBackward, to: .now),
      let maxDate = calendar.date(byAdding: .month, value: monthForward, to: .now)
    else {
      return []
    }

    var weeks = [Week]()
    for date in getDatesBetween(minDate: minDate, maxDate: maxDate) {
      let weeklyDates = getWeeklyDays(date: date)
      // FIXME: - Delete sample events
      let events = Array([Event].sampleEvents[0..<2])
      let days: [Day] = weeklyDates.map { .init(day: $0.dayString, date: $0, events: events) }
      weeks.append(.init(days: days))
    }
    return weeks
  }

  private func getDatesBetween(minDate: Date, maxDate: Date) -> [Date] {
    var dates: [Date] = []
    var date = minDate

    while date <= maxDate {
      dates.append(date)
      guard let newDate = calendar.date(byAdding: .day, value: totalDaysInWeek, to: date) else { break }
      date = newDate
    }
    return dates
  }

  private func getWeeklyDays(date: Date) -> [Date] {
    guard let weekRange = calendar.range(of: .weekday, in: .weekOfYear, for: date) else {
      return []
    }
    let dayOfWeek = calendar.component(.weekday, from: date)
    return weekRange.compactMap { calendar.date(byAdding: .day,
                                                value: $0 - dayOfWeek,
                                                to: date) }
  }

  func todaysWeekPage() -> CGFloat {
    var page = 0
    for (index, week) in totalWeeks.enumerated() {
      if week.days.contains(where: { calendar.isDate($0.date, equalTo: .now, toGranularity: .day) }) {
        page = index
        break
      }
    }
    return CGFloat(page)
  }
}

// MARK: - Calendar
extension CalendarViewModel {
  private func makeCalendar() -> Calendar {
    var calendar = Calendar.current
    calendar.locale = .current
    return calendar
  }
}

// MARK: - Month Helpers
extension CalendarViewModel {

  func monthFor(date: Date) -> Int {
    calendar.dateComponents([.month], from: date).month!
  }

  func dateFor(month: Int) -> Date {
    calendar.date(from: .init(month: month))!
  }

  private func getMonths() -> [Month] {
    guard
      let startDate = totalDays.first?.date,
      let endDate = totalDays.last?.date
    else {
      return []
    }

    let startMonth = monthFor(date: startDate)
    let endMonth = monthFor(date: endDate)

    var index = 0
    var months = [Month]()
    for month in startMonth...endMonth {
      months.append(.init(id: index,
                          title: calendar.monthSymbols[month - 1],
                          days: monthDaysFor(date: dateFor(month: month))))
      index += 1
    }

    return months
  }

  func monthDaysFor(date: Date) -> [Day] {

    var days = [Day]()

    let daysInMonth = date.daysInMonth
    let firstDayOfMonth = date.firstOfMonth
    let startingSpaces = firstDayOfMonth.weekDay

    var count: Int = 1

    let monthYear = date.monthString + " " + date.yearString

    while(count <= 42) {
      if count <= startingSpaces || count - startingSpaces > daysInMonth {
        days.append(.init(day: ""))
      } else {
        let day = String(count - startingSpaces)
        let strDate = day + " " + monthYear
        days.append(.init(day: day, date: strDate.date))
      }
      count += 1
    }

    return days
  }
}
