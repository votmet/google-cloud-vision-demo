//
//  SegmentedTableSectionHeader.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/4.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

class SegmentedTableSectionHeaderView: UITableViewHeaderFooterView {

    weak var segmentedControl: UISegmentedControl!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let segmentedControl = UISegmentedControl()
        self.contentView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.segmentedControl = segmentedControl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
