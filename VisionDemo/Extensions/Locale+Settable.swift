//
//  Locale+Settable.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/27.
//  Copyright © 2018 vmt. All rights reserved.
//

import Foundation

extension Locale {
    static func userDefaultLocale() -> Locale {
        guard let lang = UserDefaults.standard.string(forKey: UserDefaultsLangKey) else {
            return Locale.current
        }
        return Locale(identifier: lang)
    }
    
    static var preferredLocale: Locale {
        let preferredLanguages = Locale.preferredLanguages
        guard let preferredLanguage = preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredLanguage)
    }
}
