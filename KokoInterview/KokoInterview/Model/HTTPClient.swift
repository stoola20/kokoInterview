//
//  HTTPClient.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import Foundation

protocol HTTPRequest {
    var endpoint: String { get }
}

enum HTTPError: Error {
    case decodeError
    case clientError
    case serverError
    case unexpectedError
}
