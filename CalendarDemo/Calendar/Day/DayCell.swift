import UIKit
import SwiftUI
import Combine


class DayCell: UICollectionViewCell {

  // MARK: - Properties
  static let identifer = "DayCell"
  var observers = [AnyCancellable]()

  func configure(with viewModel: DayCellViewModel) {
    contentConfiguration = UIHostingConfiguration {
      let dayView = DayView(viewModel: viewModel)
      dayView.action.sink { event in
        print("\(event.title) Tapped")
      }.store(in: &observers)
      return dayView
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
     contentConfiguration = nil
  }

  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let contentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    layoutAttributes.bounds.size.height = contentHeight
    return layoutAttributes
  }

}
