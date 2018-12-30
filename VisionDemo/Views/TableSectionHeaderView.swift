//
//  TableSectionHeaderView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/7.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class TableSectionHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // setup background
        let backgroundView = UIView()
        backgroundView.backgroundColor = backgroundPrimaryColor
        self.backgroundView = backgroundView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.textLabel?.textColor = secondaryColor
    }
    
}
