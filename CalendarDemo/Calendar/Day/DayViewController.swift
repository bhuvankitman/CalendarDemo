import UIKit
import SwiftUI

protocol DayViewDelegate: AnyObject {
  func scrollTo(page: CGFloat)
}

struct Event: Identifiable {
  let id: String = UUID().uuidString
  let title: String
  let date: Date

  init(title: String, date: Date) {
    self.title = title
    self.date = date
  }
}

struct DayViewModel {
  let startDate: Date
  let endDate: Date
  let events: [Event]

  init(startDate: Date, endDate: Date, events: [Event]) {
    self.startDate = startDate
    self.endDate = endDate
    self.events = events
  }

  var totalDays: [String] {
    return []
  }

}

class DayViewController: UIViewController {

  weak var delegate: DayViewDelegate?

  lazy var layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 20
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    return layout
  }()

  lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.dataSource = self
    cv.delegate = self
    cv.register(DayCell.self, forCellWithReuseIdentifier: DayCell.identifer)
    return cv
  }()

  private let viewModel: DayViewModel

  init(viewModel: DayViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCalendarView()
  }

  func setupCalendarView() {
    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension DayViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifer, for: indexPath) as? DayCell
    else {
      return .init()
    }
    let events: [Event] = [.init(title: "Travel to Birmingham", date: .now),
                           .init(title: "Away vs Aston Villa ", date: .now),
                           .init(title: "Travel home", date: .now)]


    cell.collectionView = collectionView
    cell.configure(with: .init(date: .now, events: events))
    return cell
  }


  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 14
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      scrollToPage()
    }
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    scrollToPage()
  }

  func scrollToPage() {
    let visibleRowIndices = collectionView.visibleCells
      .compactMap { collectionView.indexPath(for: $0) }
      .map { $0.row }

    guard let firstVisibleRowIndex = visibleRowIndices.min() else {
      return
    }

    let page = CGFloat(ceil(Double(firstVisibleRowIndex / 7)))

    delegate?.scrollTo(page: page)
  }
}

extension DayViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.frame.width, height: 100)
  }

}
