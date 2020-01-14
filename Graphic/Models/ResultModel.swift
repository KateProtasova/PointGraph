//
//  ResultModel.swift
//  Graphic
//
//  Created by Екатерина Протасова on 25.12.2019.
//  Copyright © 2019 Екатерина Протасова. All rights reserved.
//

import Foundation
import CoreGraphics

struct RootPointsData: Decodable {
    let result: Int?
    let response: PointsResponse
}

struct PointsResponse: Decodable {
    let points: [Point]?
    let result: Int?
    let message: String?
}

struct Point: Decodable {
    var x: CGFloat
    var y: CGFloat

    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    enum CodingKeys: String, CodingKey {
        case x
        case y
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        guard let doubleX = try Double(values.decode(String.self, forKey: .x)), let doubleY = try Double(values.decode(String.self, forKey: .y)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.x], debugDescription: "Expecting string representation of Double"))
        }
        x = CGFloat(doubleX)
        y = CGFloat(doubleY)
    }
}
