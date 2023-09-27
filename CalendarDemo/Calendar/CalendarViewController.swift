import UIKit
import SnapKit

class CalendarViewController: UIViewController {

  // MARK: - Constants
  enum Constants {
    static let weekViewHeight: CGFloat = 60
    static let weekViewThresholdHeight: CGFloat = weekViewHeight * 3
  }

  // MARK: - UI Views
  lazy var dayVc: DayViewController = {
    let vm = DayViewModel(days: viewModel.weeklyDays())
    let vc = DayViewController(viewModel: vm)
    vc.delegate = self
    return vc
  }()

  lazy var weekVc: WeeklyViewController = {
    let vc = WeeklyViewController(viewModel: .init(days: viewModel.weeklyDays()))
    return vc
  }()

  // MARK: - Properties
  private let viewModel: CalendarViewModel

  init(viewModel: CalendarViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupWeekView()
    setupDayView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    dayVc.scrollToTodaysDate()
  }

  var heightConstraint: NSLayoutConstraint?

  // MARK: - Setup Views
  func setupWeekView() {
    add(childController: weekVc, onView: view)
    guard let weekView = weekVc.view else {
      return
    }

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    weekView.addGestureRecognizer(panGesture)
    weekView.translatesAutoresizingMaskIntoConstraints = false

    weekView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(Constants.weekViewHeight)
    }
  }

  func setupDayView() {
    add(childController: dayVc, onView: view)
    guard
      let dayView = dayVc.view,
      let weekView = weekVc.view
    else {
      return
    }
    dayView.translatesAutoresizingMaskIntoConstraints = false

    dayView.snp.makeConstraints { make in
      make.top.equalTo(weekView.snp.bottom).offset(16)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  // MARK: - Selectors
  @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {

    guard let weekView = gesture.view else { return }

    func resetWeekViewHeight() {
      update(height: Constants.weekViewHeight, forView: weekView)
    }

    // Calculate the dynamic height based
    let translation = gesture.translation(in: view)
    let dynamicHeight = Constants.weekViewHeight + translation.y

    switch gesture.state {

    case .changed:

      // Guard to only increase the week view height
      // No change when the week view is dragged up
      guard dynamicHeight > Constants.weekViewHeight else {
        return
      }
      update(height: dynamicHeight, forView: weekView)

      // Presnt monthly controller when the week view height passes the threshold
      guard dynamicHeight > Constants.weekViewThresholdHeight else { return }
      let vm = MonthlyViewModel(selectedDate: .now,
                                monthBackwards: viewModel.monthBackward,
                                monthForwards: viewModel.monthForward)
      let vc = MonthlyViewController(viewModel: vm)
      present(vc, animated: true) {
        resetWeekViewHeight()
      }

    case .ended:
      resetWeekViewHeight()

    default:
      break
    }
  }

  func update(height: CGFloat, forView customView: UIView) {
    customView.snp.updateConstraints { make in
      make.height.equalTo(height)
    }
  }
}

// MARK: - DayViewDelegate
extension CalendarViewController: DayViewDelegate {
  func scrollTo(page: CGFloat) {
    weekVc.scrollTo(page: page)
  }
}
