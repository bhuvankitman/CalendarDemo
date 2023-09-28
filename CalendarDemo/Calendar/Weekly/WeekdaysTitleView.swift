import UIKit
import SnapKit
import SwiftUI


struct WeekDaySymbolView: View {

  let symbols: [String]

  var body: some View {
    HStack(spacing: 0) {
      ForEach(symbols, id: \.self) { symbol in
        Text(symbol)
          .frame(maxWidth: .infinity)
          .multilineTextAlignment(.center)
      }
    }
  }
}

class WeekdaysTitleView: UIView {

  enum FirstWeekDay: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
  }

  // MARK: - UI Views

  // MARK: - Initializer
  let firstWeekday: FirstWeekDay

  var weekdayNames: [String] {
    var calendar = Calendar.current
    calendar.locale = .current

    let defaultSymbols = calendar.shortWeekdaySymbols
    let weekdayNames = Array(defaultSymbols[firstWeekday.rawValue - 1..<defaultSymbols.count]) + defaultSymbols[0..<firstWeekday.rawValue - 1]

    return weekdayNames
  }

  init(firstWeekDay: FirstWeekDay = .sunday) {
    self.firstWeekday = firstWeekDay
    super.init(frame: .zero)

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup views
  func setupViews() {
    guard let symbolView = UIHostingController(rootView: WeekDaySymbolView(symbols: weekdayNames)).view else {
      return
    }

    addSubview(symbolView)
    symbolView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
