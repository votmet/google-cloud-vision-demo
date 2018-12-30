//
//  DashboardViewController+TableView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/6.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

private let kHistorySectionHeaderIdentifier = "section_header"
private let kHistoryCellIdentifier = "cell"

extension DashboardViewController {
    func setupTableView() -> UITableView {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = backgroundLightColor
        tableView.sectionHeaderHeight = sectionHeaderHeightDefault
        tableView.estimatedRowHeight = 218
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        // header
        let width = self.view.bounds.width
        let height = round(width / 16 * 9)
        let headerView = DashboardHeaderView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            ),
            tableView: tableView
        )
        headerView.cameraButton.addTarget(self, action: #selector(presentCamera), for: .touchUpInside)
        headerView.photoLibraryButton.addTarget(self, action: #selector(presentPhotoLibrary), for: .touchUpInside)
        headerView.settingsButton.addTarget(self, action: #selector(profile), for: .touchUpInside)
        tableView.tableHeaderView = headerView
        
        // remove the separator for empty content
        tableView.tableFooterView = UIView()
        
        // register reused elements
        tableView.register(TableSectionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: kHistorySectionHeaderIdentifier)
        tableView.register(HistoryTableViewCell.classForCoder(), forCellReuseIdentifier: kHistoryCellIdentifier)
        
        // add table view
        self.view.addSubview(tableView)
        
        // constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        return tableView
    }
    
    @objc private func profile() {
        let profileController = ProfileViewController(style: .grouped)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
}

extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func presentPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true)
        }
    }
    
    @objc func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            self.goToImagePreviewer(with: image)
        }
    }
    
    private func goToImagePreviewer(with image: UIImage) {
        self.navigationController?.pushViewController(PhotoPreviewerController(image: image), animated: true)
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kHistoryCellIdentifier) as? HistoryTableViewCell {
            do {
                let url = self.cachedURLs[indexPath.row]
                let fileName = url.pathComponents.last!.replacingOccurrences(of: self.dataExtension(), with: "jpeg")
                let data = try Data(contentsOf: url)
                cell.item = HistoryItem(imageURL: URL(fileURLWithPath: "\(self.historyImagesPath())/\(fileName)", relativeTo: DashboardViewController.historyURL()), data: data, dataURL: url)
            } catch {
                
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cachedURLs.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "history".localized().uppercased()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: kHistorySectionHeaderIdentifier)
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? HistoryTableViewCell {
            if cell.isTranslation {
                let translationVC = TranslationViewController()
                translationVC.data = cell.item?.data
                translationVC.image = cell.photoView.image
                translationVC.sourceText = cell.selectedKeywordLabel.text
                self.navigationController?.pushViewController(translationVC, animated: true)
            } else {
                let analyzeVC = AnalyzeViewController()
                analyzeVC.data = cell.item?.data
                analyzeVC.image = cell.photoView.image
                self.navigationController?.pushViewController(analyzeVC, animated: true)
            }
        }
        
    }
}
