//
//  BadgeButton.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import UIKit

class BadgeButton: UIButton {
    
    // MARK: - Properties
    var badgeCornerRadius: CGFloat {
        badgeHeight / 2
    }
    var fontSize: CGFloat = 12
    var badgeHeight: CGFloat = 18
    
    private lazy var badgeView: UIView = {
        let badgeView = UIView()
        badgeView.backgroundColor = UIColor.buttonBadge
        badgeView.layer.cornerRadius = badgeCornerRadius
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.alpha = 0
        badgeView.addSubview(badgeLabel)
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 4),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -4)
        ])
        return badgeView
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: fontSize)
        label.layer.cornerRadius = badgeCornerRadius
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: - Public
extension BadgeButton {
    func setBadge() {
        addSubview(badgeView)
        NSLayoutConstraint.activate([
            badgeView.heightAnchor.constraint(equalToConstant: badgeHeight),
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: -4),
            badgeView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    func setBadgeValue(_ value: Int) {
        guard value > 0 else {
            self.removeBadge()
            return
        }
        self.badgeView.alpha = 1
        let text = value == 99 ? "99+" : "\(value)"
        self.badgeLabel.text = text
    }

    private func removeBadge() {
        self.badgeView.alpha = 0
        self.badgeLabel.text = ""
    }
}
