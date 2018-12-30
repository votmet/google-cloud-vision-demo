//
//  AnalyzeViewController.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/6.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class AnalyzeViewController: UITableViewController, VisionAPI {
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var features: Array<[String : Any]> = [
        [
            "type": "LABEL_DETECTION",
            "maxResults": 10
        ],
        [
            "type": "LANDMARK_DETECTION",
            "maxResults": 10
        ],
        [
            "type": "WEB_DETECTION",
            "maxResults": 10
        ]
    ]
    var image: UIImage?
    var session: URLSession = URLSession.shared
    weak var dataTask: URLSessionDataTask?

    var annotations = [Annotation]()
    var uniqueDetections: JSON?
//    weak var segmentedControl: UISegmentedControl?

    var data: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the view
        self.title = "analyze_navigation_title".localized()
        self.view.backgroundColor = backgroundLightColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popToRoot))

        self.setupTableView()
//        setenv("CFNETWORK_DIAGNOSTICS", "3", 1)

        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        if let dataToParse = self.data {
            self.analyzeResults(dataToParse)
        } else {
            self.analyze()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let task = self.dataTask {
            task.cancel()
        }
    }

}
