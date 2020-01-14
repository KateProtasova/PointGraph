//
//  ViewController.swift
//  Graphic
//
//  Created by Екатерина Протасова on 25.12.2019.
//  Copyright © 2019 Екатерина Протасова. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    private var sortedPoints: [Point] = []
    private var params: [String: String] = [:]
    var spinnerView: UIView?

    @IBOutlet private var countPointTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        countPointTextField.becomeFirstResponder()
    }

    private func getPoint(params: [String: String]) {
        self.showSpinner(onView: self.view)
        fetcher.getPoins(params: params) { [weak self] points, errorMessage in
            if let error = errorMessage {
                self?.removeSpinner()
                self?.showAlert(message: error)
            } else {
                guard let strongSelf = self, let pointsForSorted = points else {
                    return
                }
                strongSelf.sortedPoints = pointsForSorted.sorted { $0.x < $1.x }
                strongSelf.removeSpinner()
                guard let viewController: GraphicViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GraphicViewController") as? GraphicViewController else {
                    return
                }
                viewController.sortedPoins = strongSelf.sortedPoints
                strongSelf.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    @IBAction private func showGraphic(_ sender: Any) {
        guard let textField = countPointTextField.text else {
            return
        }

        if  textField.isEmpty {
            self.showAlert(message: "Type any number")
        } else {
            params = ["count": textField]
            getPoint(params: params)
        }
    }

    func showSpinner(onView: UIView) {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.startAnimating()
        indicator.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(indicator)
            onView.addSubview(spinnerView)
        }
        self.spinnerView = spinnerView
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinnerView?.removeFromSuperview()
            self.spinnerView = nil
        }
    }
}
