import UIKit
import SnapKit

struct CalData {
  var day: String
  var date: Date?
  var data: Any?
}

class MonthlyViewController: UIViewController {

  // MARK: - UI Views
  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical
    return layout
  }()

  lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.dataSource = self
    cv.delegate = self
    cv.register(WeekDayCell.self, forCellWithReuseIdentifier: WeekDayCell.identifier)
    cv.register(MonthlyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MonthlyHeaderView.identifier)
    return cv
  }()

  // MARK: - Properties

  // MARK: - Initializer
  let viewModel: MonthlyViewModel

  init(viewModel: MonthlyViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout.invalidateLayout()
  }
}

extension MonthlyViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    viewModel.months.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.days(for: section).count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekDayCell.identifier, for: indexPath) as! WeekDayCell

    let day = viewModel.days(for: indexPath.section)[indexPath.item]
    cell.configure(title: day.day, isActive: day.isToday())

    return cell
  }
}


extension MonthlyViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let days = viewModel.days(for: indexPath.section)

    guard !days.isEmpty else { return }
    let selectedDay = days[indexPath.item]

    print(selectedDay.date.dayString)
    // TODO: Handle day selection
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columns: CGFloat = 7
    let spacing = layout.minimumLineSpacing * (columns - 1)
    let horizontaInset = layout.sectionInset.left + layout.sectionInset.right
    let width = (collectionView.frame.width - spacing - horizontaInset) / columns
    return CGSize(width: width, height: 50)
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard
        let headerView = collectionView
          .dequeueReusableSupplementaryView(ofKind: kind,
                                            withReuseIdentifier: MonthlyHeaderView.identifier,
                                            for: indexPath) as? MonthlyHeaderView,
        let month = viewModel.month(for: indexPath.section)
      else {
        return .init()
      }
      headerView.monthTitle = month.title
      return headerView
    default:
      // 5
      assert(false, "Invalid element type")
    }
  }
}

extension MonthlyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    .init(width: collectionView.frame.width, height: 70)
  }
}
