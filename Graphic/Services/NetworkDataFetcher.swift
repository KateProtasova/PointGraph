//
//  NetworkDataFetcher.swift
//  Graphic
//
//  Created by Екатерина Протасова on 25.12.2019.
//  Copyright © 2019 Екатерина Протасова. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getPoins(params: [String: String], response: @escaping ([Point]?, String?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getPoins(params: [String: String], response: @escaping ([Point]?, String?) -> Void) {
        networking.request(path: "mobws/json/pointsList", params: params) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil, error.localizedDescription)
            }

            guard let decoded = self.decodeJSON(type: RootPointsData.self, from: data) else {
                response(nil, "Data not valid")
                return
            }

            if decoded.result == 0 {
                response(decoded.response.points, nil)
            } else if decoded.response.result == -100 {
                let message: String = decoded.response.message ?? "Unknown error"
                response(nil, message)
            } else if decoded.response.result == -1 {
                let message: String = decoded.response.message ?? "Unknown error"
                response(nil, message)
            } else {
                response(nil, "Unknown error")
            }
        }
    }

    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else {
            return nil
        }
        return response
    }
}
