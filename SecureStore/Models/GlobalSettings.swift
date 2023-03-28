//
//  GlobalSettings.swift
//  SecureStore
//
//  Created by macSlm on 03.03.2023.
//

import Foundation

class GlobalSettings  {
    static let shared = GlobalSettings()
    
    var language = "EN"
    
}

extension GlobalSettings {
    func toggleLanguage() {
        if language == "EN" {
            language = "RU"
        } else {
            language = "EN"
        }
    }
}
