import UIKit
import SnapKit

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

  lazy var weekDayStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.translatesAutoresizingMaskIntoConstraints = false

    for weekday in weekdayNames {
      let label = UILabel()
      label.textAlignment = .center
      label.text = weekday
      label.textColor = .black
      label.adjustsFontSizeToFitWidth = true
      stack.addArrangedSubview(label)
    }

    return stack
  }()

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
    addSubview(weekDayStack)

    weekDayStack.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
