import UIKit
import SnapKit

protocol WeekDelegate: AnyObject {
  func didSelectIndexPath(_ indexPath: IndexPath)
}

class WeekViewController: UIViewController {

  // MARK: - UI Views
  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0    
    return layout
  }()

  lazy var weekdayTitleView: UIView = {
    let weekdayView = WeekdaysTitleView()
    return weekdayView
  }()

  lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero,
                              collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.dataSource = self
    cv.delegate = self
    cv.isPagingEnabled = true
    cv.isScrollEnabled = false
    cv.register(WeekDayCell.self, forCellWithReuseIdentifier: WeekDayCell.identifier)
    return cv
  }()

  // MARK: - Properties
  weak var delegate: WeekDelegate?

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupCalendarView()
  }

  // MARK: - Setup Views
  func scrollTo(page: CGFloat) {
    collectionView.setContentOffset(.init(x: collectionView.frame.width * page,
                                          y: collectionView.contentOffset.y), animated: true)
  }


  func setupCalendarView() {
    view.addSubview(weekdayTitleView)
    view.addSubview(collectionView)

    weekdayTitleView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(25)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(weekdayTitleView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(35)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension WeekViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekDayCell.identifier, for: indexPath) as? WeekDayCell else {
      return .init()
    }
    // cell.backgroundColor = .random()
    cell.title = "\(indexPath.row + 1)"
    return cell
  }


  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 14
  }

//  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//    switch kind {
//      // 1
//    case UICollectionView.elementKindSectionHeader:
//      // 2
//      let headerView = collectionView.dequeueReusableSupplementaryView(
//        ofKind: kind,
//        withReuseIdentifier: WeekHeaderView.identifier,
//        for: indexPath)
//
//      // 3
//      guard let typedHeaderView = headerView as? WeekHeaderView
//      else { return headerView }
//
//      // 4
//      let searchTerm = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
//      typedHeaderView.weekdayLabel.text = searchTerm.randomElement()
//      return typedHeaderView
//    default:
//      // 5
//      assert(false, "Invalid element type")
//    }
//  }
}

extension WeekViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectIndexPath(indexPath)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeekViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columns: CGFloat = 7
    let spacing = layout.minimumLineSpacing * (columns - 1)
    let horizontaInset = layout.sectionInset.left + layout.sectionInset.right
    let width = (collectionView.frame.width - spacing - horizontaInset) / columns
    return CGSize(width: width, height: 100)
  }
}

extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}

extension UIColor {
  static func random() -> UIColor {
    return UIColor(
      red:   .random(),
      green: .random(),
      blue:  .random(),
      alpha: 1.0
    )
  }
}
