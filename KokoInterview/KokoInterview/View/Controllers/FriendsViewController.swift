//
//  FriendsViewController.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import UIKit

class FriendsViewController: UIViewController {
    // MARK: - Property
    let viewModel = FriendViewModel()
    var friends: [Friend] = [] {
        didSet {
            friendListTableView.separatorStyle = friends.isEmpty ? .none : .singleLine
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var invitationTableView: UITableView!
    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var invitationHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var underLineCenterConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpTableView()

        viewModel.user.bind { [weak self] user in
            guard let self = self else { return }
            self.nameLabel.text = user.name
            self.idLabel.text = "KOKO ID : \(user.kokoid)"
        }

        viewModel.friends.bind { [weak self] friends in
            guard let self = self else { return }
            self.friends = friends

            var tableViewHeight: CGFloat = 0
            friends.forEach { friend in
                if friend.status == 2 {
                    tableViewHeight += 80
                }
            }
            self.invitationHeightConstraint.constant = tableViewHeight
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUser()
        viewModel.getFriends()
    }

    // MARK: - Private method
    private func setUpUI() {
        containerView.backgroundColor = UIColor.white252
        underLine.backgroundColor = UIColor.hotPink
        underLine.layer.cornerRadius = 2
        configButton()

        nameLabel.textColor = UIColor.greynishBrown
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        idLabel.textColor = UIColor.greynishBrown
        idLabel.font = UIFont.systemFont(ofSize: 13)
    }

    private func configButton() {
        let buttonTitles = ["好友", "聊天"]

        for index in buttons.indices {
            let button = buttons[index]
            if index == 0 { button.isSelected = true }
            button.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)

            var config = UIButton.Configuration.plain()
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = UIColor.greynishBrown
            config.attributedTitle = AttributedString(buttonTitles[index])
            
            let normalTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 13)
                return outgoing
            }

            let selectedTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.boldSystemFont(ofSize: 13)
                return outgoing
            }

            let handler: UIButton.ConfigurationUpdateHandler = { button in
                guard var configuration = button.configuration else { return }
                switch button.state {
                case .selected:
                    configuration.titleTextAttributesTransformer = selectedTransformer
                default:
                    configuration.titleTextAttributesTransformer = normalTransformer
                }
                button.configuration = configuration
            }

            button.configuration = config
            button.configurationUpdateHandler = handler
        }
    }

    private func setUpTableView() {
        friendListTableView.registerCellWithNib(identifier: NoFriendsCell.identifier, bundle: nil)
        friendListTableView.dataSource = self
        friendListTableView.allowsSelection = false
    }

    // MARK: - Action
    @objc func pressButton(_ sender: UIButton) {
        buttons.forEach { button in
            button.isSelected = false
        }
        sender.isSelected = true
        underLineCenterConstraint.isActive = false
        underLineCenterConstraint = underLine.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        underLineCenterConstraint.isActive = true

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { self.view.layoutIfNeeded() }
        )
    }
}

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friends.isEmpty {
            return 1
        } else {
            return friends.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if friends.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoFriendsCell.identifier, for: indexPath) as? NoFriendsCell else { fatalError("Could not create cell")}
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
