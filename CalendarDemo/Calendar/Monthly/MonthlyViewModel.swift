import Foundation

struct Month {
  let id: Int
  let title: String
  let days: [Day]
}

struct MonthlyViewModel {

  // MARK: - Initializer
  let selectedDate: Date
  let months: [Month]

  init(selectedDate: Date, months: [Month]) {
    self.selectedDate = selectedDate
    self.months = months
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

}
