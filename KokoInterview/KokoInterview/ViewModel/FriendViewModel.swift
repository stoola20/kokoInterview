//
//  FriendViewModel.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import Foundation

final class FriendViewModel {
    private let dispatchGroup = DispatchGroup()
    private var friendDict: [String: [Friend]] = [:]
    private lazy var dateFormatter = DateFormatter()
    let user = Observable(User(name: "", kokoid: ""))
    let friends = {
        let friends: [Friend] = []
        return Observable(friends)
    }()

    func getUser() {
        DataManager.shared.getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.user.value = response.response.first!
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func getFriends() {
        switch DataManager.shared.friendRequest {
        case .friendList(paging: let paging):
            multipleFriendRequest()
            DataManager.shared.friendRequest = .friendList(paging: paging + 1)
            multipleFriendRequest()

            dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else { return }
                self.friends.value = self.filterFriends(from: self.friendDict)
            }
        default:
            singleFriendRequest()
        }
    }

    private func filterFriends(from dict: [String: [Friend]]) -> [Friend] {
        var friends: [Friend] = []

        dict.forEach { _, duplicatedFriends in
            let sortedFriends = duplicatedFriends.sorted { friend1, friend2 in

                dateFormatter.dateFormat = friend1.updateDate.contains("/") ? "YYYY/MM/dd" : "YYYYMMdd"
                guard let date1 = dateFormatter.date(from: friend1.updateDate) else {
                    fatalError("fail to convert friend1 string to date")
                }

                dateFormatter.dateFormat = friend2.updateDate.contains("/") ? "YYYY/MM/dd" : "YYYYMMdd"
                guard let date2 = dateFormatter.date(from: friend2.updateDate) else {
                    fatalError("fail to convert friend2 string to date")
                }

                return date1 > date2
            }
            friends.append(sortedFriends.first!)
        }
        return friends
    }

    private func multipleFriendRequest() {
        dispatchGroup.enter()
        DataManager.shared.getFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(FriendResponse.self, from: data)
                    let nsLock = NSLock()
                    response.response.forEach { friend in
                        nsLock.lock()
                        if self.friendDict[friend.fid] == nil {
                            self.friendDict[friend.fid] = [friend]
                        } else {
                            self.friendDict[friend.fid]?.append(friend)
                        }
                        nsLock.unlock()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.dispatchGroup.leave()
        }
    }

    private func singleFriendRequest() {
        DataManager.shared.getFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(FriendResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.friends.value = response.response
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
