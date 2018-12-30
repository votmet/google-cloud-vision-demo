//
//  UIViewController+GoogleSearch.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/19.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit
import SafariServices
private let kGoogleDomains = [
    "en": "google.com",
    "ja": "google.co.jp",
    "ko": "google.co.kr",
    "zh": "google.com"
]
extension UIViewController {
    func presentGoogleSearch(withKeyword keyword: String) {
        var domain = "google.com"
        if let gd = kGoogleDomains[Locale.userDefaultLocale().languageCode ?? "en"] {
            domain = gd
        }
        print(domain)
        self.presentSafariViewController(withString: "https://\(domain)/search?q=\(keyword)")
    }
    
    func presentWiki(withKeyword keyword: String) {
        self.presentSafariViewController(withString: "https://\(Locale.userDefaultLocale().languageCode ?? "en").wikipedia.org/wiki/\(keyword)")
    }
    
    func presentSafariViewController(withString string: String) {
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedString) else {
            return
        }
        self.present(SFSafariViewController(url: url), animated: true, completion: nil)
    }
}
