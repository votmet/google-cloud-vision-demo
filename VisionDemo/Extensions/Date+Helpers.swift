//
//  Date+Helpers.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/9.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

extension Date {
    func stringUsedAsKey() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy_MM_dd"
        dateFormater.locale = Locale.preferredLocale
        return dateFormater.string(from: self)
    }
}
