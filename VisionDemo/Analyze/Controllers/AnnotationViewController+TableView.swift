//
//  LandmarkViewController+TableView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

private let kLandmarkCellIdentifier = "cell"

extension AnnotationViewController: UITableViewDataSource {
    func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = backgroundLightColor
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        
        let width = UIScreen.main.bounds.width
        let height = round(width / 16 * 9)
        let headerView = LandmarkHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: height - tableView.rowHeight / 2), tableView: tableView)
        headerView.titleLabel.text = self.annotation?.localized
        tableView.tableHeaderView = headerView
        let backgroundView = LandmarkBackgroundView()
        backgroundView.imageView.image = self.image
        tableView.backgroundView = backgroundView
        
        tableView.register(LandmarkTableViewCell.classForCoder(), forCellReuseIdentifier: kLandmarkCellIdentifier)
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        return tableView
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cells = self.cells else {
            return 0
        }
        return cells.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLandmarkCellIdentifier) as! LandmarkTableViewCell
        if let cells = self.cells {
            cell.keywordLabel.text = cells[indexPath.row].title
        }
        return cell
    }
}

extension AnnotationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cells = self.cells, let landmark = self.annotation else {
            return
        }
        let cellData = cells[indexPath.row]
        switch cellData.searchType {
        case .wiki:
            self.presentWiki(withKeyword: landmark.localized)
        case .keyword:
            self.presentGoogleSearch(withKeyword: "\(landmark.localized) \(cellData.title)")
        case .search:
            self.presentGoogleSearch(withKeyword: "\(landmark.localized)")
        }
    }
}
