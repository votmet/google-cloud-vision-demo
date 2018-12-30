//
//  String+Localizable.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/16.
//  Copyright © 2018年 vmt. All rights reserved.
//

import Foundation

let UserDefaultsLangKey = "VisionDemo_lang"

extension String {
    func localized() ->String {
        guard let lang = UserDefaults.standard.string(forKey: UserDefaultsLangKey) else {
            return NSLocalizedString(self, comment: "")
        }
        var langAlias = lang
        if lang == "zh" {
            langAlias = "zh-Hans"
        }
        let path = Bundle.main.path(forResource: langAlias, ofType: "lproj")
        guard let bundlePath = path else {
            return NSLocalizedString(self, comment: "")
        }
        
        guard let bundle = Bundle(path: bundlePath) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
