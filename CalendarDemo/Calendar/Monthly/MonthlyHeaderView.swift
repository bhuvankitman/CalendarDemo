import UIKit
import SnapKit

class MonthlyHeaderView: UICollectionReusableView {

  static let identifier = "MonthlyHeaderView"

  lazy var weekdaysTitleView: WeekdaysTitleView = {
    let weekdaysView = WeekdaysTitleView()
    weekdaysView.translatesAutoresizingMaskIntoConstraints = false
    return weekdaysView
  }()

  lazy var monthLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  var monthTitle: String = "" {
    didSet {
      monthLabel.text = monthTitle
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(monthLabel)
    addSubview(weekdaysTitleView)

    monthLabel.snp.makeConstraints { make in
      make.top.equalTo(8)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(25)
    }
    weekdaysTitleView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

