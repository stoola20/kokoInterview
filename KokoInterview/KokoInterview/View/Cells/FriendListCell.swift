//
//  FriendListCell.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import UIKit

class FriendListCell: UITableViewCell {

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var invitedButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var starImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    private func setUpUI() {
        invitedButton.isEnabled = false
        setUp(transferButton, title: "轉帳", with: UIColor.hotPink)
        setUp(invitedButton, title: "邀請已送出", with: UIColor.veryLightGrey)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor.greynishBrown
    }

    private func setUp(_ button: UIButton, title: String, with color: UIColor) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = color
        let attributedTitle = AttributedString(title)
        config.attributedTitle = attributedTitle
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.boldSystemFont(ofSize: 14)
            return outgoing
        }
        config.titleTextAttributesTransformer = transformer
        button.configuration = config
        button.layer.borderWidth = 1.5
        button.layer.borderColor = color.cgColor
        button.layer.cornerRadius = 2
    }

    func layoutCell(with friend: Friend) {
        starImage.isHidden = friend.isTop == "1" ? false : true
        nameLabel.text = friend.name

        var alreadyFriends = friend.status == 1
        transferButton.isHidden = alreadyFriends ? false : true
        moreButton.isHidden = alreadyFriends ? false : true
        invitedButton.isHidden = alreadyFriends ? true : false
    }
}
