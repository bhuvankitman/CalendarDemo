import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let vm = CalendarViewModel(monthBackward: 2, monthForward: 2, events: .sampleEvents)
    let vc = CalendarViewController(viewModel: vm)
    navigationController?.pushViewController(vc, animated: true)
  }
}
