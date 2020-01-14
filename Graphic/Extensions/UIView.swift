//
//  UIView.swift
//  Graphic
//
//  Created by Екатерина Протасова on 14.01.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
