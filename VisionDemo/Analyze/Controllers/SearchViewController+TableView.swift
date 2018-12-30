//
//  SearchViewController+TableView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit
import SafariServices

private let kSearchCellIdentifier = "cell"

extension SearchViewController {
    func setupTableView() {
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(SearchTableViewCell.classForCoder(), forCellReuseIdentifier: kSearchCellIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSearchCellIdentifier) as! SearchTableViewCell
        cell.titleLabel.text = "Muji's Mountain : ) - Review of Muji Trekker, Lombok, Indonesia ..."
        cell.bodyLabel.text = "Muji Trekker: Muji's Mountain : ) - See 36 traveler reviews, 79 candid photos, and great deals for Lombok, Indonesia, at TripAdvisor."
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentGoogleSearch(withKeyword: "keyword")
    }
}
