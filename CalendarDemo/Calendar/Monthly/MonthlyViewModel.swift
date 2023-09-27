import Foundation


struct Month {
  let id: Int
  let title: String
  let days: [Day]
}

struct Day {
  let day: String
  let date: Date?
  let events: [Event]

  init(day: String, date: Date? = nil, events: [Event] = []) {
    self.day = day
    self.date = date
    self.events = events
  }

  func isToday() -> Bool {
    guard let date else { return false }
    return Calendar.current.isDateInToday(date)
  }
}

struct MonthlyViewModel {

  // MARK: - Properties
  var months: [Month] = []
  var nextIndex: Int {
    months.count > 0 ? months.count : 0
  }

  // MARK: - Initializer
  let selectedDate: Date

  init(selectedDate: Date, monthBackwards: Int, monthForwards: Int) {
    self.selectedDate = selectedDate

    // Past months
    months.append(contentsOf: getBackwardMonths(fromDate: selectedDate,
                                                monthBackwards: monthBackwards))

    // Month for the given date
    months.append(.init(id: nextIndex,
                        title: selectedDate.monthString,
                        days: getMonthDays(forDate: selectedDate)))

    // Future months
    months.append(contentsOf: getForwardMonths(fromDate: selectedDate,
                                               monthForwards: monthForwards,
                                               nextIndex: nextIndex))
  }

  func getBackwardMonths(fromDate date: Date, monthBackwards: Int) -> [Month] {
    return Array(0..<monthBackwards).map { count in
      let pastMonthDate = date.minusMonth(monthBackwards - count)
      return Month(id: count,
                   title: pastMonthDate.monthString,
                   days: getMonthDays(forDate: pastMonthDate))
    }
  }

  func getForwardMonths(fromDate date: Date, monthForwards: Int, nextIndex: Int) -> [Month] {
    return Array(0..<monthForwards).map { count in
      let futureMonthDate = date.plusMonth(count + 1)
      return Month(id: nextIndex + count,
                   title: futureMonthDate.monthString,
                   days: getMonthDays(forDate: futureMonthDate))
    }
  }
}

// MARK: - Helpers
extension MonthlyViewModel {

  func month(for id: Int) -> Month? {
    guard let month = months.first(where: { $0.id == id }) else {
      return nil
    }
    return month
  }

  func days(for section: Int) -> [Day] {
    month(for: section)?.days ?? []    
  }

  func getMonthDays(forDate date: Date) -> [Day] {

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
