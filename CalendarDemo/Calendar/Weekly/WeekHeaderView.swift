import UIKit

class WeekHeaderView: UICollectionReusableView {

  static let identifier = "WeekHeaderView"

  lazy var weekdayLabel = UILabel()

  var weekdayTitle: String? {
    didSet {
      weekdayLabel.text = weekdayTitle
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(weekdayLabel)

    weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      weekdayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      weekdayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
