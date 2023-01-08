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
    var user: User?
    var friends: [Friend] = []
    var filteredFriends: [Friend] = [] {
        didSet {
            friendListTableView.reloadData()
        }
    }
    var invitations: [Friend] = [] {
        didSet {
            invitationTableView.reloadData()
        }
    }
    private var refreshControl = UIRefreshControl()
    private var dynamicY: CGFloat = 0 // y position to animate textfield

    // MARK: - IBOutlet
    @IBOutlet weak var pinkDot: UIView!
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
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.addTarget(self, action: #selector(searchFriends(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var topContainerTopConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpTableView()
        dataBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dynamicY = -(textFieldContainer.frame.minY + textFieldBackground.frame.minY - topContainerView.frame.minY)
    }

    // MARK: - Private method
    private func dataBinding() {
        viewModel.user.bind { [weak self] user in
            guard let self = self else { return }
            self.user = user
            self.nameLabel.text = user.name
        }

        viewModel.friends.bind { [weak self] friends in
            guard let self = self else { return }
            self.friends = friends
            self.filteredFriends = friends

            self.textFieldBackgroundHeightConstraint.constant = friends.isEmpty ? 0 : 61
            self.textFieldContainer.isHidden = friends.isEmpty ? true : false

            self.pinkDot.isHidden = friends.isEmpty ? false : true
            self.idLabel.text = friends.isEmpty ? "設定 KOKO ID" : "KOKO ID : \(self.user!.kokoid)"

            self.friendListTableView.separatorStyle = friends.isEmpty ? .none : .singleLine
            self.friendListTableView.separatorInset = UIEdgeInsets(top: 0, left: 85, bottom: 0, right: 0)
        }

        viewModel.invitations.bind { [weak self] invitations in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.invitations = invitations
            self.setBadgeValue(invitationValue: invitations.count)

            var tableViewHeight: CGFloat = 0
            invitations.forEach { friend in
                if friend.status == 2 {
                    tableViewHeight += 90
                }
            }
            self.invitationHeightConstraint.constant = tableViewHeight
        }
    }

    private func setUpUI() {
        pinkDot.layer.cornerRadius = 5
        pinkDot.backgroundColor = UIColor.hotPink

        invitationHeightConstraint.constant = 0
        topContainerView.backgroundColor = UIColor.white252
        underLine.backgroundColor = UIColor.hotPink
        underLine.layer.cornerRadius = 2
        textFieldBackground.layer.cornerRadius = 10
        configButton()

        nameLabel.textColor = UIColor.graynishBrown
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)

        idLabel.textColor = UIColor.graynishBrown
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
            config.baseForegroundColor = UIColor.graynishBrown
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

    private func setBadgeValue(invitationValue: Int, chatValue: Int = 99) {
        if friends.isEmpty && invitations.isEmpty { return }

        for index in buttons.indices {
            let button = buttons[index]
            button.setBadge()

            if index == 0 {
                button.setBadgeValue(invitationValue)
            } else {
                button.setBadgeValue(chatValue)
            }
        }
    }

    private func setUpTableView() {
        invitationTableView.registerCellWithNib(identifier: InvitationCell.identifier, bundle: nil)
        invitationTableView.dataSource = self
        invitationTableView.allowsSelection = false
        invitationTableView.separatorStyle = .none

        friendListTableView.registerCellWithNib(identifier: NoFriendsCell.identifier, bundle: nil)
        friendListTableView.registerCellWithNib(identifier: FriendListCell.identifier, bundle: nil)
        friendListTableView.dataSource = self
        friendListTableView.allowsSelection = false

        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        friendListTableView.addSubview(refreshControl)
    }

    @objc private func getData() {
        viewModel.getUser()
        viewModel.getFriends()
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

    @objc func searchFriends(_ sender: UITextField) {
        guard let searchString = sender.text else {
            return
        }

        var tempFriends: [Friend] = []
        if searchString.isEmpty {
            self.filteredFriends = friends
        } else {
            friends.forEach { friend in
                if friend.name.contains(searchString) {
                    tempFriends.append(friend)
                }
            }
            self.filteredFriends = tempFriends
        }
    }
}

// MARK: - TableView DataSource
extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == friendListTableView {
            return friends.isEmpty ? 1 : filteredFriends.count
        } else {
            return invitations.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == friendListTableView {
            if friends.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoFriendsCell.identifier, for: indexPath) as? NoFriendsCell else { fatalError("Could not create NoFriendsCell")}
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendListCell.identifier, for: indexPath) as? FriendListCell else {
                    fatalError("Could not create FriendListCell")
                }
                cell.layoutCell(with: filteredFriends[indexPath.row])
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InvitationCell.identifier, for: indexPath) as? InvitationCell else {
                fatalError("Could not create FriendListCell")
            }
            cell.layoutCell(with: invitations[indexPath.row])
            return cell
        }
    }
}

// MARK: - TextField Delegate
extension FriendsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.topContainerTopConstraint.constant = self.dynamicY
                self.view.layoutIfNeeded()
            }
        )
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.topContainerTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        )
    }
}
