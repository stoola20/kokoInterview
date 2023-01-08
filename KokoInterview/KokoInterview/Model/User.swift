//
//  User.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import Foundation

enum UserRequest: HTTPRequest {
    case profile

    var endpoint: String {
        switch self {
        case .profile:
            return "man.json"
        }
    }
}

struct UserResponse: Decodable {
    let response: [User]
}

struct User: Decodable {
    let name: String
    let kokoid: String
}
