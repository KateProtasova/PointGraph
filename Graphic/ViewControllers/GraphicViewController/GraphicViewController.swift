//
//  GraphicViewController.swift
//  Graphic
//
//  Created by Екатерина Протасова on 26.12.2019.
//  Copyright © 2019 Екатерина Протасова. All rights reserved.
//

import UIKit

class GraphicViewController: UIViewController {

    var sortedPoins: [Point] = []

    @IBOutlet private var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: graphView, action: #selector(GraphView.changedScale(_:))))
        }
    }
    @IBOutlet private var pointTableView: UITableView!

    private var imageGraph: UIImage!
    private var headerView: HeaderTableСoordinatesView!

    override func viewDidLoad() {
        super.viewDidLoad()
        pointTableView.register(UINib(nibName: "PointCell", bundle: nil), forCellReuseIdentifier: "PointCell")
        pointTableView.estimatedRowHeight = 44
        pointTableView.rowHeight = UITableView.automaticDimension
        pointTableView.tableFooterView = UIView(frame: CGRect.zero)
        graphView.sortedPoints = sortedPoins

        let frame = CGRect(x: 0, y: 0, width: self.pointTableView.frame.width, height: 44)
        let headerView = HeaderTableСoordinatesView(frame: frame)
        self.pointTableView.tableHeaderView = headerView
    }

    @IBAction private func SaveGraph(_ sender: Any) {
        imageGraph = graphView.asImage()
        saveImage(imageName: "Graph", image: imageGraph)
        share(image: imageGraph)
    }

    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }

    func share(image: UIImage) {
        let jpgImageData = image.jpegData(compressionQuality: 1.0)
        let jpgImageURL = jpgImageData?.dataToFile(fileName: "Graph.jpg")
        var filesToShare = [Any]()
        guard let imageURL = jpgImageURL else {
            return
        }
        filesToShare.append(imageURL)
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension GraphicViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedPoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PointCell", for: indexPath) as? PointCell {
            cell.configureWith(point: sortedPoins[indexPath.row], atIndex: indexPath.row + 1)
            return cell
        }
        return UITableViewCell()
    }
}
