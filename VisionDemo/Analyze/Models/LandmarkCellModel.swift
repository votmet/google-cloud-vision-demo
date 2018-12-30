//
//  LandmarkCellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/19.
//  Copyright © 2018年 vmt. All rights reserved.
//

import Foundation

struct LandmarkCellModel {
    enum SearchType: String {
        case wiki, search, keyword
    }
    let title: String
    let searchType: SearchType
}
