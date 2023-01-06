//
//  UIImage+Ext.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/6.
//

import UIKit

enum ImageAsset: String {
    // nav bar
    case icNavPinkScan
    case icNavPinkTransfer
    case icNavPinkWithdraw

    // friend
    case icAddFriendWhite
    case icBtnAddFriends
    case icFriendsStar
    case imgFriendsEmpty
    case imgFriendsFemaleDefault
}

extension UIImage {
    static func asset(_ asset: ImageAsset) -> UIImage? {
        return UIImage(named: asset.rawValue)
    }
}
