//
//  WeekDayCell.swift
//  CalendarDemo
//
//  Created by Bhuvan Bhatt on 19/09/2023.
//

import UIKit

class WeekDayCell: UICollectionViewCell {

  static let identifier = "WeekDayCell"

  lazy var dayLabel = UILabel()

  var title: String? {
    didSet {
      dayLabel.text = title
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(dayLabel)

    dayLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
