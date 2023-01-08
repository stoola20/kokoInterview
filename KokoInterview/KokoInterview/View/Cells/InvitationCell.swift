//
//  InvitationCell.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/8.
//

import UIKit

class InvitationCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    func layoutCell(with friend: Friend) {
        nameLabel.text = friend.name
    }

    private func setUpUI() {
        whiteBackgroundView.applyshadowWithCorner(
            containerView: containerView,
            cornerRadious: 5,
            shadowColor: UIColor.lightGray
        )
        
        nameLabel.textColor = UIColor.graynishBrown
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        descriptionLabel.textColor = UIColor.brownGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
    }
}
