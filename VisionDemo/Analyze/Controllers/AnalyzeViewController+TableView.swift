//
//  AnalyzeViewController+TableView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

private let kAnalyzeSectionHeaderIdentifier = "section_header"
private let kAnalyzeCellIdentifier = "cell"

extension AnalyzeViewController {
    func setupTableView() {
        self.tableView.sectionHeaderHeight = sectionHeaderHeightDefault
        self.tableView.rowHeight = cellHeightDefault
        self.tableView.backgroundColor = backgroundLightColor
        let width = UIScreen.main.bounds.width
        let height = round(width / 16 * 9)
        let headerView = AnalyzeHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        headerView.imageView.image = self.image
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.annotations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kAnalyzeCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: kAnalyzeCellIdentifier);
        }
        var annotations = self.annotations
        let annotation = annotations[indexPath.row]
        cell!.textLabel?.text = annotation.localized
        cell!.detailTextLabel?.text = annotation.localized != annotation.description ? annotation.description : nil
        switch annotation.detection {
        case .landmark:
            cell!.accessoryView = UIImageView(image: UIImage(named: "icon_landmark"))
        default:
            cell!.accessoryView = UIImageView(image: UIImage(named: "icon_search"))
        }
        cell!.backgroundColor = backgroundLightColor
        return cell!
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (self.spinner.isAnimating ? "analyze_section_title_analyzing" : "analyze_section_title_annotations").localized().uppercased()
    }
    
    @objc func onSegementedControlChange() {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var annotations = self.annotations
        let annotation = annotations[indexPath.row]
//        switch annotation.detection {
//        case .landmark:
            let annotationViewController = AnnotationViewController()
            annotationViewController.image = self.image
            annotationViewController.annotation = annotation
            self.navigationController?.pushViewController(annotationViewController, animated: true)
//        default:
//            self.presentGoogleSearch(withKeyword: annotation.localized)
//        }
    }
}
