//
//  NoFriendsCell.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import UIKit

class NoFriendsCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var buttonContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    private func setUpUI() {
        topLabel.font = UIFont.boldSystemFont(ofSize: 21)
        topLabel.textColor = UIColor.graynishBrown
        
        middleLabel.font = UIFont.systemFont(ofSize: 14)
        middleLabel.textColor = UIColor.brownGray
        
        bottomLabel.font = UIFont.systemFont(ofSize: 13)
        bottomLabel.textColor = UIColor.brownGray
        
        settingLabel.font = UIFont.systemFont(ofSize: 13)
        settingLabel.textColor = UIColor.hotPink
        settingLabel.underline()
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "加好友"
        configuration.baseForegroundColor = .white
        addFriendButton.configuration = configuration
        addFriendButton.applyGradient(
            colors: [.frogGreen, .booger],
            gradientOrientation: .horizontal,
            cornerRadius: 20
        )
        addFriendButton.applyshadowWithCorner(
            containerView: buttonContainer,
            cornerRadious: 20,
            shadowColor: .frogGreen
        )
    }
}
