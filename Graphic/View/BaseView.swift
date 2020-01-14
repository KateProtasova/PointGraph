//
//  BaseView.swift
//  Graphic
//
//  Created by Екатерина Протасова on 13.01.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import UIKit

class BaseView: UIView {

    private var contentView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func commonInit() {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName(), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.isAccessibilityElement = false
        contentView.frame = bounds
        addSubview(contentView)
        configureUI()
    }

    func configureUI() {

    }

    func nibName() -> String {
        String(describing: type(of: self))
    }
}
