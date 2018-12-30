//
//  DashboardHeaderView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/6.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class DashboardHeaderView: UIView {

    private weak var tableView: UITableView?
    private weak var actionView: DashboardHeaderActionView!
    
    weak var topView: DashboardHeaderTopView!
    weak var settingsButton: UIButton!
    weak var photoLibraryButton: UIButton!
    weak var cameraButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundPrimaryColor
        
        let topView = DashboardHeaderTopView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topView)
        self.topView = topView
        self.settingsButton = topView.settingsButton
        
        let actionView = DashboardHeaderActionView()
        actionView.backgroundColor = primaryColor
        actionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(actionView)
        self.actionView = actionView
        self.photoLibraryButton = actionView.photoLibraryButton
        self.cameraButton = actionView.cameraButton
        
        self.setupConstraints()
    }
    
    convenience init(frame: CGRect, tableView: UITableView) {
        self.init(frame: frame)
        self.tableView = tableView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let tableView = self.tableView {
            var margins = tableView.layoutMargins
            margins.top = 0
            margins.bottom = 0
            self.topView.layoutMargins = margins
        }
    }
    
    func reload() {
        self.topView.reload()
        self.actionView.reload()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        self.topView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.topView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        self.topView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.topView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        self.actionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.actionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        self.actionView.topAnchor.constraint(equalTo: self.topView.bottomAnchor).isActive = true
        self.actionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
}
