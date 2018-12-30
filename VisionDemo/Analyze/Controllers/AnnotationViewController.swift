//
//  LandmarkViewController.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class AnnotationViewController: UIViewController {

    var image: UIImage?
    var annotation: Annotation? {
        didSet {
            self.title = annotation?.localized ?? annotation?.description
            var cells = [LandmarkCellModel]()
            cells.append(LandmarkCellModel(title: "Wiki".localized(), searchType: .wiki))
            if annotation?.detection == .landmark || annotation?.detection == .web {
                cells.append(LandmarkCellModel(title: "Experience Classroom".localized(), searchType: .keyword))
                cells.append(LandmarkCellModel(title: "Native Products".localized(), searchType: .keyword))
                cells.append(LandmarkCellModel(title: "Travel Guide".localized(), searchType: .keyword))
            }
            cells.append(LandmarkCellModel(title: "Search".localized(), searchType: .search))
            self.cells = cells
            if let tableView = tableView {
                tableView.reloadData()
            }
        }
    }
    var cells: Array<LandmarkCellModel>?
    private weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the view
//        self.title = "landmark_navigation_title".localized()
        self.view.backgroundColor = backgroundLightColor
        
        self.tableView = self.setupTableView()
    }

}
