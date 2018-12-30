//
//  LanguagesViewController.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/26.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

class LanguagesViewController: UITableViewController {

    let languages = [
        [
            "language": "en",
            "title": "English"
        ],
        [
            "language": "ja",
            "title": "日本語"
        ],
        [
            "language": "ko",
            "title": "한국인"
        ],
        [
            "language": "zh",
            "title": "简体中文"
        ]
    ]
    
    weak var selectedCell: UITableViewCell? {
        didSet {
            if let cell = selectedCell {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let language = languages[indexPath.row]
        cell.textLabel?.text = language["title"]
        
        if let lang = UserDefaults.standard.string(forKey: UserDefaultsLangKey) {
            if language["language"] == lang {
                self.selectedCell = cell
//                cell.accessoryType = .checkmark
            }
        }

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightDefault
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.selectedCell {
            cell.accessoryType = .none
        }
        self.selectedCell = tableView.cellForRow(at: indexPath)
        UserDefaults.standard.setValue(languages[indexPath.row]["language"], forKey: UserDefaultsLangKey)
    }

}
