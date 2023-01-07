//
//  ViewController.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/6.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func showNoFriend(_ sender: UIButton) {
        DataManager.shared.friendRequest = .noFriends
        pushTabBar()
    }
    
    @IBAction func showFriends(_ sender: UIButton) {
        DataManager.shared.friendRequest = .friendList(paging: 1)
        pushTabBar()
    }

    @IBAction func showFriendsAndInvitation(_ sender: UIButton) {
        DataManager.shared.friendRequest = .friendAndInvitation
        pushTabBar()
    }

    private func pushTabBar() {
        guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: TabBarController.identifier) as? TabBarController else { fatalError("Could not instantiate tab bar VC") }
        navigationController?.pushViewController(tabBarController, animated: true)
    }
}

