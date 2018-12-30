//
//  SearchTableViewCell.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    weak var titleLabel: UILabel!
    weak var bodyLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var margins = self.contentView.layoutMargins
        margins.top = marginDefault
        margins.bottom = marginDefault
        self.contentView.layoutMargins = margins
        
        self.titleLabel = self.labelInCell(font: UIFont.preferredFont(forTextStyle: .headline))
        self.bodyLabel = self.labelInCell(font: UIFont.preferredFont(forTextStyle: .subheadline), textColor: secondaryColor)
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        self.bodyLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: marginInner).isActive = true
        self.bodyLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.bodyLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
}
