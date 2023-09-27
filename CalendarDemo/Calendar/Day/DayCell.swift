import UIKit
import SwiftUI
import Combine


class DayCell: UICollectionViewCell {

  // MARK: - Properties
  static let identifer = "DayCell"

  // MARK: - UI Views
  lazy var labelContainer: UIView = {
    let container = UIView()
    container.addSubview(dateLabel)

    return container
  }()

  lazy var weekday: UILabel = {
    let label = UILabel()
    label.text = "Wed"
    label.textAlignment = .center
    label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    label.textColor = .lightGray
    return label
  }()


  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .darkGray
    label.text = "5"
    label.font = .systemFont(ofSize: 25, weight: .bold)
    label.textColor = .white
    label.textAlignment = .center
    label.heightAnchor.constraint(equalToConstant: 50).isActive = true
    label.widthAnchor.constraint(equalToConstant: 50).isActive = true

    label.translatesAutoresizingMaskIntoConstraints = false
    label.layer.cornerRadius = 25
    label.layer.masksToBounds = true

    return label
  }()

  lazy var dateStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [weekday, labelContainer, UIView()])
    stack.widthAnchor.constraint(equalToConstant: 50).isActive = true
    stack.axis = .vertical
    return stack
  }()

  func makeEventView(title: String, subtitle: String) -> UIStackView {
    let stack = UIStackView()

    stack.axis = .vertical
    stack.spacing = 10

    let label = UILabel()
    label.text = title

    let label1 = UILabel()
    label1.text = subtitle

    stack.addArrangedSubview(label)
    stack.addArrangedSubview(label1)

    stack.backgroundColor = .random()

    stack.layer.cornerRadius = 4
    stack.layer.masksToBounds = true    

    stack.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
    stack.isLayoutMarginsRelativeArrangement = true


    return stack
  }

  lazy var eventsStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [makeEventView(title: "Team briefing", subtitle: "11:30 - 12:30 (60 mins)"),
                                               makeEventView(title: "Travel to Birmingham", subtitle: "13:00 - 15:00 (120 mins)")])
    stack.axis = .vertical
    stack.spacing = 4
    return stack
  }()

  lazy var rootStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [dateStack, eventsStack])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.alignment = .leading
    stack.spacing = 16
    return stack
  }()

  override func prepareForReuse() {
    super.prepareForReuse()

    contentConfiguration = nil
  }

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

  override init(frame: CGRect) {
    super.init(frame: frame)

//    contentView.addSubview(rootStack)
//
//    NSLayoutConstraint.activate([
//      rootStack.topAnchor.constraint(equalTo: contentView.topAnchor),
//      rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//      rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//      rootStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//    ])
//
//    collectionView?.collectionViewLayout.invalidateLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with viewModel: DayCellViewModel) {

  }

  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let contentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    layoutAttributes.bounds.size.height = contentHeight
    return layoutAttributes
  }

}
