//
//  PointCell.swift
//  Graphic
//
//  Created by Екатерина Протасова on 26.12.2019.
//  Copyright © 2019 Екатерина Протасова. All rights reserved.
//

import UIKit

class PointCell: UITableViewCell {

    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var pointXLabel: UILabel!
    @IBOutlet private var pointYLabel: UILabel!

    func configureWith(point: Point, atIndex index: Int) {
        pointXLabel.text = "\(point.x)"
        pointYLabel.text = "\(point.y)"
        numberLabel.text = "№\(index)"
    }
}
