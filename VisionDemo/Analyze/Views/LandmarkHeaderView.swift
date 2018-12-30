//
//  LandmarkHeaderView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class LandmarkHeaderView: UIView {

    weak var titleLabel: UILabel!
    private weak var tableView: UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 11.0, *) {
            titleLabel = self.label(font: UIFont.preferredFont(forTextStyle: .largeTitle), textColor: UIColor.white)
        } else {
            titleLabel = self.label(font: UIFont.preferredFont(forTextStyle: .title1), textColor: UIColor.white)
        }
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
        
        if self.constraints.count == 0 {
            self.setupConstraints()
        }
        if let tableView = self.tableView {
            var margins = tableView.layoutMargins
            margins.top = marginDefault
            margins.bottom = marginDefault
            self.layoutMargins = margins
        }
    }
    
    private func setupConstraints() {
        let margins = self.layoutMarginsGuide
        
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    }
    
}
