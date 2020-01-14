//
//  UIViewController.swift
//  Graphic
//
//  Created by Екатерина Протасова on 14.01.2020.
//  Copyright © 2020 Екатерина Протасова. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(title: String = "", message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
