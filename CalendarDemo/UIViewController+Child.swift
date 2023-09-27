import UIKit

public extension UIViewController {
  /// Add child view controller to the calling view controller.
  /// - Parameter childController: The child view controller to be added.
  func add(childController: UIViewController, onView containerView: UIView) {
    // Add the view controller to the container
    addChild(childController)
    containerView.addSubview(childController.view)
    // Notify the child view controller that the move is complete
    childController.didMove(toParent: self)
  }

  func removeChild(_ childController: UIViewController) {
    childController.willMove(toParent: nil)
    childController.view.removeFromSuperview()
    childController.removeFromParent()
  }
}

