//
//  Friend.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import Foundation

enum FriendRequest: HTTPRequest {
    case noFriends
    case friendList(paging: Int)
    case friendAndInvitation

    var endpoint: String {
        switch self {
        case .noFriends:
            return "friend4.json"
        case .friendList(let paging):
            return "friend\(paging).json"
        case .friendAndInvitation:
            return "friend3.json"
        }
    }
}

struct FriendResponse: Decodable {
    let response: [Friend]
}

struct Friend: Decodable {
    let name: String
    let status: Int
    let isTop: String
    let fid: String
    let updateDate: String
}
