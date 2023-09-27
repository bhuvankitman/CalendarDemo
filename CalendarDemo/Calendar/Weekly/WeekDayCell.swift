import UIKit
import SwiftUI

class WeekDayCell: UICollectionViewCell {

  static let identifier = "WeekDayCell"

  func configure(title: String, isActive: Bool) {
    self.contentConfiguration = UIHostingConfiguration {
      VStack {
        Text(title)
          .foregroundColor(isActive ? .red : .black)
      }
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
     contentConfiguration = nil
  }

}
