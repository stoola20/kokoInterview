//
//  FriendsViewController.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import UIKit

class FriendsViewController: UIViewController {
    let viewModel = FriendViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.user.bind { user in
            print(user)
        }

        viewModel.friends.bind { friends in
            print(friends)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUser()
        viewModel.getFriends()
    }
}
