//
//  NetworkService.swift
//  Graphic
//
//  Created by Екатерина Протасова on 25.12.2019.
//  Copyright © 2019 Екатерина Протасова. All rights reserved.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

// swiftlint:disable force_unwrapping
class NetworkService: NSObject, Networking {

    var session: URLSession!

    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        var allParams = params
        allParams["version"] =  "1.1"
        let url = self.url(from: path, params: allParams)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        print(url)
    }

    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "demo.bankplus.ru"
        components.path = "/mobws/json/pointsList"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }

    private func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        session.dataTask(with: requst) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

extension NetworkService: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
