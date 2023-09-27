import UIKit
import SnapKit

protocol WeeklyViewDelegate: AnyObject {
  func didSelectIndexPath(_ indexPath: IndexPath)
}

class WeeklyViewController: UIViewController {

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
    // cv.isScrollEnabled = false
    cv.register(WeekDayCell.self, forCellWithReuseIdentifier: WeekDayCell.identifier)
    return cv
  }()

  // MARK: - Properties
  weak var delegate: WeeklyViewDelegate?

  let viewModel: WeeklyViewModel
  init(viewModel: WeeklyViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
extension WeeklyViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekDayCell.identifier, for: indexPath) as? WeekDayCell else {
      return .init()
    }
    cell.title = viewModel.days[indexPath.item].day
    return cell
  }


  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.days.count
  }
}

extension WeeklyViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectIndexPath(indexPath)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeeklyViewController: UICollectionViewDelegateFlowLayout {

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
