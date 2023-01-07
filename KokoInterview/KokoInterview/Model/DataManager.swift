//
//  DataManager.swift
//  KokoInterview
//
//  Created by Hsun Chen on 2023/1/7.
//

import Foundation

final class DataManager {
    static let shared = DataManager()

    private init() { }

    var friendRequest: FriendRequest = .noFriends

    func getUser(completion: @escaping (Result<Data, Error>) -> Void) {
        request(UserRequest.profile, completion: completion)
    }

    func getFriends(completion: @escaping (Result<Data, Error>) -> Void) {
        request(friendRequest, completion: completion)
    }

    private func request(_ httpRequest: HTTPRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let baseURL = "https://dimanyen.github.io/"

        guard let url = URL(string: baseURL + httpRequest.endpoint) else {
            fatalError("Wrong URL")
        }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            let response = response as! HTTPURLResponse
            let statusCode = response.statusCode

            switch statusCode {
            case 200...299:
                completion(.success(data!))
            case 400...499:
                completion(.failure(HTTPError.clientError))
            case 500...599:
                completion(.failure(HTTPError.serverError))
            default:
                completion(.failure(HTTPError.unexpectedError))
            }
        }
        .resume()
    }
}
