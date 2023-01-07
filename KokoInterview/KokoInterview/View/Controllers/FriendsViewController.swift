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
            buttons.forEach { button in
                if !friends.isEmpty { button.setBadge() }
            }
            friendListTableView.separatorInset = UIEdgeInsets(top: 0, left: 85, bottom: 0, right: 0)
            friendListTableView.reloadData()
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var invitationTableView: UITableView!
    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var invitationHeightConstraint: NSLayoutConstraint!
    @IBOutlet var buttons: [BadgeButton]!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var underLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldBackground: UIView!
    @IBOutlet weak var textFieldBackgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var textField: UITextField!

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
            self.textFieldContainer.isHidden = friends.isEmpty ? true : false
            self.textFieldBackgroundHeightConstraint.constant = friends.isEmpty ? 0 : 61

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
        topContainerView.backgroundColor = UIColor.white252
        underLine.backgroundColor = UIColor.hotPink
        underLine.layer.cornerRadius = 2
        textFieldBackground.layer.cornerRadius = 10
        configButton()

        nameLabel.textColor = UIColor.greynishBrown
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)

        idLabel.textColor = UIColor.greynishBrown
        idLabel.font = UIFont.systemFont(ofSize: 13)

        textField.delegate = self
    }

    private func configButton() {
        let buttonTitles = ["好友", "聊天"]

        for index in buttons.indices {
            let button = buttons[index]
            
            if index == 0 {
                button.isSelected = true
            } else {
                button.setBadgeValue(99)
            }
            
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
        friendListTableView.registerCellWithNib(identifier: FriendListCell.identifier, bundle: nil)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoFriendsCell.identifier, for: indexPath) as? NoFriendsCell else { fatalError("Could not create NoFriendsCell")}
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendListCell.identifier, for: indexPath) as? FriendListCell else {
                fatalError("Could not create FriendListCell")
            }
            cell.layoutCell(with: friends[indexPath.row])
            return cell
        }
    }
}

extension FriendsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
