//
//  TabBarViewController.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/6.
//

import UIKit

class TabBarController: UITabBarController {
    static let identifier = String(describing: TabBarController.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1

        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage.asset(.icNavPinkWithdraw), style: .plain, target: self, action: #selector(popViewController)),
            UIBarButtonItem(image: UIImage.asset(.icNavPinkTransfer), style: .plain, target: nil, action: nil)
        ]

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.asset(.icNavPinkScan), style: .plain, target: nil, action: nil)

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.white252
        navigationBarAppearance.shadowColor = nil
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
